%% CODING---------------------


%% days between sessions
timeS = (60*60*24); 
t1 = t/timeS;
for k = 1:120;
    i = t1(:)>k-1 & t1(:,1)<k;
    X(k,1) = k;
    Y(k,1) = mean(c(i));
    E(k,1) = std(c(i)')./sqrt(sum(i));
end
G = [X,Y,E];
display 'graph output done';

%% hours between sessions
timeS = (60*60); 
t1 = t/timeS;
G = []; X = []; Y = []; E = [];
for k = 1:96;
    i = t1(:)>k-1 & t1(:,1)<k;
    X(k,1) = k;
    Y(k,1) = mean(c(i));
    E(k,1) = std(c(i)')./sqrt(sum(i));
end
G = [X,Y,E];
display 'graph output done';

%% weeks between sessions
timeS = (60*60*24*7); 
t1 = t/timeS;
G = []; X = []; Y = []; E = [];
for k = 1:30;
    i = t1(:)>k-1 & t1(:,1)<k;
    X(k,1) = k;
    Y(k,1) = mean(c(i));
    E(k,1) = std(c(i)')./sqrt(sum(i));
end
G = [X,Y,E];
display 'graph output done';