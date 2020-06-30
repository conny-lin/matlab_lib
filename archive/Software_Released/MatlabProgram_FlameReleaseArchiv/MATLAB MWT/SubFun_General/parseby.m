function [parse,partn] = parseby(cell2parse,string)
[under] = gencellfunexpr(cell2parse,string);
[~,~,~,~,~,~,split] = cellfun(@regexp,cell2parse,under,'UniformOutput',0);
parse = {};
partn = [];
for x = 1:size(split,1)
    parse(x,1:size(split{x,1},2)) = split{x,1};
    partn(x,1) = size(split{x,1},2);
end


end