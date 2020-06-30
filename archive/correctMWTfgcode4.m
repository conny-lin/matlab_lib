function correctMWTfgcode4(RCpart,MWTfsn,pMWTf)
%% [FUTURE DEVELOPMENT] layer = how many layers of folder before reaching MWT folder
% only works with grouped files
%[RCpart] = parseRCname2(MWTfsn); 
[f,pf] = getallfilesinallungroupedMWTfolders(pMWTf);
[fpart] = filenameparse2(f,1);
A = {};
for x = 1:size(fpart,1);
    A{x,1} = fpart{x,1}(1:end-2);
    A{x,2} = fpart{x,1}(end-1:end);
end

[GRA] = reassigngroupcode3(RCpart); % display code only
B = cell2mat(A(:,2)); % convert A to char array
for x = 1:size(GRA,1);
    i = strmatch(GRA{x,1},B);
    for xi = 1:size(i,1); % for all i cells, add new code in there
        A{i(xi,1),3} = strcat(A{i(xi,1),1},GRA{x,2}); % replace with correct group/plate code
        % combine with other parts of the file name
    end
end
%%
newname = {};
for x = 1:size(fpart,1);
    %% if not blobs files
    if isempty(fpart{x,3})==1;
        newname{x,1} = strcat(A{x,3},'.',fpart{x,2});
    else
        newname{x,1} = strcat(A{x,3},'_',fpart{x,3},'.',fpart{x,2}); % make new file names
    end
    %%
    [pH,~] = fileparts(pf{x,1}); % get home path of file
    E{x,1} = strcat(pH,'/',newname{x,1}); % make new path
    
    if isequal(pf{x,1},E{x,1})==0; 
        movefile(pf{x,1},E{x,1});
    end

end
end







