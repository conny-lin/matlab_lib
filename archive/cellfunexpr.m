function [exprname] = cellfunexpr(cell2match,expr,varargin)


    exprname(1:size(cell2match,1),1) = {expr};
end