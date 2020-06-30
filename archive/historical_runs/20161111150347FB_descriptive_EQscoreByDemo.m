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

msr = {'EQ35_score','EQ37_score','EQ35_accuracy','EQ37_accuracy','EQ35_RT','EQ37_RT'};
S = Zscore(:,msr);

Mtype = S.Properties.VariableNames;
% a = statsBasic(S(:,1),'outputtype','table');
% colnames = [a.Properties.VariableNames(2:end),{'unique_value'}];
% ST = nan(numel(Mtype),numel(colnames));
for x = 1:numel(Mtype)
    mtype = Mtype{x};
    s = S.(mtype);
    [anovatext,phtext,T] = anova1_std(s,agegroup)
    
% %     grpstats(s,agegroup,{'numel','mean','sem'})
%     return
%     st = statsBasic(S.(mtype));
%     st(end+1) = numel(unique(s));
%     ST(x,:) = st;
    fid = fopen(fullfile(pM,[mtype,' ANOVA.txt']),'w');
    fprintf(fid,'%s\n%s',anovatext,phtext);
    fclose(fid);
    writetable(T,fullfile(pM,[mtype,'.csv']));
end

return

ST = array2table(ST,'VariableNames',colnames);
T = table;
T.msr = Mtype';
T = [T ST];

writetable(T,fullfile(pM,'descriptive stats.csv'));

return

