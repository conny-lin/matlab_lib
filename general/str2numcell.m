function a = str2numcell(b)
a= cell2mat(cellfun(@str2num,b,'UniformOutput',0));
