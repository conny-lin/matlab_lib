function Data = ephys_extractData(pMWT,assaytimes,ISI,preplate,assayTapNumber,varargin)


%% GET INFO
legend_gangnam = load('/Users/connylin/Dropbox/Code/Matlab/Library RL/Modules/Chor_output_handling/legend_gangnam.mat');
legend_gangnam = legend_gangnam.legend_gangnam;
msrInterest = {'time','id','bias','speed','tap','midline'};
%%
MWTDB = parseMWTinfo(pMWT);
gu = unique(MWTDB.groupname);
%% LOAD AND PROCESS FILES
DataVal = cell(size(pMWT));
% produce habituated response summary per plate
for mwti = 1:numel(pMWT)
    processIntervalReporter(numel(pMWT),1,'MWT',mwti); % reporting
    pmwt = pMWT{mwti}; % get basic info
    % get file path
    pf = getpath2chorfile(pMWT(mwti),'Gangnam.mat','reporting',0);
    
    % load individual worm data
    Import = load(char(pf));
    % extract data from relevant times
    DataHab = cell(size(assaytimes,2),1);
    for ti = 1:size(assaytimes,2) % for each tap time
%         processIntervalReporter(size(assaytimes,2),1,'taptime',ti)
        Data1 = Import.Data(extract_valid_wormtime(Import.time,assaytimes(:,ti)));
        for wrmi = 1:numel(Data1)
            clear D;
%             processIntervalReporter(numel(Data1),50,' worm',wrmi)
            D = convert_import2table(Data1{wrmi},legend_gangnam,'msr',msrInterest);
            D = extract_data_timeofinterest(D.time,D,assaytimes(:,ti));
            % exclude data if all nan
            if sum(isnan(D.bias))==size(D,1); Data1{wrmi} = {}; continue; end; 
            D.time = syncdata2tap(D.time,D.tap,0);
            Data1{wrmi}  = transform_roundSpeedbytime2(D,'overwriteTime',0);
            if isempty(D)==1; error('flag'); end
        end
        Data1(cellfun(@isempty,Data1)) = []; % clear invalid data
        Data1 = cellfun(@table2array,Data1,'UniformOutput',0); % convert to array
        [r,~] = cellfun(@size,Data1); % find size
        DataHab{ti} = [repmat(ti,sum(r),1) cell2mat(Data1)]; % add time id
    end
    [r,c] = cellfun(@size,DataHab);
    [~,gid] = ismember(MWTDB.groupname(mwti),gu);
    DataVal{mwti} = [repmat(mwti,sum(r),1) repmat(gid,sum(r),1) cell2mat(DataHab)];
end
%%
DataVal = cell2mat(DataVal);
clear Import DataHab Data Db D;

% convert 2 table
Data = array2table(DataVal,'VariableNames',[{'mwtid','groupid' 'timeid'} msrInterest {'timeround'}]);
clear DataVal D;

% validate data
% create standard times
a= assaytimes(1):.1:assaytimes(2);
a = round((a'-(ISI*(assayTapNumber(1)-1)+preplate)).*10)./10;
a(end) = [];
b = tabulate(Data.timeround);
badtime = b(~ismember(b(:,1),a'),1);
% exclude time
Data(ismember(Data.timeround,badtime),:) = [];