%% PATHS
pFunD ='/Users/connylin/Dropbox/MATLAB/Functions_Developer';
addpath(pFunD);

%% Home Database
pDatabase = '/Volumes/Rose/MWT_Data';
%[MWTDatabase] = MWTDataBase_searchAll(pDatabase);
%%
%% get MWT folder names
MWTfnBad = MWTDatabase(strcmp(MWTDatabase.type,'MWT_bad'),:);
MWTfn = MWTDatabase(strcmp(MWTDatabase.type,'MWT'),:);


% check into each MWT folder for integrity
[fn,pf] = cellfun(@dircontent,MWTfn.folderpath,'UniformOutput',0);

%%
% A = [fn,pf];
val = false(numel(fn),1);
for x = 1:numel(fn)
    
   val(x,1) = sum(regexpcellout(fn{x},'([.]blob)|([.]blobs)'))>1 &...
       sum(regexpcellout(fn{x},'set'))>0 &...
       sum(regexpcellout(fn{x},'png'))>0 &...
       sum(regexpcellout(fn{x},'summary'))>0;
   
end
%%
MWTbad = MWTfn(val==false,:);
MWTbad.foldername
sum(val)

%% GET MWT FOLDERS
pS = '/Volumes/IRONMAN/Data_condense_sort';
[S] = MWTDataBase_searchAll(pS);

%% get MWT folder names
clear MWTfnS
i = regexpcellout(S.type,'MWT');
MWTfnS = S(i,:);
display(sprintf('%d/%d unique MWT files',...
    numel(unique(MWTfnS.foldername)),numel(MWTfnS.foldername)));
b = zeros(size(MWTfnS.foldername));
for x = 1:numel(MWTfnS.foldername)
    a = dir(MWTfnS.folderpath{x});
    b(x,1) = sum(cell2mat({a.bytes}));
end
MWTfnS.filesize = b;

%% find unique file names
b = unique(MWTfnS.foldername);

%% compare with good MWT files
i = ismember(b,MWTfnBad.foldername);
display(sprintf('%d found files matches bad MWT files in database',...
    sum(i)));

i = ~ismember(b,MWTfn.foldername);
display(sprintf('%d new files found not in database',...
    sum(i)));
disp(b(i));
LostMWT = b(i);
%% find paths
pMWTS = MWTfnS.folderpath(ismember(MWTfnS.foldername,b(i)));
%% look into content of paths
str = '*.blobs';
i = ~cellfun(@isempty,cellfun(@dircontent,pMWTS,...
    cellfunexpr(pMWTS,str),'UniformOutput',0));
if sum(i) == 0
    display(sprintf('no %s files found',str));
else
    display(sprintf('there is %s files, hopeful',str));
end

p = pMWTS(i);
for x = 2:numel(p)
   display(sprintf('x=%d: %s',x,p{x} ));
   if input('1-continue, 0-stop: ') == 0
       x
       break
   end
end

%%
[~,~,a,~] = cellfun(@dircontent,pMWTS,'UniformOutput',0);

p = pMWTS(~cellfun(@isempty,a));
for x = 1:numel(p)
   display(sprintf('x=%d: %s',x,p{x} ));
   if input('1-continue, 0-stop: ') == 0
       x
       break
   end
end

%%
iblob)
%% go through each folder
for x = 1:numel(pMWTS)
   dir(pMWTS{x}) 
   i = input('1-continue, 0-stop');
   if i == 0
       x
   end
   
   
end




%% find number of repeated MWT files
a = tabulate(MWTfnS.foldername);
a = a(:,1:2);
%% find single copies
clear b;
b = a(cell2mat(a(:,2)) == 1,1);
%%
[f,p] = cellfun(@dircontent,pf,cellfunexpr(pf,'*.zip'),...
    'UniformOutput',0);
ff = [f,p];
sourcezip = ff(~cellfun(@isempty,ff(:,1)),:);
a = celltakeout(sourcezip(:,1),'multirow');
b = celltakeout(sourcezip(:,2),'multirow');
sourceziplist = [a,b];

