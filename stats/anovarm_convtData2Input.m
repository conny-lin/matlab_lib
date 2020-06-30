function [B,G1,AT,vn,rmu] = anovarm_convtData2Input(Data,rmName,fName,msr,idname)


%%
rm = Data.(rmName);
rmu = unique(rm);
dv = Data.(msr);

iv = Data(:,fName);
iv = table2cell(iv);

ivg = strjoinrows(iv,'@');

id = Data.(idname);

%%
idu = unique(id);
nid = numel(idu);

A = cell(nid,1);
G = cell(nid,1);

for idui = 1:nid
    
    idnow = idu{idui};
    i = ismember(id, idnow);
    
    x = dv(i)';
    g = ivg(i);
    if numel(unique(g)) ~= 1
       error('more than one group'); 
    end
    
    r = rm(i);
    [i,j] = ismember(rmu,r);
    k = j(i);
    
    xx = nan(1,numel(rmu));
    xx(i) = x(k);
    
    if numel(xx) ~= numel(rmu)
       error('non match'); 
    end
    
    A{idui} = xx;
    G(idui) = unique(g);
    
    
end

A = cell2mat(A);
% fill in nan data with zero to avoid no data issue in rmanova
A(isnan(A)) = 0;


%%
n = cellfun(@num2str,num2cell(rmu),'UniformOutput',0);
n2 = repmat({rmName},numel(n),1);
vn = strjoinrows([n2,n],'');
AT = array2table(A,'VariableNames',vn');

if numel(fName)>1
    G = regexpcellout(G,'@','split');
end

%%
G1 = cell2table(G,'VariableNames',fName);
B = [G1 AT];


%%



























