function [c,header] = filenameExt(cell, col)
% function [c,header] = getMWTrunName_v20130705(cell, col))
% 
% 
% Input:
%  expname = cell array with names stored in column <namecolumn>
%
% Example:
%  expname{1,1} = 'N2_5x3_t96h20C_100s30x10s10s_C0109aa.set';
%  namecolumn = 1;
% 
% output:
%   [1]    'file name'
%   [2]    'extension'
%    
% Conny Lin, started 20130705. published: __________



%% create output headers
header = {'file name'; 'extension'};
headerind = num2cell((1:size(header,1))');
header = cat(2,headerind,header);

%% get run condition parts
c = cell(:,col); % declare output cell array
for x = 1:size(cell,1);
    name = cell{x,col}; % name of the MWT file
    dot = strfind(cell{x,col},'.'); % find position of dot 
    under = strfind(cell{x,1},'_'); % find position of _
    k = strfind(cell{x,1},'k'); % find position of k   
    
    c{x,2} = cell{x,col}(dot+1:end);% file extension
    
    if isempty(k) ==0;    
        c{x,3} = cell{x,1}(under(end)+1:dot-1); % file index before extension
        c{x,1} = cell{x,1}(1:under(end)-1); % code new name
    else
        c{x,1} = cell{x,col}(1:dot-1); % file name 
        c{x,3} = {};
    end
end

end