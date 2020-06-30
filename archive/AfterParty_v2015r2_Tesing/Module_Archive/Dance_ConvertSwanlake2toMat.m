function Dance_ConvertSwanlake2toMat(MWTSet)
display ('converting swanlake2 chor output to .mat');

% convert to mat
% get paths
pMWT = MWTSet.pMWTchorpass;

% get filename
for x = 1:1%numel(pMWT)
    
    % import and save all swanlake2all files
    % get paths to swanlake2all
    pmwt = pMWT{x};
   
    % check if .mat already exist
%     [fn,p] = dircontent(pmwt,'swanlake2all_v20140514.mat'); 
    
    [~,mwtfn] = fileparts(pmwt);
    display(sprintf('processing:[%s]',mwtfn));
    [~,pdata] = dircontent(pmwt,'*.swanlake2all.*');
    Data = [];  
    for x = 1:numel(pdata)
       a = dlmread(pdata{x}); % read file
       Data = [Data;a];
    end
    % save mat
    cd(pmwt); save('swanlake2all_v20140514.mat','Data');
    % reporting
    [~,fn] = fileparts(pmwt);
    display(sprintf('MWT folder: %s',fn));
    display(sprintf('%d data points',size(Data,1)));


    % import all swn files
    [datafn,pdata] = dircontent(pmwt,'*.swn');
    Data = [];  
    for x = 1:numel(pdata)
       a = dlmread(pdata{x}); % read file
       Data = [Data;a];
    end
    % save mat
    cd(pmwt); save('swn_v20140514.mat','Data');
    % reporting
    display(sprintf('%d data points',size(Data,1)));
end
display('done');