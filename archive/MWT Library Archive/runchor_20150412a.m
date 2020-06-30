function runchor(pMWTc,chorscript)
    display(sprintf('Need to chor %d MWT files',numel(pMWTc)));
    str = 'Chor-ing MWTfile [%s]...';
    for x = 1:numel(pMWTc); 
        [~,fn] = fileparts(pMWTc{x}); file = strcat('''',pMWTc{x},''''); 
        display(sprintf(str,fn));
        for x = 1:numel(chorscript) 
            system([chorscript{x} file], '-echo'); 
        end  
    end
    display 'Chor Completed';

end