% get mwt zip files
[p1,f1] = cellfun(@fileparts,sourceziplist(:,2),'UniformOutput',0);
sourceziplist = [f1,sourceziplist(:,2),p1,...
    repmat({'zip'},size(sourceziplist,1),1)];
i = regexpcellout(sourceziplist(:,1),'(\<(\d{8})[_](\d{6})\>)');
sourcemwtzip = sourceziplist(i,:);
source2unzip = sourceziplist(~i,:);


%% manually unzip files
source2unzip{end,2}


%% find MWT zip files
[~,filenames] = cellfun(@fileparts,filepaths,'UniformOutput',0);
i = regexpcellout(filenames,'(\<(\d{8})[_](\d{6})\>)');
k = find(i);
display(sprintf('%d MWT zip files found',numel(k)));
mwtfound1 = [filenames(k),filepaths(k),...
    repmat({'zip'},size(filenames(k),1),1)];




%% FIND MWT FOLDERS
% get all folder paths
[pf,fn] = getalldir(pS);
%%

[~,fn] = cellfun(@fileparts,pf,'UniformOutput',0);

i = regexpcellout(fn,'(\<(\d{8})[_](\d{6})\>)');
display(sprintf('%d MWT folder found',sum(i)));
mwtfile = pf(i);
mwtfound2 = [fn(i),pf(i),repmat({'folder'},numel(fn(i)),1)];

%%
mwtlist = [mwtfound1;mwtfound2];
%%

% MOVE MWT FOLDERS
% move file
pSave = '/Users/connylin/Documents/MWTfolder_Data_Found';
new = cellfun(@strcat,cellfunexpr(mwtfile,pSave),mwtfile,...
    'UniformOutput',0);
newhome = cellfun(@fileparts,new,'UniformOutput',0);
cellfun(@mkdir,new)
for x = 3:numel(new)
   movefile(mwtfile{x},newhome{x})
end
% find(i)


%% SURVEY ZIP FILES
pS = '/Users/connylin/Documents/Archive';
[pf,fn] = getalldir(pS);

filepaths = {};
for x = 1:numel(pf)
    cd(pFunD);
    p = pf{x};
    [b,c,d,e] = dircontent(p);
    if isempty(d) == 1
        h = cellfun(@strcat,cellfunexpr(b,[pf{x},'/']),...
                b,'UniformOutput',0);
            filepaths = [filepaths;h];
    else
        g = setdiff(b,d);
        if isempty(g) ==0
            h = cellfun(@strcat,cellfunexpr(g,[pf{x},'/']),...
                g,'UniformOutput',0);
            filepaths = [filepaths;h];
        end
    end
end

% find zip files
a = regexpcellout(filepaths,'/','split');
b = a(:,2:end);
filename = cell(size(b,1),1);
for x = 1:size(a)
    i = find(~cellfun(@isempty,b(x,:)));
    filename(x,1) = b(x,i(end));
end

i = regexpcellout(filename,'[.]zip\>');
sum(i)
k = find(i);


% survey zip files
x1 = 2;

for x = x1:numel(k)
    disp(filename{k(x)})
    disp(filepaths{k(x)})
    if input('unzip (y=1)?') == 1
        [p,fn] = fileparts(filepaths{k(x)});
        mkdir(p,fn);
        unzip(filepaths{k(x)},[p,'/',fn]);
        display(sprintf('x = %d',x));
    else
        avoidlist(end+1) = filepaths(k(x));
        
    end
end


%% GET RID OF EMPTY FOLDERS
pS = '/Users/connylin/Documents/MWTzip_Data_Found';

[pf,fn] = getalldir(pS);

% survey content in folder
[fa,pa] = cellfun(@dircontent,pf,'UniformOutput',0);

i = cellfun(@isempty,pa);
j = ismember(pf,savelist);
i(j) = false;
k = find(i);
k


x1 = 1;

for x = x1:numel(k)
    x2 = x;
    pT = pf{k(x)};
    [~,fnn] = fileparts(pf{k(x)});
    display(sprintf('x=%d: %s',x,fnn));
    disp(pT);
%     dir(pT);
   rmdir(pT,'s'); 

