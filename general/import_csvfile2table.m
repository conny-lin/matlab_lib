function T = import_csvfile2table(filename,formatStr)

%% get data
fid = fopen(filename,'r');
% formatStr = '%s%s%d%d%f%f%s%[^\n\r]';
dataArray = textscan(fid, formatStr, 'Delimiter', ',', ...
            'HeaderLines', 2-1, 'ReturnOnError', false);
fclose(fid); % Close the text file.
dataArray(end) = [];   

%% find which colum is which format
i = regexp(formatStr,'[%]');
formatcode = formatStr(i+1);
formatcode(end) = [];
formatcode = formatcode';

%% get header
formatStrH = regexprep(formatStr,'[df]','s');

fid = fopen(filename,'r');
% dataHeader = textscan(fid, formatStrH, 1, 'Delimiter', '\t', 'ReturnOnError', false);
dataHeader = textscan(fid, formatStr, 1, 'Delimiter', '\t', 'ReturnOnError', false);
fclose(fid); % Close the text file.

dataHeader(end) = [];
dataHeader = celltakeout(dataHeader);
% dataHeader = matlab.lang.makeValidName(dataHeader); % deal with invalid fieldnames


%% put int table
T = table;
for fi = 1:numel(dataHeader)
   format_current = formatcode(fi);
   if any(ismember(format_current,'s'))
      T.(dataHeader{fi}) = dataArray{fi};
   elseif any(ismember(format_current,{'d','f'}))
      T.(dataHeader{fi}) = cell2mat(dataArray(fi));
   else
       error('code not accomodating ''%s'' format', format_current)
   end

end
