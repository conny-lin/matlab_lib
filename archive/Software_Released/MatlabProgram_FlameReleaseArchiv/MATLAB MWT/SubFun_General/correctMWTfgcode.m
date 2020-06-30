function correctMWTfgcode(MWTfdat,pExp)
%% [FUTURE DEVELOPMENT] layer = how many layers of folder before reaching MWT folder
% only works with grouped files
disp(MWTfdat(:,2)); % display all experiment names
[RCpart] = parseRCname1(MWTfdat); % ask if only group codes are inccorectto reassign
[f,pf] = getallfilesinallgroupedMWTfolders(pExp);
[fpart,~] = filenameparse(f, 1);
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

    function [RCpart] = parseRCname1(MWTfdatname)
    % use imported .dat or .trv file names to parse out runcondition names
    % the first column is a list of MWT folder names, the second column is a
    % list of imported file names
    A = {};
    for x = 1:size(MWTfdatname,1);
        n = MWTfdatname{x,2}; % name of the MWT file
        dot = strfind(n,'.'); % find position of dot
        under = strfind(n,'_'); % find underline
        A{x,1} = MWTfdatname{x,1}; % MWT folder name
        A{x,2} = n(1:dot-1); % RC name 
        A{x,3} = n(1:under(1)-1); % strain
        A{x,4} = n(dot-2:dot-2); % group code
        A{x,5} = n(dot-2:dot-1);% plate code  
        A{x,6} = n(under(4)+1); % tracker
    end
    RCpart = A;
    end
    function [filenamelist,filepathlist] = getallfilesinallgroupedMWTfolders(pExp)
[~,~,~,pGroupf] = dircontent(pExp); % get all files under all folders
pMWTf = {};
for x = 1:size(pGroupf,1);
    [~,~,~,pf] = dircontent(pGroupf{x,1}); % get all files under all folders
    pMWTf = cat(1,pMWTf,pf);
end
filenamelist = {};
filepathlist = {};
for x = 1:size(pMWTf,1);
    [f,pf,~,~] = dircontent(pMWTf{x,1});
    filenamelist = cat(1,filenamelist,f);
    filepathlist = cat(1,filepathlist,pf); 
end
end

function [c,header] = filenameparse(cell, col)
% function [c,header] = getMWTrunName_v20130705(cell, col))
% get run condition parts
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
function [GRA] = reassigngroupcode(RCpart)
%% manually assign group code
GRA = RCpart(:,5);
disp(GRA);
disp('type in correct group-plate code (i.e. aa)...');
q1 = 'correct group code of %s[%s]: ';
i = {};
for x = 1:size(RCpart,1);
     GRA(x,2) = {input(sprintf(q1,RCpart{x,1},GRA{x,1}),'s')};
end
end

