function putrawb2expterf(pRaw,pPF,pFunD)

%% get sub functions
[~,pExpf,~,~] = dircontent(pRaw);
for x = 1:size(pExpf,1);
    pExp = pExpf{x,1}; % get pExp
    % find experimenter code within Exp folder name
    [p,expname] = fileparts(pExp);
    capital = '[A-Z]';
    expr = strcat(capital,capital);
    [i,f] = regexp(expname,expr,'start','end');
    exptercode = expname(i:f);
    % find expter folder name
    cd(pFunD);
    load('expter.mat'); % get expter.mat
    a = char(expter(:,2)); % convert to char array for search
    r = strmatch(exptercode,a); % find expter row id
    
    % validation
    if isempty(r) ==1; % if r is empty
        warning('No expter code for %s...',expname); 
    else
        expterfolder = expter{r,1};
        if isdir(pExp) ==1;
            movefile(pExp,strcat(pPF,'/',expterfolder,'/',expname)); % copy file to experimenter folder
        else % is a zip file probably
            movefile(pExp,strcat(pPF,'/',expterfolder));
        end
        display(sprintf('%s moved to %s',expname,expterfolder)); % report progress

    end
end

end
