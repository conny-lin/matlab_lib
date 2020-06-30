function [titlename,set,m,intmin,int,intmax,Yn] = selectmeasure3...
        (setfn)
%% userinput interface

disp(setfn);
set = input('enter [m intmin int intmax] separated by space:\n ','s');
set = str2num(set);
m = set(1);
Yn = setfn{m,2};
intmin = set(2);
int = set(3);
intmax = set(4);

        
        %% [future coding] - ask to store setting
        

% make graph title name
titlename = regexprep(mat2str(set),' ','x');
titlename = strcat(Yn,'_',titlename);
    end