function [c,header] = getMWTruncond_v20130703(expname, namecolumn)
% function [output,outputh] = getMWTruncond(namesource, namecolumn)
% 
% Input:
%  expname = cell array with names stored in column <namecolumn>
%
% Example:
%  expname{1,1} = 'N2_5x3_t96h20C_100s30x10s10s_C0109aa.set';
%  namecolumn = 1;
% 
% output:
%    [ 1]    'MWT file name'       
%    [ 2]    'group code'          
%    [ 3]    'group-plate code'    
%    [ 4]    'strain'              
%    [ 5]    'tracker'      
%    [ 6]    'N of starting colony'
%    [ 7]    'N of hours synched'  
%    [ 8]    'transfer method'     
%    [ 9]    'age'                 
%    [10]    'temp' 
%    
% 
% CL modified 20130703, finished: 20130703


c = {}; % declare output cell array
% create output headers
header = {'MWT file name'; 'group code'; 'group-plate code'; 'strain';...
    'tracker'; 'N of starting colony';'N of hours synched';...
    'transfer method';'age';'temp'; 'runcondition'; 'colony made date'};
headerind = num2cell((1:size(header,1))');
header = cat(2,headerind,header);

% get run condition parts
for x = 1:size(expname,1);
    name = expname{x,namecolumn}; % name of the MWT file
    dot = strfind(expname{x,namecolumn},'.'); % find position of dot
    under = strfind(expname{x,namecolumn},'_'); % find underline
    cross = strfind(expname{x,namecolumn},'x'); % find cross
    hour = strfind(expname{x,namecolumn},'h'); % find h
    c{x,1} = expname{x,namecolumn}(1:dot-1); % full name 
    c{x,2} = expname{x,namecolumn}(dot-2:dot-2); % group code
    c{x,3} = expname{x,namecolumn}(dot-2:dot-1);% plate code
    c{x,4} = expname{x,namecolumn}(1:under(1)-1); % strain
    c{x,5} = expname{x,namecolumn}(under(4)+1); % tracker  
    c{x,6} = expname{x,namecolumn}(under(1)+1:cross(1)-1); % N of starting colony
    c{x,7} = expname{x,namecolumn}(cross(1)+1:under(2)-1); % N of hours synched
    c{x,8} = expname{x,namecolumn}(under(2)+1); % transfer method
    c{x,9} = expname{x,namecolumn}(under(2)+2:hour(1)-1); % age
    c{x,10} = expname{x,namecolumn}(hour(1)+1:under(3)-2); % temp
    c{x,11} = expname{x,namecolumn}(under(3)+1:under(4)-1); % run condition
    c{x,12} = expname{x,namecolumn}(under(4)+2:under(4)+5); % colony made date
end

end