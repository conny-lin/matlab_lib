% function AfterParty_btwExpMsrCorr

pData = '/Users/connylin/Dropbox/Dissimination/20150624 Worm Meeting/Results/Analysis/30m after exposure/assay 10m/Dance_DrunkPosture2 20150602132642 10min 600s name corr';
cd(pData); load('matlab.mat');
% load data
D = MWTSet.Data.ByPlates;

%% separate by exp
pMWT = D.pMWT;
msr = fieldnames(D.Y);

[en,gn] = mwtpath_parse(pMWT,{'expname','gname'});
a = regexpcellout(en,'_','split');
en = cellfun(@strcat,cellfunexpr(a(:,1),'e'),a(:,1),'UniformOutput',0);
% eng = cellfun(@strcat,en,cellfunexpr(en,'_'),gn','UniformOutput',0);

%%
engU = unique(eng);
enUind = cell(size(engU));
for engUi = 1:numel(engU)
   i = ismember(eng,engU);
   enUind{engUi} = find(i);
end

%%
ctrli = ismember(gn,'N2');
d = D.Y.Speed(:,ismember(gn','N2') & ismember(en,'e20130403X'));
x = reshape(d,size(d,1)*size(d,2),1);
d = D.Y.Speed(:,ismember(gn','N2_400mM') & ismember(en,'e20130403X'));
y = reshape(d,size(d,1)*size(d,2),1);

scatter(x,y)

%%
ctrlname = {'N2'};

for msri = 1%:numel(msr)
    for enUi = 1:numel(enU)
        d = D.Y.(msr{msri})(:,enUind{enUi});
        n = size(d,1)*size(d,2);
        D1.(msr{msri})(:,enUi) = reshape(d,n,1);

    end
    dd = dataset({D1.(msr{msri}),enU{:}});
    [r,pv] = corrplot(dd);
end


%% convert obs into one col

D1 = [];
for msri = 1%:numel(msr)
D.Y.(msr{msri})    
%     
%     d = D.Y.(msr{msri});
%     m = size(d,1)*size(d,2);
%     x = reshape(d,m,1);
%     D1(:,msri) = x;
end

%% create dataset
dd = dataset({D1,msr{:}});
corrplot(dd);
savefigpdf('Msrcorr',pData);
