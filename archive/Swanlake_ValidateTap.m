function [varargout] = Swanlake_ValidateTap(MWTindex,S,varargin)

SampleTime = S.all;
SampleTime_NoTap = S.notap;
SampleTime_Tap = S.Tap;
tapN = S.tapN;


%% GET TAP TIME OF INTEREST
% validate if tapt == tapN
% check if tapN var
pMWTf = MWTindex.platepath.text;
% if some files does not have tapN_#.dat file
i = cell2mat(cellfun(@isempty,cellfun(@dircontentext,pMWTf,...
    cellfunexpr(pMWTf,'tapN_*.dat'),'UniformOutput',0),'UniformOutput',0));

if sum(i)>0
    p2 = pMWTf(i);
    for x = 1:numel(p2)
        cd(p2{x}); load('swanlake.mat','swanlake');
        tapt = find((swanlake.tap==1)); % find tap time
        cd(p2{x}); dlmwrite(['tapN_',num2str(numel(tapt)),'.dat'],tapt);

    end
end

% validate tapN
[fn,p] = cellfun(@dircontentext,pMWTf,cellfunexpr(pMWTf,'tapN_*.dat'),...
    'UniformOutput',0);
a = regexpcellout(celltakeout(fn,'match'),'[_]|[.]','split');
tapt = cellfun(@str2num,a(:,2));
tapval = tapt==tapN;
if sum(tapval)~=size(tapval)
    MWTindex.plate.text(~tapval)
    error('some MWT has unequal tap number');
end


% evaluate tap times
pMWTf = MWTindex.platepath.text;
TimeN = numel(SampleTime);
t = zeros(size(pMWTf));
t2 = [];
% find plates without the same tap N
for mwt = 1:numel(pMWTf)
    cd(pMWTf{mwt}); load('swanlake.mat','swanlake');
    A = swanlake;
    tapt = A.time((A.tap ==1));
    t(mwt,1) = numel(tapt);  
    t2(mwt,1:numel(tapt)) = tapt';
    tin = [SampleTime_NoTap,tapt'];
end
t2 = floor(t2);
st = repmat(SampleTime_Tap,size(t2,1),1);
[~,i] = setdiff(t2,st,'rows');
pMWTf = MWTindex.platepath.text(i);
display(sprintf('[%d] MWT files do not have specified tap times',...
    numel(pMWTf)));

%% validate paths and make pData
if isempty(i) ==0;
    % expfolder/groupfolder/mwt folder
    a = regexpcellout(pMWTf,'/','split'); 
    % analysis folder should 4th last on the path list
    fi = size(a,2)-3;
    f = a(:,1:fi);
    pData = [];
    % check if f are all equal and construct pData
    for x = 1:size(f,2)
        u = unique(f(:,x));
        if length(u) == 1;
            pData = [pData,u{1},'/'];
        else
         error 'not all MWT files came from the same analysis folder';
        end
    end
    pData = pData(1:end-1); % get rid of the final '/';

    %% make bad tap folder path
    p = fileparts(pData);
    pBadTap = [p,'/MWT_TapIncorrectFiles'];


    %% move to bad folder
    display(sprintf('moving MWT files to path: %s',pBadTap));
    moveunderfolder(pMWTf,pData,pBadTap);


    % re-construct MWTindex
    if isempty(i) ==0;
        [MWTindex] = makeMWTindex(MWTindex.platepath.text(~i));
        varargout{1} = MWTindex;
    end
else
    varargout{1} = [];
end