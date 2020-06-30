function C = uniqueCellrows(A)


%% convert table to cell
if istable(A)
    tblstatus = true;
    tblevar = A.Properties.VariableNames;
    A = table2cell(A);
else 
    tblstatus = false;
end

%% cal
B = strjoinrows(A,' SPLIT ');
grp = B;
gnameu = unique(grp); 
C = regexpcellout(gnameu,' SPLIT ','split');

% if is table
if tblstatus
   C = cell2table(C,'VariableNames',tblevar);
end
