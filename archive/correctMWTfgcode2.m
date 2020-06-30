function correctMWTfgcode2(MWTfdat,pExp)
%% [FUTURE DEVELOPMENT] layer = how many layers of folder before reaching MWT folder
% only works with grouped files
[RCpart] = parseRCname1(MWTfdat); 
[f,pf] = getallfilesinallgroupedMWTfolders(pExp);
[fpart] = filenameparse2(f,2);
A = {};
for x = 1:size(fpart,1);
    A{x,1} = fpart{x,1}(1:end-2);
    A{x,2} = fpart{x,1}(end-1:end);
end
[GRA] = reassigngroupcode(RCpart); % display code only
B = cell2mat(A(:,2)); % convert A to char array
for x = 1:size(GRA,1);
    i = strmatch(GRA{x,1},B);
    for xi = 1:size(i,1); % for all i cells, add new code in there
        A{i(xi,1),3} = strcat(A{i(xi,1),1},GRA{x,2}); % replace with correct group/plate code
        % combine with other parts of the file name
    end
end
newname = {};
for x = 1:size(fpart,1);
    if isempty(fpart{x,3})==1;
        newname{x,1} = strcat(A{x,3},'.',fpart{x,2});
    else
        newname{x,1} = strcat(A{x,3},'_',fpart{x,3},'.',fpart{x,2}); % make new file names
    end
    [pH,~] = fileparts(pf{x,1}); % get hoem path of file
    E{x,1} = strcat(pH,'/',newname{x,1}); % make new path
    if isequal(pf{x,1},E{x,1})==0; 
        movefile(pf{x,1},E{x,1});
    end
    %if isequal(MWTf{x,2},C{x,2}) ==0; % check if file name not equal
     %   movefile(MWTf{x,2},C{x,2}); % move file
    %end
end
end







