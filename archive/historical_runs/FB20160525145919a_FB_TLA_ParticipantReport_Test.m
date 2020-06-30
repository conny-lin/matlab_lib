
%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',true);

%%
cd(fileparts(pM));
filename = 'score-export.txt';

%% get data
fid = fopen(filename,'r');
formatStr = '%s%s%d%d%f%f%s%[^\n\r]';
dataArray = textscan(fid, formatStr, 'Delimiter', '\t', 'HeaderLines' ,2-1, 'ReturnOnError', false);
fclose(fid); % Close the text file.
dataArray(end) = [];

%% find which colum is which format
i = regexp(formatStr,'[%]');
formatcode = formatStr(i+1);
formatcode(end) = [];

istr = regexp(formatcode,'s');
iint = regexp(formatcode,'d');
ifloat = regexp(formatcode,'f');


%% get header
fid = fopen(filename,'r');
formatStr = '%s%s%s%s%s%s%s%[^\n\r]';
dataHeader = textscan(fid, formatStr, 1, 'Delimiter', '\t', 'ReturnOnError', false);
fclose(fid); % Close the text file.
dataHeader(end) = [];

%%

return



%%
% convert file
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));
for col=[1,3,4,5,6]
    % Converts strings in the input cell array to numbers. Replaced non-numeric
    % strings with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric strings to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end


%% Split data into numeric and cell columns.
rawNumericColumns = raw(:, [1,3,4,5,6]);
rawCellColumns = raw(:, [2,7]);


%% Create output variable
scoreexport = table;
scoreexport.email = cell2mat(rawNumericColumns(:, 1));
scoreexport.friendly_id = rawCellColumns(:, 1);
scoreexport.game_id = cell2mat(rawNumericColumns(:, 2));
scoreexport.score = cell2mat(rawNumericColumns(:, 3));
scoreexport.reaction_time = cell2mat(rawNumericColumns(:, 4));
scoreexport.accuracy = cell2mat(rawNumericColumns(:, 5));
scoreexport.FROM_UNIXTIMEsplayed_at_utc = rawCellColumns(:, 2);

%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me rawNumericColumns rawCellColumns;