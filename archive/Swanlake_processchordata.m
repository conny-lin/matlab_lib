function [varargout] = Swanlake_processchordata(MWTindex,paths,varargin)
%% insturction
% function input
% Swanlake_processchordata(MWTindex,RCT,pSaveA)
    % varargin input 
    % MWT index file
    % pSaveA = path to save folder
    % RCT = running condition i.e. 100s30x10s10s
%     
% Swanlake_processchordata(MWTindex,RCT,pSaveA,varargin) 
% OPTION file, OPTION.refresh
% 'MWTgraph', 'on' or 'off'
% 'sampleint' = sampling interval, default is 10s
% 'sampledur' = sampling duration after tap or sampleint, default is 0.5s

%% reporting
display 'processing swanlake chor data';
display 'this will take a while...';

%% INTERPRET INPUT
% get pSave A
if isstruct(paths)==1 && isdir(paths.MWT.pSaveA)
    pSaveA = paths.MWT.pSaveA;
end

% get pBadTap
if isstruct(paths)==1 && isdir(paths.MWT.pBadTap)
    pBadTap = paths.MWT.pBadTap;
end


%% INTERPRET VARARGIN 

% [optional] OPTION
i = cellfun(@isstruct,varargin);
if sum(i) ==1;
    OPTION = varargin{i};
    names = fieldnames(OPTION);
    if sum(regexpcellout(names,'(refresh)')) ==0
        OPTION.refresh = 0;
    end
else
    OPTION.refresh = 0;
end

% [optional] MWTgraphs
i = find(strcmp(varargin,'MWTgraph'))+1;
if isempty(i) ==0
    v = varargin{i};
    switch v
        case 'off'
            MWTgraph = 0;
        case 'on'
            MWTgraph = 1;
    end
else
     MWTgraph = 1;
end




%% SWANLAKE DATA PROCESSING --------------------------------------

% validate previous .mat outputs
pMWTf = MWTindex.platepath.text; % get folder list
Import = cell(size(pMWTf)); 

switch OPTION.refresh  
    case 1
        matval = false(size(pMWTf));
        
    case 0
    % validate if .mat file exist & are structural array
    pMWTf = MWTindex.platepath.text; % get folder list
    % validate if mat exist
    [~,p] = cellfun(@dircontentext,pMWTf,...
        cellfunexpr(pMWTf,'swanlake.mat'),'UniformOutput',0);
    matexist = ~cellfun(@isempty,p);

    % Import mat and validate if .mat fileare structural array
    matstruct = false(size(pMWTf));
    if sum(matexist)>0; % if there are some mat files
        p = celltakeout(p,'multirow');
        % import only swanlake var
        A = cellfun(@load,p,cellfunexpr(p,'swanlake'));
        % put import in Import cell array
        Import(matexist) = struct2cell(A)'; clearvars A;
        matstruct = cellfun(@isstruct,Import);
    end
    matval = matstruct;

end


% for mwt files without .mat, validate if .dat file exist
if sum(~matval) >0;
    p = MWTindex.platepath.text(~matval); 
    [~,p] = cellfun(@dircontentext,p,cellfunexpr(p,'*swanlake.dat'));
    datexist = ~cellfun(@isempty,p);
    % error reporting
    if sum(~datexist) > 0
       display('chor swanlake.dat output not found in the following files:');
       disp(MWTindex.plate.text(~datexist)); % get folder list
       error('check chor swanlake.dat output or write a patch to fix this');
    end
end


% import .dat 
if sum(~matval) >0
    % create index for dat running
    datrun = false(size(MWTindex.plate.text));
    datrun(~matval) = datexist;
    if sum(datrun)<1; error('no dat to run'); end

    % reporting
    display 'Importing swanlake.dat, this will take a while...';

    % get paths
    p = MWTindex.platepath.text(datrun);
    [~,p] = cellfun(@dircontentext,p,cellfunexpr(p,'*swanlake.dat'));

    % import data
    D = cellfun(@dlmread,p,cellfunexpr(p,' '),cellfunexpr(p,0),...
        cellfunexpr(p,0),'UniformOutput',0);  
end



% transform .dat into trimmed structure array
if sum(~matval) >0;
    % get legend
    L = {'time'; 'number'; 'goodnumber';'area';'midline';'morphwidth';...
    'aspect';'width';'length';'kink';'curve';'speed';'pathlen';'bias';...
    'dir';'tap'}';
    
    % create validate index
    nogoodnumber = false(size(D));

    % get path and plate names
    MWTfn = MWTindex.plate.text; pMWTf = MWTindex.platepath.text; 
    fn = MWTfn(~matval); p = pMWTf(~matval); 
    for x = 1:numel(D)
        if isempty(D)~=1;
            % find good number > 0
            j = find(D{x,1}(:,strcmp(L,'goodnumber')));
            
            if isempty(j) ==1;  % if no good number >0
                nogoodnumber(x,1) = true;  % mark no worm tracked 
            
            else % if good number > 0 found
                A = D{x,1}(j,:); % eliminate good number <0               
                % structure var into structural array
                swanlake = []; 
                swanlake.plate = fn(x);
                swanlake.platepath = p(x);
                for m = 1:numel(L)
                    swanlake.(L{m}) = A(:,strcmp(L{m},L));
                end
                % record path and plate names
                swanlake.plate = fn{x}; swanlake.platepath = p{x};
                cd(p{x}); save('swanlake.mat','L','swanlake');  % save
            end
        end
    end
    % reorganize no good number to correspond to MWTindex
    i = false(size(MWTindex.plate.text)); i(~matval) = nogoodnumber;
    nogoodnumber = i;
