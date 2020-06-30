%% TIWI

%% INITIALIZING
clc; clear; close all;
%% PATHS
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pSave = setup_std(mfilename('fullpath'),'RL','genSave',false);

pSaveA = [fileparts(pSave),'/Dance_RapidTolerance'];
cd(pSaveA);
load(fullfile(pSave,'Dance_RapidTolerance','Dance_RapidTolerance.mat'));



%% make boxes around scatter plot
lightblue = [0.301960796117783 0.745098054409027 0.933333337306976];
name_postfix = 'EI clusterdots NPlate';
msrlist = {'speed','curve'};
eilist = {'TI','WI'};
for msri = 1:numel(msrlist)
    msr = msrlist{msri};
    effectindex = {};
    effect = [];
    for ei = 1:numel(eilist)
        einame = eilist{ei};
        D = MWTSet.EI.(msr).(einame);
%         grp = D.group;
%         d = D.(einame);
%         A = grpstatsTable(d,grp);
%         A(:,{'se','sd','n'}) = [];
%         a = regexpcellout(A.gnameu,' ','split');
        xgroup = strjoinrows([repmat({einame},size(D,1),1) D.strain]);
        effectindex = [effectindex; xgroup];
        effect = [effect; D.(einame)];

    end
    clusterDotsErrorbar(effect,effectindex,...
        'markersize',6,'scatterdotcolor',lightblue,...
        'yname',sprintf('%s',msr),'xname','','visible','off');
    xticklabel_rotate;

    savename = sprintf('%s %s',msr,name_postfix);
    printfig(savename,pSaveA,'w',3,'h',3,'ext','pdf','closefig',1)
end











