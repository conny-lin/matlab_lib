function [set,m,intmin,int,intmax,Yn] = selectmeasure(pFun,setfn,id)
%% userinput interface
cd(pFun);
load(setfn);
while id ==0;
    id = input('set analysis use preset(1), quick entry (2), user prompt(3):\n');
end

switch id
    case 1 % preset
        display(setid);
        x = input('select analysis: ');
        set = preset(x,:);
        m = set(1);
        Yn = MWTfdatGraphcode{m,2};
        intmin = set(2);
        int = set(3);
        intmax = set(4);
        
    case 2 % quick entry
        set = input('enter [m intmin int intmax] separated by space:\n ','s');
        set = str2num(set);
        m = set(1);
        Yn = MWTfdatGraphcode{m,2};
        intmin = set(2);
        int = set(3);
        intmax = set(4);
    case 3 % user prompt
        disp(MWTfdatGraphcode(:,1:2));
        mi = input('select measure code: ');
        m = MWTfdatGraphcode{mi,3};
        Yn = MWTfdatGraphcode{m,2};
        set(1) = m;
        intmin = input('starting time: ');
        set(2) = intmin;
        int = input('interval: ');
        set(3) = int;
        intmax = input('end time: ');
        set(4) = intmax;
        
        %% [future coding] - ask to store setting
end
end

%% [subfunction]
function storeanalysissetting(pFunSub)
cd(pFunSub);
save('analysisetting.mat','MWTfdatGraphcode','MWTfdatcode',...
    'setid','preset');
end