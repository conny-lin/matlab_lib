function [Expfdat,MWTftrv,MWTfdat,pmat] = Import(MWTfname,pExp,pSaveExp)           %% primary function

%% import summary .dat
ext = '*.dat';
r = 5;
c = 1;
[Expfdat] = importsumdata(pExp,ext,r,c);  


%% import .trv file
ext = '*.trv';
r = 5;
c = 0;
d = ' ';
[MWTftrv] = importmwtdata(ext,MWTfname,r,c,d,pExp);


%% import .dat file 
ext = '*.dat';
r = 5;
c = 0;
d = ' ';
[MWTfdat] = importmwtdata(ext,MWTfname,r,c,d,pExp);


%% save imports
clearvars c d ext r; 
cd(pSaveExp);
save('import.mat');
pmat = strcat(pSaveExp,'/','import.mat');
end