else
    nogoodnumber = false(size(MWTindex.plate.text));
end



% move data without tracking to bad folder
if sum(nogoodnumber)>0;
    % get paths to files with no good number
    p = MWTindex.platepath.text(nogoodnumber); 
    % replace pData path with pBadFiles paths
    a = cellfun(@strrep,p,cellfunexpr(p,pData),cellfunexpr(p,pBadFiles),...
        'UniformOutput',0); 
    makemisspath(cellfun(@fileparts,a,'UniformOutput',0)); % make folders
    cellfun(@movefile,p,a); % move files
    % reporting
    str = '[%d] MWT files with zero worms tracked moved to BadFiles folder';
    display(sprintf(str,numel(a)));
end



% reorganize Import and update MWTindex
% double check if isdir
valdir = cellfun(@isdir,MWTindex.platepath.text);
importmatch = MWTindex.platepath.text;
if sum(~valdir) >0
    % update MWT file entries
    display 'updating MWT files index';
    MWTfG = [];
    pMWTf = pMWTf(valdir); MWTfn = MWTindex.plate.text(valdir); 
    MWTgn = MWTindex.group.text(valdir);
    gname = unique(MWTgn);
    for g = 1:numel(gname);
        i = strcmp(MWTgn,gname{g});
        MWTfG.(gname{g}) = [MWTfn(i),pMWTf(i)];
        % reporting
        display(sprintf('Group[%s]= %d plates',gname{g},sum(i)));
    end
    [MWTindex] = MWTfGind_make(MWTfG);
    
    % match import structure with new MWTindex
    A = Import(ismember(importmatch,MWTindex.platepath.text));
    % revalidate dir
    i = cellfun(@isdir,MWTindex.platepath.text);
    if sum(~i) > 0; error('problem with MWT paths'); end
end



% import missing .mat
i = cellfun(@isempty,Import);
if sum(i)>0;
    p = MWTindex.platepath.text(i);
    [~,p] = cellfun(@dircontentext,p,...
        cellfunexpr(p,'swanlake.mat'),'UniformOutput',0);
    p = celltakeout(p,'multirow');
    A = cellfun(@load,p,cellfunexpr(p,'swanlake'));
    % put import in Import cell array
    Import(i) = struct2cell(A)'; clearvars A;
end

% save import 
matname = 'SwanLake.mat';
matvarname = 'Import';
cd(pSaveA); save(matname,matvarname);
%clearvars Import;

% create varargout {1}
varargout{1}{1,1} = matname;
varargout{1}{1,2} = matvarname;


%% SUMMARIZE CHOR SWANLAKEALL OUTPUT TO .MAT
% create varargout{2} for swanlakeall
matname = 'swanlakeall.mat';
matvarname = 'Import';
varargout{1}{2,1} = matname;
varargout{1}{2,2} = matvarname;


% MAKE SUMMARY SWANLAKEALL.DAT
L = {'wormid';'time'; 'number'; 'goodnumber';'area';'midline';'morphwidth';...
    'aspect';'width';'length';'kink';'curve';'speed';'pathlen';'bias';...
    'dir';'tap'}';
pMWTf = MWTindex.platepath.text; 
MWTfn = MWTindex.plate.text;
% get files for only summary data that are not made
pMWTf = pMWTf(cellfun(@isempty,cellfun(@dircontentext,pMWTf,...
    cellfunexpr(pMWTf,matname),'UniformOutput',0)));


if isempty(pMWTf)==0; 
    display ' '; display 'Making swanlakeall.dat summary output...';
    display 'this will take a while'; 
    for mwt = 1:numel(pMWTf); 
        Import = [];
        [fn,p] = dircontentext(pMWTf{mwt},'*swanlakeall*'); 
        % reporting
        display(sprintf('procesing [%d/%d]: %s',mwt,numel(pMWTf),MWTfn{mwt}));
        % get wormid
        wormid = celltakeout(regexp(fn,'[.]','split'),'multirow'); 
        wormid = wormid(:,3); 
        for f = 1:numel(fn)
            a = dlmread(p{f},' ',0,0); % import data
            % add wormid to data
            a = [repmat(str2num(wormid{f}),size(a,1),1),a]; 
            % find min time with valid entries
            %i = find(D(:,strcmp('goodnumber',L)));
            if isempty(Import); Import = a;
            else
                Import(end+1:end+size(a,1),:) = a; % add to combined data
            end
        end
        cd(pMWTf{mwt}); save(matname,matvarname);% write sum data
        cellfun(@delete,p);% erase all other data
    end
    % reporting
    display 'done';
