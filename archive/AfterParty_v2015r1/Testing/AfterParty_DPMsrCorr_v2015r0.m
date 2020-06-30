% function AfterParty_DPMsrCorr_v2015r0
pData = '/Users/connylin/Dropbox/Dissimination/20150624 Worm Meeting/Results/Analysis/30m after exposure/assay 10m/Dance_DrunkPosture2 20150602132642 10min 600s name corr';
cd(pData); load('matlab.mat');
%% load data
D = MWTSet.Data.ByPlates;

%% convert obs into one col
msr = fieldnames(D.Y);
D1 = [];
for msri = 1:numel(msr)
    d = D.Y.(msr{msri});
    m = size(d,1)*size(d,2);
    x = reshape(d,m,1);
    D1(:,msri) = x;
end

%% create dataset
dd = dataset({D1,msr{:}});
corrplot(dd);
savefigpdf('Msrcorr',pData);
