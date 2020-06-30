function fprintf_cell(c,fid)

for x = 1:numel(c)
    fprintf(fid,'%s\n',c{x});
end

end