end


%% [OPTIONAL] MWT PLATE SUMMARY PLOT 
if MWTgraph == 1;
    % CREATE PLOT PER FOLDER FROM SWANLAKE.MAT VAR = IMPORT
    savename = 'SwanLake';
    % get paths and plate name
    pMWTf = MWTindex.platepath.text; MWTfn = MWTindex.plate.text;
    % see which files does not have summary plot output
    [fn,p] = cellfun(@dircontentext,pMWTf,...
        cellfunexpr(pMWTf,['*',savename,'.pdf']),'UniformOutput',0);
    i = cellfun(@isempty,fn);

    if sum(i)>0
        display 'Making SwanLake graphs for each MWT folder...';
        pMWTf = pMWTf(i);


        for mwt = 1:numel(pMWTf); 

            display(sprintf('procesing [%d/%d]: %s',mwt,numel(pMWTf),MWTfn{mwt}));
            % import
            cd(pMWTf{mwt}); load('swanlake.mat','swanlake'); D = swanlake;
            itap = find(D.tap == 1); % find taps location
            Time = D.time; % get time

            % make figure
            f1 = figure('Color',[1 1 1],'Visible','off');
            xlim([0,max(Time)+10]);
            % sample size
            name = 'goodnumber';
            subplot(4,3,1,'Parent',f1); ylabel(name); hold on;
            NVal = D.(name); NValMax = max(NVal); NValMean = mean(NVal); 
            plot(Time,D.(name),'MarkerSize',2,'Marker','.','LineStyle','none'); % set(pt(1),'DisplayName','body area');
            a = zeros(numel(NVal),1); a(:) = NaN; a(itap) = max(NVal); % taps
            plot(Time,a,'MarkerSize',4,'Marker','x','LineStyle','none','Color',[0 0 0]);
            % movement
            name = 'pathlen'; subplot(4,3,2,'Parent',f1); 
            ylabel(name); hold on; plot(Time,D.(name),'MarkerSize',2,'Marker','.','LineStyle','none');
            name = 'speed'; subplot(4,3,4,'Parent',f1); ylabel(name); hold on;
            ylabel(name); hold on; plot(Time,D.(name),'MarkerSize',2,'Marker','.','LineStyle','none');
            name = 'dir'; subplot(4,3,7,'Parent',f1); 
            ylabel(name); hold on; plot(Time,D.(name),'MarkerSize',2,'Marker','.','LineStyle','none');
            name = 'bias'; subplot(4,3,10,'Parent',f1); 
            ylabel(name); hold on; plot(Time,D.(name),'MarkerSize',2,'Marker','.','LineStyle','none');
            a = zeros(numel(NVal),1); a(:) = NaN; a(itap) = 0;
            plot(Time,a,'MarkerSize',4,'Marker','x','LineStyle','none','Color',[0 0 0]);
            % body size
            name = 'area'; subplot(4,3,5,'Parent',f1); 
            ylabel(name); hold on; plot(Time,D.(name),'MarkerSize',2,'Marker','.','LineStyle','none');
            name = 'midline'; subplot(4,3,8,'Parent',f1); 
            ylabel(name); hold on; plot(Time,D.(name),'MarkerSize',2,'Marker','.','LineStyle','none');
            name = 'morphwidth'; subplot(4,3,11,'Parent',f1); 
            ylabel(name); hold on; plot(Time,D.(name),'MarkerSize',2,'Marker','.','LineStyle','none');
            % posture
            name = 'aspect'; subplot(4,3,3,'Parent',f1); 
            ylabel(name); hold on; plot(Time,D.(name),'MarkerSize',2,'Marker','.','LineStyle','none');
            name = 'width'; subplot(4,3,6,'Parent',f1); 
            ylabel(name); hold on; plot(Time,D.(name),'MarkerSize',2,'Marker','.','LineStyle','none');
            name = 'length'; subplot(4,3,9,'Parent',f1); 
            ylabel(name); hold on; plot(Time,D.(name),'MarkerSize',2,'Marker','.','LineStyle','none');
            subplot(4,3,12,'Parent',f1); 
            ylabel('Posture (kink/curve)'); hold on;
            name = 'kink'; plot(Time,D.(name),'MarkerSize',2,'Marker','.','Color',[0 0 0],'LineStyle','none');
            name = 'curve'; plot(Time,D.(name),'MarkerSize',2,'Marker','.','LineStyle','none');
            % Create textbox
            [~,fname] = fileparts(pMWTf{mwt}); fname = strrep(fname,'_',' ');
            annotation(f1,'textbox',[0.37 0.96 0.30 0.03],'String',{fname},...
                'EdgeColor','none','HorizontalAlignment','center',...
                'FitBoxToText','off');     
            % save fig
            savefigpdf(savename,pMWTf{mwt});   
        end
        % reporting
        display 'done';
    end
end







