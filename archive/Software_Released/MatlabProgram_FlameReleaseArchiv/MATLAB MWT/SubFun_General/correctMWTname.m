function correctMWTname(pExp,MWTfsnO,MWTfsncorr)
[MWTfull] = getallMWTfiles(pExp); % get all files
% find what's different
diff = cellfun(@strcmp,MWTfsnO(:,2),MWTfsncorr(:,2),'UniformOutput',0);
for x = find(eq(cell2mat(diff),0))';   
    [parsefilename] = filenameparse3(MWTfull{x,2}); % parse ext names
    newname = {};
    newname(1:size(parsefilename,1),1) = MWTfsncorr(x,2);
    MWTfull{x,2} = cellfun(@strcat,newname,parsefilename(:,2),'UniformOutput',0);
    slash(1:size(MWTfull{x,2},1),1) = {'/'};
    [pH,~] = fileparts(MWTfull{x,3}{1,1});
    pMWT(1:size(MWTfull{x,2},1),1) = {pH};
    MWTfull{x,4} = cellfun(@strcat,pMWT,slash,MWTfull{x,2},'UniformOutput',0);
    cellfun(@movefile,MWTfull{x,3},MWTfull{x,4});
    display(sprintf('%s file names corrected',MWTfull{x,1}));
end
display('file correction finished.');

end