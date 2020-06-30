%% INITIALIZING ++++++++++++++
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',true);
% addpath(pM);
% ----------------------------


%% load data +++++++++++++
pData = '/Users/connylin/Dropbox/FB Publication/20161115 Poster FB SfN lifestyle factor emotion/2-Materials&Methods/Data';
load(fullfile(pData,'Data.mat'));
% ----------------------------


%% prep data +++++++++++
categories = [{'age','gender','education','marital_status','working_status'} Zscore.Properties.VariableNames];
% convert to z score
User = Userinfo(:,{'age','gender','education'});
U = table2array(User);
for x = 1:size(U,2)
    u = U(:,x);
    i = ~isnan(u);
    uz = zscore(u(i));
    U(i,x) = uz;
end
% get marital status
a = LS_Ans(:,1);
a(a==4) = 0; % change single to 0
% get working status
b = LS_Ans(:,2);
b(b==0) = 2; % change working to 2
% combine
U = [U a b];

% get scores
S = Zscore;
S = table2array(S);

% combine user info and scores
Data = [U S];
% remove age = nan
i = isnan(User.age);
Data(i,:) = [];
User(i,:) = [];
% ----------------------------


%% plot data bar box plot ++++
figure()
boxplot(Data,'orientation','horizontal','labels',categories)
printfig('boxplot',pM,'w',6,'h',5);
% ----------------------------

%% check pairwise correlation +++
C = corr(Data,Data);
T = array2table(C,'VariableNames',categories,'RowNames',categories);
writetable(T,fullfile(pM,'correlation.csv'),'WriteRowNames',1);
% ----------------------------

%% pca +++
% use weight variance score if scores are of different scales with
% different variance
[wcoeff,score,latent,tsquared,explained] = pca(Data,'VariableWeights','variance');

%% component coefficients
c3 = wcoeff(:,1:3);

%% transform coefficients
coefforth = inv(diag(std(Data)))*wcoeff;

% check if coefficients are orthonormal
I = c3'*c3; % not really normal

%% component scores
cscores = zscore(Data)*coefforth;

%% plot component scores
figure()
plot(score(:,1),score(:,2),'+')
xlabel('1st Principle Component')
ylabel('2nd Principle Component')
printfig('test principle component',pM);
% type "gname" to label specific outliers

%% outlier examination (example)
ppl = [195 403 476 482 180];
User(ppl,:)


%% component variances
% latent is a vector containbg the variance explained by the corresponding
% principle component. Each column of score has a sample varaince equal to
% the corresponding row of latent
latent

%% percent variance explained
% the fifth output, explained, is a vector containing the percent variance
% explained by the corresponding principle component
explained
T = table;
T.component = (1:numel(explained))';
T.explained = explained;
T.total_explained = (cumsum(explained))./100;
writetable(T,fullfile(pM,'pca explained.csv'));


%% create scree plot
% make a scree plot of the percent variabiltiy explained by each principle
% component. The scree plot only shows the first 7 (except for the total 9)
% components that explained 95% of the total variance. The only clear break
% in the amount of variaance accounted for by each component is bewteen the
% first and the second components. 
figure()
pareto(explained)
xlabel('Principle Component')
ylabel('Variance Explained (%)')
printfig('scree plot',pM,'w',5,'h',5);

%% Hotelling's T-squared statistic
% a statistical measure of the multivariate distance of each observation
% from the center of the data set. this is an analytical way to find the
% most extrem points in the data.
[st2,index] = sort(tsquared,'descend');
extreme = index(1);
User(extreme,:)

%% visualize the results
% visualize both the orthonormal principal component coefficeints for each
% variable and the principle component scores for each observation in a
% single plot
var = categories;
var = regexprep(var,'LS_','');
var = regexprep(var,'_',' ');
var = regexprep(var,'EQ35','Stroop');
var = regexprep(var,'EQ37','Mood');

TARGETS = pairwisecomp_getpairs({'EQ35_score';'EQ37_score';'EQ35_RT';'EQ35_accuracy';
'EQ37_RT';'EQ37_accuracy';'age';'gender'});

for tii = 1:size(TARGETS,1)
    
    targetset = TARGETS(tii,:);
    [i,j] = ismember(targetset,categories);
    target = j;
    titlename = [var{target(1)}, '(1) ',var{target(2)},'(2)'];
    figure('Visible','off');
    biplot(coefforth(:,target),'scores',score(:,target),'varlabels',var);
    title(titlename)
    savefig(fullfile(pM,['pca plot ',titlename]));

    printfig(['pca plot ',titlename],pM,'w',7,'h',6);
end









































