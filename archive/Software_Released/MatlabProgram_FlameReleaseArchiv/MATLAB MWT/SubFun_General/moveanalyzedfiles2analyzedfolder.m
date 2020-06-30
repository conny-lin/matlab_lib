function moveanalyzedfiles2analyzedfolder(pExpO,pAExp)
ID = 0;
switch ID
    case 0
        ID = 0;
switch ID
    case 0
        [~,p,~,~] = dircontent(pExpO);
        if isequal(pExpO,pAExp)==0;
            display('moving files to standardized folder...');
            for x = 1:size(p,1);
                movefile(p{x,1},pAExp);        
            end 
            display('deleting old experiment folder...');
            rmdir(pExpO,'s'); % remove old file 
            display('updating new experiment path...');
        else
            display('folder already in standardized name');
        end       
    case 1
        % [suspend] mark folder as analyzed
        [pH,~] = fileparts(pExpS);
        analyzedname = strcat(expname,'_ShaneSpark');
        pAExp = strcat(pH,'/',analyzedname);
        pA = {};
        [~,p,~,~] = dircontent(pExpS);
        pA(1:size(p,1),1) = {pAExp};
        cellfun(@movefile,p,pA); 
        rmdir(pExpS,'s');
end