function fixmwtnested(Home,option)
[~,~,expn,pExp] = dircontent(Home);
for y = 1:numel(pExp); % for each experiment
    disp(expn{y,1}); % display experiment name
    [~,~,fnmwth,pmwth] = dircontent(pExp{y,1}); % find MWT folders
    if isempty(fnmwth)==1; % if no MWT foldres
        continue % skip
    else % if has MWT folders    
        for x = 1:numel(pmwth); % for each mwt folder
            disp(fnmwth{x}); % display mwt folder name
            [~,~,~,pm] = dircontent(pmwth{x}); % find folders within mwtf
            if isempty(pm); % if there is no folder within mwtf
                continue % skip
            else
                [fnpmm,pmm,~,~] = dircontent(pm{1}); % get content from nested mwtf
                if isempty(fnpmm)==1; % if the nested folder is empty
                    rmdir(pm{1}); % delete the folder
                    continue % skip
                else % if there are files in nested folder
                    [pmwt] = cellfunexpr(pmm,pmwth{x}); %prep cell expression
                    cellfun(@movefile,pmm,pmwt); % move all files to home mwt folder
                    switch option
                        case 'delete'
                            rmdir(pm{1}); % delete nested folder
                        case 'keep'
                    end
                end
            end
        end
            
    end
        
end