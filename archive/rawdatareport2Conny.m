function rawdatareport2Conny(pRawC,expname)
[savename] = creatematsavenamewdate('NewRaw_','.mat');
cd(pRawC);
load('NewRaw.mat','NewRaw');
NewRaw(end+1,:) = {expname};
save('NewRaw.mat','NewRaw');