function makemisspath(pD)
if iscell(pD)==0 && isdir(pD) ==0; 
    [pH,foldername] = fileparts(pD);
    mkdir(pH,foldername);
elseif iscell(pD)==1
    for x = 1:numel(pD)
        [pH,foldername] = fileparts(pD{x});
        mkdir(pH,foldername);
    end
    
end
