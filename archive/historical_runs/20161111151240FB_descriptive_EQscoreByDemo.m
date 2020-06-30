%% INITIALIZING ++++++++++++++
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',true);
% addpath(pM);
% ----------------------------


%% SETTING +++++++++++++++++++
pData = '/Users/connylin/Dropbox/FB Publication/20161115 Poster FB SfN lifestyle factor emotion/2-Materials&Methods/Data';
% ---------------

%% load data +++++++++++++
load(fullfile(pData,'Data.mat'));
% ----------------------------


%% EQ descriptive +++++++++++++++
a = Userinfo.age;
agegroup = floor(a./10).*10;
gender = Userinfo.gender;
msr = {'EQ35_score','EQ37_score','EQ35_accuracy','EQ37_accuracy','EQ35_RT','EQ37_RT'};
S = Zscore(:,msr);

Mtype = S.Properties.VariableNames;

for x = 1:numel(Mtype)
    mtype = Mtype{x};
    s = S.(mtype);
    [anovatext,phtext,T] = anova1_std(s,agegroup);
    fid = fopen(fullfile(pM,[mtype,' x age ANOVA.txt']),'w');
    fprintf(fid,'%s\n',anovatext);
    for r = 1:size(phtext,1)
        fprintf(fid,'%s\n',phtext(r,:));
    end
    fclose(fid);
    writetable(T,fullfile(pM,[mtype,'x age.csv']));
end


for x = 1:numel(Mtype)
    mtype = Mtype{x};
    s = S.(mtype);
    [anovatext,phtext,T] = anova1_std(s,gender);
    fid = fopen(fullfile(pM,[mtype,' x gender ANOVA.txt']),'w');
    fprintf(fid,'%s\n',anovatext);
    for r = 1:size(phtext,1)
        fprintf(fid,'%s\n',phtext(r,:));
    end
    fclose(fid);
    writetable(T,fullfile(pM,[mtype,'x gender.csv']));
end

return







