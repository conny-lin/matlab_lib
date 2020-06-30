function N = tabulateTable(A)


%%
a = tabulate(A);

N = table;
N.var = a(:,1);
N.n = a(:,2);