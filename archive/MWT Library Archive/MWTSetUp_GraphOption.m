function [MWTSet] = MWTSetUp_GraphOption(MWTSet)
display ' ';
display 'Graphing options: ';
GPack = dircontent(MWTSet.pFunG);
disp(makedisplay(GPack));
i = str2num(input('Select graphing option(s): ','s')');
GraphNames = GPack(i);
% GET ANALYSIS PACK PATH
for x = 1:numel(GraphNames)
    pFunGP{x,1} = [MWTSet.pFunG,'/',GraphNames{x}];
end

MWTSet.GraphNames = GraphNames;
MWTSet.pFunGP = pFunGP;