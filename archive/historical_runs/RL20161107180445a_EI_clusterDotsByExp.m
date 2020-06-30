%% TIWI

%% INITIALIZING
clc; clear; close all;
%% PATHS
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pSave = setup_std(mfilename('fullpath'),'RL','genSave',false);

pSaveA = [fileparts(pSave),'/Dance_RapidTolerance'];
cd(pSaveA);
load Dance_RapidTolerance;



%% make boxes around scatter plot
name_postfix = 'clusterdots by exp';
eilist = {'TI','WI'};

msrlist = {'speed','curve'};

for msri = 1:numel(msrlist)
    msr = msrlist{msri};
    for ei = 1:numel(eilist)
    einame = eilist{ei};

    D = MWTSet.EI.(msr).(einame);
    a = regexpcellout(D.group,' ','split');
    b = a(:,1);
    e = regexpcellout(b,'\<\d{8}','match');
    D.expdate = e;
    d = D.(einame);
    g = D.expdate;
    close;
    lightblue = [0.301960796117783 0.745098054409027 0.933333337306976];
    clusterDotsErrorbar(d,g,'markersize',6,'scatterdotcolor',lightblue,...
        'yname',sprintf('%s (%s)',einame,msr),'xname','')
    xticklabel_rotate;
    savename = sprintf('%s %s %s',msr, einame,name_postfix);
    cd(pSaveA);
    savefig(savename);
    savefigpdf(savename,pSaveA);
    end
    

end