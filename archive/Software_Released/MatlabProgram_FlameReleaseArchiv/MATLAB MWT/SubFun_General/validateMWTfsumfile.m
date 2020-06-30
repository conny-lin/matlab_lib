function [MWTf,pMWTf,T,P] = validateMWTfsumfile(pExp)
%%
[MWTf,pMWTf,P,T] = getungroupedMWTfolders2(pExp); % get only MWTf
[MWTfsum] = getMWTfdatsamplename('*.summary',MWTf,pMWTf);
%%
t = find(cellfun(@isempty,MWTfsum(:,2)));
if isempty(t)==0; % if there is missing .summary file
    cd(pExp);
    mkdir('MissingSummaryfile');
    pMS = strcat(pExp,'/','MissingSummaryfile');
    for x = 1:size(t,1)
        p = pMWTf{t(x,1),1}; % get path of MWTf
        movefile(p,pMS); % move MWTf to missing sum file folder
    end
end

end