function groupMWT2gc(Home)
% go to each folder
display 'Analyzing Home path...'
[pExpV,Expfn,pGp,Gpn,pMWTf,MWTfn,MWTfsn] = ...
        getMWTpathsNname(Home,'noshow');


display 'Proceeding to addressing individual experiment folders..'

for k = 1:numel(pExpV)
    pExp = pExpV{k};
    [pMWTf,MWTfn,MWTfsn,~,~] = getMWTrunamefromHomepath(pExp);
    MWTrunameCorr = MWTfsn;
    [strain,~,colonygrowcond,runcond,trackergroup] = ...
            parseMWTfnbyunder(MWTfsn);
    % construct show names
    a = char(trackergroup); % get groupcode out
    [~,expname] = fileparts(pExp);
    MWTgc = a(:,6); % group
    gcode = cellstr(unique(MWTgc));

    % create group folder
    for x = 1:numel(gcode)
        if isdir([pExp '/' gcode{x}]) ==0;
            mkdir(pExp,gcode{x});
        end
    end

    %% group automatically
    for x = 1:size(gcode,1)
        i = not(cellfun(@isempty,regexp(cellstr(MWTgc),gcode(x,1))));
        if sum(i) ~=0;
            i = find(i);
        end
        if isempty(i) ~=0;
        for y = 1:numel(i)  
           movefile(pMWTf(i(x)),[pExp '/' gcode{x}]);
        end
        end
    end
    
    %% reporting
display(sprintf('Expeirment [%s] grouped folder finish',expname));
display ' ';
end