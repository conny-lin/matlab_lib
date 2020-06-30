function [strain] = validatestrainname(name,under)
  strain = name(1:under-1);    
    [i] = regexp(strain,'[A-Z][0-9]','start');
    % strain starts with capitalized letters
    strainCAP = strain(1:i(1)); 
    % correct strain to capitalized latter
    if isempty(regexp(strainCAP,'[A-Z]','match'))==1; % not all capital
        strainCAP = upper(strainCAP); % transform to capital
    end
    % strain number
    strainN = strain(i(1)+1:end);
    if isempty(str2num(strainN))==1;
        error('strain name does not include numeric ID');
    end
    % reconstruct strain name
    strain = strcat(strainCAP,strainN);

end