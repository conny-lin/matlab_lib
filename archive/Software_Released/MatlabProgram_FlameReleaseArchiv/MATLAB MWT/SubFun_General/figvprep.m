function [G] = figvprep(D,mi,sei,pFun,pExp,setfilename,Gname,fname,Yn,Xn,GAA)
    %% Graphing: individual
%   setfilename = 'GraphSetting.mat';
%   fname = 'Tap_Dist.dat';
%   Yn = 'Dist';
%   Xn = 'Stim';
%   D = Stats.curve;
%   mi = 4; % c of mean
%   sei = 5; % c of se

% load graph settings
cd(pFun);
G = load(setfilename);
G.legend = Gname;
% load graph data source
G.Ylabel = Yn;
G.Xlabel = Xn;
[~,f] = ismember(fname,D(:,1)); % find row for fname
t1 = isequal(f,0); % test if fname exists
switch t1
    case 1; % doesn't exist
        error(sprintf('imported data is not %s...',fname));
    case 0
        G.Y = D{f,mi};
        G.E = D{f,sei};
end

%% see if group needs to be resorted
if exist('GAA','var') ==0;
    ...
else
    G.gs = cell2mat((GAA(:,1))');
    YA = G.Y;
    EA = G.E;
    for x = 1:size(G.gs,2);
        YA(:,x) = G.Y(:,G.gs(1,x));
        EA(:,x) = G.E(:,G.gs(1,x));
    end
    G.Y = YA;
    G.E = EA;
end
%% fix names
[~,G.expname] = fileparts(pExp);
G.expname = strrep(G.expname,'_','-');
for x = 1:size(G.legend);
    G.legend{x,1} = strrep(G.legend{x,1},'_','-');
end

    end