function changeMWTname(pExp,MWTfsn,MWTfsncorr)

% find what's different
match = cell2mat(cellfun(@isequal,MWTfsn(:,2),MWTfsncorr(:,2),'UniformOutput',0));
diff = not(match);
if sum(diff) ==0;
   display('No file name changed.');
   return
end

% fix file names
[MWTfull] = getallMWTfiles(pExp); % get all files
for x = find(diff');   
    [oldfnameparse] = filenameparse3(MWTfull{x,2}); % parse ext names
    % get path
    pMWT = {};
    [pH,~] = fileparts(MWTfull{x,3}{1,1});
    pMWT(1:size(oldfnameparse,1),1) = {pH}; 
    % combine new name with old extension
    newname = {};
    newname(1:size(oldfnameparse,1),1) = MWTfsncorr(x,2);
    MWTfull{x,2} = cellfun(@strcat,newname,oldfnameparse(:,2),'UniformOutput',0);
    % create new path
    slash = {};
    slash(1:size(oldfnameparse,1),1) = {'/'};
    MWTfull{x,4} = cellfun(@strcat,pMWT,slash,MWTfull{x,2},'UniformOutput',0);
    % move files
    cellfun(@movefile,MWTfull{x,3},MWTfull{x,4});
    display(sprintf('%s file names corrected',MWTfull{x,1}));
end
display('file correction finished.');

end