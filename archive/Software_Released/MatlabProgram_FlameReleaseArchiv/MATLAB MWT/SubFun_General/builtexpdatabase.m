
%% STEP1: PATHS [Need flexibility] 
clearvars -except option
pMaestro = '/Volumes/AWLIGHT/MWT/Archived Analysis/Maestro';
pRose = '/Volumes/Rose/MultiWormTrackerPortal/MWT_Analysis_20130811';
pFun = '/Users/connylinlin/MatLabTest/MultiWormTrackerPortal/MWT_Programs';
pSet = '/Users/connylinlin/MatLabTest/MultiWormTrackerPortal/MWT_Programs/MatSetfiles';
pSum = '/Volumes/Rose/MultiWormTrackerPortal/Summary';
pSave = '/Users/connylinlin/Documents/Work/MWT Data Analysis';
pIronMan = '/Volumes/IRONMAN';
addpath(genpath(pFun));
HomePath = pRose;
O = []; % [CODE] Define output O % temperary assign O = nothing
%% OBJECTIVE: CREATE EXP DESCRIPTION DATA BASE
%% PATH
pA = '/Users/connylinlin/Documents/Work/MWT Data Analysis/Individual Exp ShaneSpark';
%% set up data base
[~,~,Expfn,pExpf] = dircontent(pA);
a = celltakeout(regexp(Expfn,'_','split'),'split');
e1 = celltakeout(regexp(a(:,1),'\<\d{8}','match'),'singlerow');
e2 = celltakeout(regexp(a(:,2),'\<([A-Z][A-Z])\>','match'),'singlerow');
e3 = celltakeout(regexp(a(:,1),'[A-Z]\>','match'),'singlerow');
e4 = celltakeout(regexp(a(:,3),'\d+[s]\d+[x]\d+[s]\d+[s]','match'),'singlerow');
e52 = celltakeout(regexp(a(:,2),'\<[a-z]+\>','match'),'singlerow');
e53 = celltakeout(regexp(a(:,3),'\<[a-z]+\>','match'),'singlerow');
e54 = celltakeout(regexp(a(:,4),'\<[a-z]+\>','match'),'singlerow');
e55 = celltakeout(regexp(a(:,5),'\<[a-z]+\>','match'),'singlerow');
e56 = celltakeout(regexp(a(:,6),'\<[a-z]+\>','match'),'singlerow');
[under] = cellfunexpr(e52,'_');
e5 = strcat(e52,under,e53,under,e54,under,e55,under,e56);
%% 
EHeader = {'date','expter','tracker','run_condition','note',...
    'groups','description'};
E = [e1,e2,e3,e4,e5];
%%
cd(pA); save('ExpDescription.mat','E','EHeader');
%%
str = 'enter description for %s';
y = x;
for x = y:size(E,1); display(sprintf(str,strcat(E{x,1},E{x,2})));
E{x,7} = input(': ','s'); end





