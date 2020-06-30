function [strain,P] = validatestrainname2(strain)  
[i] = regexp(strain,'[A-Z][0-9]','start');

% strain starts with capitalized letters
strainCAP = strain(1:i(1)); 

% correct strain to capitalized latter
if isempty(regexp(strainCAP,'[A-Z]','match'))==1; % not all capital
    P = 0;
    display('strain name not capitalized, transforming to capital letters');
    strainCAP = upper(strainCAP); % transform to capital
    display('done');
    P = 1;
end

% strain number
strainN = strain(i(1)+1:end);
if isempty(str2num(strainN))==1;
    display('strain name does not include numeric ID');
    P = 0
else 
    P = 1;
end

% reconstruct strain name
strain = strcat(strainCAP,strainN);

end