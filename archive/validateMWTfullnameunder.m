function [fullname,P] = validateMWTfullnameunder(name,under)
% validate full name
% validate names underline = 4
if isequal(size(under,2),4)==1;
    P = 1; % record pass
    fullname = name; % record full name
else
    P = 0;
    fullname = []; 
end

if P ==0;
    warning('Naming structure underscore incorrect for %s',name);
    warning('Current Naming structure validation not good enough, please code');
end
end

