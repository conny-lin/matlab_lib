function [MWTfsn] = correctduplicatename(MWTfsn,pExp)
%%
display('Check for duplicated filenames...');
A = MWTfsn;
[uniquenameN,mwtN,P] = detectduplication(MWTfsn);
%% correct group code
while P ==0;
    display('Some MWT folder contains the same MWT run names');
    [MWTfsncorr] = fixgroupnameduplication(pExp,MWTfsn);
    changeMWTname(pExp,MWTfsn,MWTfsncorr);
    [MWTfsn] = draftMWTfname2('*.set',pExp); % reload MWTfsn
    [uniquenameN,mwtN,P] = detectduplication(MWTfsn);
end
display(' ');
display('All files contains unique MWT run names');
end