%     i = input('delete (y=1) save(2)? ');
%     if i == 1
%        rmdir(pT); 
%     elseif i == 2
%         savelist{end+1,1} = pf{k(x)};
%     else
%         disp(x)
%         break
%     end
end


%% GET ALL GROUP FILES
p = '/Users/connylin/Documents/Archive/Lab Data MWT Expter';
[~,~,f,p1] = dircontent(p);
[f2,p2] = cellfun(@dircontent,p1,'UniformOutput',0);

% remove empty folder
i = cellfun(@numel,f2);
delf = p1(i == 0);
if isempty(delf) == 0
cellfun(@rmdir,delf,cellfunexpr(delf,'s'));
end

for x = 1:numel(f2)
    [a,pa] = dircontent(p1{x},'Group*');
    disp(a)
    if isempty(a) == 0
        cellfun(@movefile,pa,cellfunexpr(pa,p))
    elseif isempty(a) == 1
        rmdir(p1{x},'s');
    else
        disp(x)
        break
    end
end

%% FIND ROSE FILE INTEGRITY
[RoseData] = GetStdMWTDataBase('/Volumes/Rose/MWT_Data');
MWTfn = RoseData.MWTfn;
pMWT = RoseData.pMWTf;

% see if pMWT are all full files
fn2 = [MWTfn,pMWT];
fn2 = sortrows(fn2,1);
mwtfile = fn2(:,2);
a = cellfun(@dircontent,mwtfile,cellfunexpr(mwtfile,'*.blobs'),...
    'UniformOutput',0);
fn2(:,3) = num2cell(cellfun(@numel,a));
a = cellfun(@dircontent,mwtfile,cellfunexpr(mwtfile,'*.summary'),...
    'UniformOutput',0);
fn2(:,4) = num2cell(cellfun(@numel,a));
a = cellfun(@dircontent,mwtfile,cellfunexpr(mwtfile,'*.set'),...
    'UniformOutput',0);
fn2(:,5) = num2cell(cellfun(@numel,a));
a = cellfun(@dircontent,mwtfile,cellfunexpr(mwtfile,'*.png'),...
    'UniformOutput',0);
fn2(:,6) = num2cell(cellfun(@numel,a));
a = cellfun(@dircontent,mwtfile,cellfunexpr(mwtfile,'*.trv'),...
    'UniformOutput',0);
fn2(:,7) = num2cell(cellfun(@numel,a));
a = cellfun(@dircontent,mwtfile,cellfunexpr(mwtfile,'*.dat'),...
    'UniformOutput',0);
fn2(:,8) = num2cell(cellfun(@numel,a));
a = cellfun(@dircontent,mwtfile,cellfunexpr(mwtfile,'*.zip'),...
    'UniformOutput',0);
fn2(:,9) = num2cell(cellfun(@numel,a));

a = cell2mat(fn2(:,3:6));
a(:,5) = a(:,1) > 0;
a(:,6) = sum(a(:,2:5),2);
i = a(:,6) == 4;

display(sprintf('%d/%d full MWT raw file',sum(i),numel(i)));
rosefiles = fn2;





%% SEE INTEGRITY OF FOUND FILES 
pS = '/Users/connylin/Documents/MWTzip_Data_Found';

[pf,fn] = getalldir(pS);
[~,fn1] = cellfun(@fileparts,pf,'UniformOutput',0);
i = regexpcellout(fn1,'(\<(\d{8})[_](\d{6})\>)');
display(sprintf('%d MWT folder found',sum(i)));
mwtfile1 = pf(i);

% find files that has full MWT raw fles
fn2 = {};
[p2,fn2] = cellfun(@fileparts,mwtfile1,'UniformOutput',0);
fn2(:,2) = mwtfile1;
fn2 = sortrows(fn2,1);
mwtfile = fn2(:,2);
a = cellfun(@dircontent,mwtfile,cellfunexpr(mwtfile,'*.blobs'),...
    'UniformOutput',0);
fn2(:,3) = num2cell(cellfun(@numel,a));
a = cellfun(@dircontent,mwtfile,cellfunexpr(mwtfile,'*.summary'),...
    'UniformOutput',0);
