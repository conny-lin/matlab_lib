%% INITIALIZING ++++++++++++++
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',false);
% addpath(pM);
% ----------------------------


%% SETTING +++++++++++++++++++
pData = '/Users/connylin/Dropbox/FB Publication/20161115 Poster FB SfN lifestyle factor emotion/2-Materials&Methods/Data';
% ---------------

%% load data +++++++++++++
load(fullfile(pData,'Data.mat'));
% ----------------------------


%% construct all score matrix
Mtype = {'score';'RT';'accuracy'};
EQmatrix = {'EQ35','EQ37'};
leg2 = {};
SMaster = [];
cn = 1;
for eqi = 1:numel(EQmatrix)
for x = 1:numel(Mtype)
    mtype = Mtype{x};
    s = eval([EQmatrix{eqi},'.(mtype)']);
    SMaster(:,cn) = s;
    leg1{x} = [EQmatrix{eqi},'_',mtype];
    cn = cn+1;
end
leg2 = [leg2 leg1];
end

leg =[{'total'};legend_LS_subsection.subsection(2:end)];
a = celltakeout(cellfunexpr(leg,'LS_'));
leg = strjoinrows([a leg],'');

S = [LS_Score.total LS_Score_subsection(:,2:end)];

SMaster = [SMaster S];
leg = [leg2';leg];
leg = regexprep(leg,' ','_');

T = array2table(SMaster,'VariableNames',leg);
Score = T;
save(fullfile(fileparts(pM),'Data.mat'),'Score','-append');

return


%% zscore

for eqi = 1:numel(EQmatrix)
for x = 1:numel(Mtype)
    mtype = Mtype{x};
    s = eval([EQmatrix{eqi},'.(mtype)']);
    s(:,2) = zscore(s);
    return
%     n = numel(unique(s));
%     hist(s,n);
%     titlename = ['EQ Stroop ',mtype];
%     title(titlename)
%     printfig(titlename,pM);
end
end



for x = 1:numel(Mtype)
    mtype = Mtype{x};
    s = EQ37.(mtype);
    n = numel(unique(s));
    hist(s,n);
    titlename = ['EQ MoodRecog ',mtype];
    title(titlename)
    printfig(titlename,pM);
end


%% Lifestyle
leg =[{'total'};legend_LS_subsection.subsection(2:end)];

S = [LS_Score.total LS_Score_subsection(:,2:end)];

for x = 1:size(S,2)
    mtype = leg{x};
    s = S(:,x);
    n = numel(unique(s));
    hist(s,n);
    titlename = ['LS ',mtype];
    title(titlename)
    printfig(titlename,pM);
end
return
























