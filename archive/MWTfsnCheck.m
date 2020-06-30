function [MWTrunameCorr] = MWTfsnCheck(MWTfn,MWTfsn)
    %% validate underscore number and parse name
    % check underscore = 4
    [new] = corrMWTnamepart(MWTfn,MWTfsn,'underscore#(4)','_',4,...
        'equalauto');
    if isempty(new)==1;
        MWTrunameCorr = MWTfsn;
    else
        MWTrunameCorr = new;
    end
    % parse by underscore
    [strain,seedcolony,colonygrowcond,runcond,trackergroup] = ...
        parseMWTfnbyunder(MWTrunameCorr);

    %% checking and correcting
    [strain] = corrMWTnamepart(MWTrunameCorr,strain,'strain name',...
        '[A-Z]\d',2,'lessthan');
    [seedcolony] = corrMWTnamepart(MWTrunameCorr,seedcolony,'Seedcolony x',...
        '\dx\d',1,'equal');
    [colonygrowcond] = corrMWTnamepart(MWTrunameCorr,colonygrowcond,...
        'colony agetemp','h\d\dC',1,'equal');
    [runcond] = corrMWTnamepart(MWTrunameCorr,runcond,'runcondition[x]#',...
        'x',1,'equal');
    [runcond] = corrMWTnamepart(MWTrunameCorr,runcond,'runcondition[s]#','s',3,...
        'lessthan');
    % check trackergroup = A0000aa
    [trackergroup] = corrMWTnamepart(MWTrunameCorr,trackergroup,...
        'tracker/group/plate','[A-Z]\d\d\d\d[a-z][a-z]',1,'equal');


    % incorporate new to MWTruname
    [u] = cellfunexpr(strain,'_');
    MWTrunameCorr = cellfun(@strcat,strain,u,seedcolony,u,colonygrowcond,u,...
        runcond,u,trackergroup,'UniformOutput',0);
