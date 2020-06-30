function [MWTfsn] = validateMWTnamestructure(MWTfsn,pExp)
MWTfsncorr = MWTfsn;
nameall = MWTfsn(:,2);
display('Checking MWT name underscore structure...');
%% check for underscore number = 4
display('checking 4 underscores per name...');
undercell(1:size(nameall,1),1) = {'_'};
[underall] = cellfun(@regexp,nameall,undercell,'UniformOutput',0);
two(1:size(nameall,1),1) = {2};
undersize = cellfun(@size,underall,two);
wrongunder = find((undersize)~=4);
%% if no mistake, return
if isempty(wrongunder)==1;
    return
end

%% auto correct for common mistakes
% if position after 96h_20C is the only one that needs to be removed
display('Replace h_20C with h20C if found...');
[h2C] = gencellfunexpr(MWTfsn(:,2),'h_');
[h2Corr] = gencellfunexpr(MWTfsn(:,2),'h');
nameall = cellfun(@regexprep,MWTfsn(:,2),h2C,h2Corr,'UniformOutput',0);
MWTfsncorr(:,2) = nameall;
changeMWTname(pExp,MWTfsn,MWTfsncorr); % change file names
[MWTfsn] = draftMWTfname2('*set',pExp); % reload MWTfsn

%% if undersize = 0, check if no name


%% manual correction
if isempty(wrongunder)~=1;
    display(' ');
    display(sprintf('too many underscores "_" in %d files',size(wrongunder,1)));
    display('correct naming structure is: N2_5x3_t90h20C_100s30x10s10s_C1029ab');
    display(' ');
    for x = 1:size(wrongunder,1);   
        newname = MWTfsn{wrongunder(x,1),2};
        q1 = 0;
        while q1 ==0;
            display(' ');
            disp(newname);
            newname = input('Please enter correct full name:\n','s');
            q1 = input('is this correct (y=1,n=0)? ');
            switch q1
                case 1
                    % validate new name
                    [under] = regexp(newname,'_','start');
                    checkundersize = eq(size(under,2),4);
                    if checkundersize ==1;
                        MWTfsncorr{wrongunder(x,1),2} = newname;
                    else
                        display('new name entered is still contains incorrect number of underscores');
                        q1 = 0;
                    end
                otherwise
                    q1 = 0;
            end
        end
    end
end

%% correct
changeMWTname(pExp,MWTfsn,MWTfsncorr);
[MWTfsn] = draftMWTfname2('*set',pExp); % reload MWTfsn
end


%% [SUBFUN]
function changeMWTname(pExp,MWTfsn,MWTfsncorr)

% find what's different
match = cell2mat(cellfun(@isequal,MWTfsn(:,2),MWTfsncorr(:,2),'UniformOutput',0));
diff = not(match);
if sum(diff) ==0;
   display('no file name changed.');
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

function [MWTfsn] = draftMWTfname2(ext,pExp)
[MWTf,pMWTf] = dircontentmwt(pExp); % get only MWTf
MWTfsn = MWTf;
for x = 1:size(pMWTf,1); % for each MWTf
    cd(pMWTf{x,1}); % go to folder
    a = dir(ext); % list content
    a = {a.name}'; % get just the name of the file
    if (isempty(a) == 0); 
        MWTfsn{x,2} = a{1}(1:end-4); % name of file imported         
    else % in other situations
        display('Nothing imported for %s from [%s]',ext,MWTf{x,1});
        display('Use other extensions');
        a = dir
        a = {a.name}
        MWTfsn{x,2} = a{1}(1:end-4);
    end
end

end  

function [exprname] = gencellfunexpr(cell2match,expr)
    exprname(1:size(cell2match,1),1) = {expr};
end

function [parsefilename] = filenameparse3(filenames)
% function [c,header] = getMWTrunName_v20130705(cell, col))
% get run condition parts
 % declare output cell array
dot(1:size(filenames,1),1) = {'[.]'};
[ext,~,~,~,~,~,split] = cellfun(@regexp,filenames,dot,'UniformOutput',0);
fext = {};
for x = 1:size(filenames,1)
fext{x,1} = filenames{x,1}(ext{x,1}:end);
ffront(x,1) = split{x,1}(1,1);
end
%% find blobs
blob(1:size(filenames,1),1) = {'[_]\d\d\d\d\d[k][.][b][l][o][b][s]'};
[~,~,~,blobext,~,~,ffrontwblob] = cellfun(@regexp,filenames,blob,'UniformOutput',0);
for x = 1:size(filenames,1);
if isempty(blobext{x,1}) ==0;
    ffront(x,1) = ffrontwblob{x,1}(1);% replace ffront and fext
    fext(x,1) = blobext{x,1};
end
end
parsefilename = cat(2,ffront,fext);
end

function [MWTfull] = getallMWTfiles(pExp)
[MWTf,pMWTf] = dircontentmwt(pExp);
MWTfull = MWTf;
for x = 1:size(pMWTf,1);
    [MWTfull{x,2},MWTfull{x,3},~,~] = dircontent(pMWTf{x,1});
end
end

function [MWTf,pMWTf] = dircontentmwt(pExp)
%% main function
% You might like this function I made called 'dircontentmwt'! 
% [MWTf,pMWTf] = dircontentmwt(pExp)
% - pExp = character variable of the path of your experiment folder
% - MWTf = a cell array containing the name of MWT folders
% - pMWTf = a cell array containing the paths of MWT folders
% 
% It gets you only MWT folders name and path from a folder path 'pExp'. In the function file attached you can see how I validate the name of the dir..
% Use it like any regular function in Matlab, like [path,folder] = fileparts(x). fileparts is the function, and x, path,folder are all variables you can define.
% For example, if your experiment folder is in current path you can just use 'cd' like this:  [MWTf,pMWTf] = dircontentmwt(cd)
% If you don't want to have both output, for example, if you just want pMWTf you can go [~,pMWTf] =  dircontentmwt(cd)
% The '~' ignores the MWTf output.
% 
% 
% The pMWTf is useful for loop cd into each MWT folders, like this:
% 
% for x = 1:numl(pMWTf); % for each validated MWT folders
% 	cd(pMWTf{x});  % path to MWT folder on cell array row x
% end
[~,~,f,p] = dircontent(pExp);
filestruct(1:size(f,1),1) = {'\d\d\d\d\d\d\d\d[_]\d\d\d\d\d\d'};
t = cellfun(@regexp,f,filestruct,'UniformOutput',0);
i = find(cell2mat(t))';
MWTf = f(i,1);
pMWTf = p(i,1);
end


%% Subfunction
function [a,b,c,d] = dircontent(p)
% a = full dir, can be folder or files, b = path to all files, 
% c = only folders, d = paths to only folders
cd(p); % go to directory
a = {}; % create cell array for output
a = dir; % list content
a = {a.name}'; % extract folder names only
a(ismember(a,{'.','..','.DS_Store'})) = []; 
b = {};
c = {};
d = {};
for x = 1:size(a,1); % for all files 
    b(x,1) = {strcat(p,'/',a{x,1})}; % make path for files
    if isdir(b{x,1}) ==1; % if a path is a folder
        c(end+1,1) = a(x,1); % record name in cell array b
        d(end+1,1) = b(x,1); % create paths for folders
    else
    end
end
end




