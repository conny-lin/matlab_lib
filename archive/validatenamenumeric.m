function [namepassed] = validatenamenumeric(name,warningmessage)
namepassed = name;    
if isempty(str2num(namepassed))==1;
    warning(warningmessage);
    namepassed = [];
       
end 
    
end