fn2(:,4) = num2cell(cellfun(@numel,a));
a = cellfun(@dircontent,mwtfile,cellfunexpr(mwtfile,'*.set'),...
    'UniformOutput',0);
fn2(:,5) = num2cell(cellfun(@numel,a));
a = cellfun(@dircontent,mwtfile,cellfunexpr(mwtfile,'*.png'),...
    'UniformOutput',0);
fn2(:,6) = num2cell(cellfun(@numel,a));
a = cellfun(@dircontent,mwtfile,cellfunexpr(mwtfile,'*.trv'),...
    'UniformOutput',0);
fn2(:,7) = num2cell(cellfun(@numel,a));
a = cellfun(@dircontent,mwtfile,cellfunexpr(mwtfile,'*.dat'),...
    'UniformOutput',0);
fn2(:,8) = num2cell(cellfun(@numel,a));
a = cellfun(@dircontent,mwtfile,cellfunexpr(mwtfile,'*.zip'),...
    'UniformOutput',0);
fn2(:,9) = num2cell(cellfun(@numel,a));


a = cell2mat(fn2(:,3:6));
a(:,5) = a(:,1) > 0;
a(:,6) = sum(a(:,2:5),2);
i = a(:,6) == 4;

display(sprintf('%d full MWT raw file',sum(i)));
sourcefiles = fn2;

%% LOOK FOR FULL FILES IN SOURCE
% find bad rose files
a = cell2mat(rosefiles(:,3:6));
i = sum(a(:,2:4),2)<3;
j = a(:,1) ==0;
i(j) = true;
badrf = rosefiles(i,:);
display(sprintf('%d bad rose files',size(badrf,1)));


% find good source files
a = cell2mat(sourcefiles(:,3:6));
i = sum(a(:,2:4),2)==3;
j = a(:,1) ==0;
i(j) = false;
goodsf = sourcefiles(i,:);
display(sprintf('%d good source files',size(goodsf,1)));

% match
[i,k] = ismember(goodsf(:,1),badrf(:,1));
matchgoodsf = goodsf(i,:);
display(sprintf('%d good source files matches bad source files',...
    size(matchgoodsf,1)));

% manual transfer
for x = 1:size(matchgoodsf)
    disp(sprintf('x=%d: %s',x,matchgoodsf{x,1}));
    disp(matchgoodsf{x,2});

    if input('stop=1: ') == 1
        break
    end
end

%% LOOK FILE BY FILE
for x = 472:size(sourcefiles,1)
    sfn = sourcefiles{x,1};
    
    i = ismember(rosefiles(:,1),sfn);
    if sum(i) > 1
        display('duplicate rose files');
        rosefiles{i,2}
        x
        break
    end
    if isequal(rosefiles{find(i),1},sfn) ==1
        display(sprintf('x=%d,same MWT name: %s',x,sfn))
    else
        x
        break
    end
    display('rose file content:');
    disp(rosefiles{i,2});
    [fn,p] = dircontent(rosefiles{i,2});
    [~,gn] = fileparts(fileparts(rosefiles{i,2}));
    disp(sprintf('groupname: %s',gn));
    k = find(regexpcellout(fn,'.blobs'));
    j = find(regexpcellout(fn,'.set'));
    h = find(regexpcellout(fn,'.summary'));
    n = find(regexpcellout(fn,'.png'));
    k = [k;j;h;n];
    rff = fn(k);
    disp(rff);
    
    display('sourcefile content:')
    disp(sourcefiles{x,2});
    [fn,p] = dircontent(sourcefiles{x,2});
    k = find(regexpcellout(fn,'.blobs'));
    j = find(regexpcellout(fn,'.set'));
    h = find(regexpcellout(fn,'.summary'));
    n = find(regexpcellout(fn,'.png'));
    k = [k;j;h;n];
    sff = fn(k);
    disp(sff);
    
    if numel(rff) == numel(sff)
        display('content number matches');
    end
    
    
%     if input('stop=1: ') == 1
%         cd(sourcefiles{x,2});
%         break
%     end
    
    
end






















