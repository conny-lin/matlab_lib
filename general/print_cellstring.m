function t = print_cellstring(a)
%%
t = '';
for ri = 1:size(a,1)
    if ri==1
        t = sprintf('%s\n',a{ri});
    else
        t = sprintf('%s\n%s',t,a{ri});
    end
end
