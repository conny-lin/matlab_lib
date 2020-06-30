function [D,D1,DS] = findMWTval_DesignationDrive(pD)
%% look for all MWT in desgination paths
[D] = FindAllMWT(pD);

%% combine zip and unzipped files
DMWTfn = [D.MWTfn;D.MWTzipfnNoext];
display(sprintf('%d MWT files found',numel(DMWTfn)));
display(sprintf('%d/%d folder/zipped',...
    numel(D.MWTfn),numel(D.MWTzipfn)));

%% validate MWT content in designation paths
[~,~,~,~,D1] = validateMWTcontent(D.pMWTf);
% reporting
display(sprintf('%d/%d good/bad folders',...
    numel(D1.pMWTval),numel(D1.pMWTbad)));

% get unique good MWT files
DMWTfnGU = unique(D1.MWTfnval);
% get unique zip files
DMWTfnZU = unique(D.MWTzipfnNoext);

display(sprintf('%d/%d unique good MWT folder',...
    numel(DMWTfnGU),numel(D.MWTfn)));
display(sprintf('%d/%d unique MWT zip files',...
    numel(DMWTfnZU),numel(D.MWTzipfn)));

% combine zip and good folder
DMWTfnGUZ = [DMWTfnGU;DMWTfnZU];

DS.DMWTfnGU = DMWTfnGU;
DS.DMWTfnZU = DMWTfnZU;
DS.DMWTfnGUZ = DMWTfnGUZ;

end