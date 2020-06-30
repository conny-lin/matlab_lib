function [pExpf,pzipmwt] = unzipMWT(pIn)
% get paths to folders containing MWT folders
% get all folder content disregard which level it is
[allpaths] = getalldir(pIn); % get paths to all folders under p path

%% get zip files from all dir
pzipf = {};
pExpf = {};
for x = 1:numel(allpaths)
   if isdir(allpaths{x}) ==1;
       [~,p] = dircontentext(allpaths{x},'*.zip');
       if isempty(p) ~=1;
           pExpf = [pExpf;allpaths(x)]; % record as it is exp folder
           pzipf = [pzipf;p];
       end
   end
end

%% find zip files that are MWT files
[fn,pzipmwt] = findzipIsMWTf(pzipf); 

%% unzip files
for x = 1:numel(pzipmwt)
    [p,fn] = fileparts(pzipmwt{x,1}); % get home path
    display(sprintf('unzipping files [%s], please wait...',fn));
    cd(p);
    unzip(pzipmwt{x,1},p); % unzip them all
    delete(pzipmwt{x,1}); % delete zip files
    display('done');
end


%% reporting
display(sprintf('%d zipped MWT files found',numel(pzipmwt)));
display(sprintf('in %d Experiment folders contains zipped MWT files',numel(pExpf)));






