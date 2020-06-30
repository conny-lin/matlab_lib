function zipExpbackup(pExpf)
for x = 1:numel(pExpf)
    if isdir(pExpf{x}) ==1 && exist([pExpf{x} '.zip']) ==0;
        [~,fn]= fileparts(pExpf{x});
        display(sprintf('Zipping [%s] as backup',fn));       
        zip(pExpf{x},pExpf{x}); 
        display 'done.'
    else        
    end

end
    display 'All files have zip backup'