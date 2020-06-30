%% GENERATE DATA FOR FIRST DRAFT

%% initializing
clear; clc; close all;
%% add paths
pSave = mfilename('fullpath'); if isdir(pSave) == 0; mkdir(pSave); end
%% ADD FUNCTION PATH
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pFun = {'/Users/connylin/Dropbox/Code/Matlab/Library';
        '/Users/connylin/Dropbox/fb/publication/Manuscript Lifestyle Paul/Data/Code'};
addpath_allsubfolders(pFun);
% deposit current code
pDepository = '/Users/connylin/Dropbox/Code/Matlab/Working Depository';
name = sprintf('%s/FB%sa_%s.m',pDepository,generatetimestamp,mfilename);
copyfile([mfilename('fullpath'),'.m'],name);
% copy current code
copyfile([mfilename('fullpath'),'.m'],[pSave,'/',mfilename,'_a',generatetimestamp,'.m']);
% clear memory
clear pFun name


%% import data
% import data (only included compeleted responses)
pData ='/Users/connylin/Dropbox/fb/Database/LifeAssessment_20140314/Matlab';
load([pData,'/LA_master_20160111.mat']);


%% get valid data
% (20160112-1057)
% for users with full demographic info and given complete responses
% - 3 people reported age > 90 and 3 reported age > 100
% - 3300 reported age 10-19
% - exclude age > 90
% - first answers only
[UI,ANSV] = getValidUserAndAnswerSet(User_Info,ANS,1);


%% =========== yes and no questions by gender and age =====================
% get answers as array
B = table2array(ANSV(:,7:end));

% index to yes no questions
B(:,Index_MultipleChoiceQuestions) = [];

% make table
T = table;
T.question_text = Legend_Questions(Index_YesNoQuestions);

% separate by gender
[u_gender,legend_gender] = separate_userid_by_gender(UI.gender, UI.user_id);

% separate answer by gender
YesAns = nan(size(B,2),numel(u_gender));
for x = 1:numel(u_gender)
    i = ismember(ANSV.user_id, u_gender{x});
    A = B(i,:);
    N = size(A,1);
    cnt = sum(A,1)';
    no = (cnt./N);
    yes = ones(size(cnt))-no;
    YesAns(:,x) = yes;
end
% make table
T1 = array2table(YesAns,'VariableNames',legend_gender);
% put in output table
T = [T T1];

% separate by age
% separate user id into age group
agegroup = convertAge2AgeGroup_5yr(UI.age);
[u_ageroup, agegroupU] = separate_userid_by_age(agegroup, UI.user_id);

% separate answer by age
YesAns = nan(size(B,2),numel(u_ageroup));
for x = 1:numel(u_ageroup)
    i = ismember(ANSV.user_id, u_ageroup{x});
    A = B(i,:);
    N = size(A,1);
    cnt = sum(A,1)';
    no = (cnt./N);
    yes = ones(size(cnt))-no;
    YesAns(:,x) = yes;
end

% legend
name = cell(size(agegroupU,1),1);
for x = 1:numel(agegroupU)
    name{x} = sprintf('age_%d',agegroupU(x));
end

% make table
T1 = array2table(YesAns,'VariableNames',name);
% put in output table
T = [T T1];

% export table
name = 'reponse_yes_percent_byGenderAge';
writetable(T,sprintf('%s/%s.csv',pSave,name));



%% look at answers for multiple answer questions
% get answers as array
B = table2array(ANSV(:,7:end));
B = B(:,Index_MultipleChoiceQuestions);

% separate by gender
[u_gender,legend_gender] = separate_userid_by_gender(UI.gender, UI.user_id);
% separate answers by gender
A_Gender = cell(size(legend_gender));
for x = 1:numel(u_gender)
    i = ismember(ANSV.user_id, u_gender{x});
    A_Gender{x} = B(i,:);
end



% separate by age
% separate user id into age group
agegroup = convertAge2AgeGroup(UI.age);
[u_ageroup, agegroupU] = separate_userid_by_age(agegroup, UI.user_id);
% separate answers by gender
A_Age = cell(size(agegroupU));
for x = 1:numel(u_ageroup)
    i = ismember(ANSV.user_id, u_ageroup{x});
    A_Age{x} = B(i,:);
end
% legend
name = cell(size(agegroupU,1),1);
for x = 1:numel(agegroupU)
    name{x} = sprintf('age_%d',agegroupU(x));
end
legend_age = name;



% calculate percentage
qind = find(Index_MultipleChoiceQuestions);
for qi = 1:size(A,2)
    % answer text
    anstext = Legend_Answers(qind(qi),:)';
    anstext(cellfun(@isempty,anstext)) = [];
    % question text
    q_text = Legend_Questions(qind(qi));
    q_text = regexprep(q_text,'?','');
    q_text = char(strrep(q_text,' ','_'));
    
    % calcualte percent answers gender
    PCT = zeros(numel(anstext),numel(A_Gender));
    for x = 1:numel(A_Gender)
       d = A_Gender{x}(:,qi);
       a = tabulate(d);
       ans_ind = a(:,1)+1;
       pct = a(:,3)./100;
       PCT(ans_ind,x) = pct;
    end
    T_Gender = array2table(PCT,'VariableNames',legend_gender);

     % calcualte percent answers age
    PCT = zeros(numel(anstext),numel(A_Age));
    for x = 1:numel(A_Age)
       d = A_Age{x}(:,qi);
       a = tabulate(d);
       ans_ind = a(:,1)+1;
       pct = a(:,3)./100;
       PCT(ans_ind,x) = pct;
    end
    T_Age = array2table(PCT,'VariableNames',legend_age);

    % export table
    T = table;
    T.(q_text) = anstext;
    T = [T T_Gender T_Age];
    
    % export table
    name = ['response by age gender ',q_text];
    writetable(T,sprintf('%s/%s.csv',pSave,name));

end
  







