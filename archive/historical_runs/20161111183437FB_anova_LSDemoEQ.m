%% INITIALIZING ++++++++++++++
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',true);
% addpath(pM);
% ----------------------------


%% SETTING +++++++++++++++++++
pData = '/Users/connylin/Dropbox/FB Publication/20161115 Poster FB SfN lifestyle factor emotion/2-Materials&Methods/Data';
% ---------------

%% load data +++++++++++++
load(fullfile(pData,'Data.mat'));
% ----------------------------


%% anova load each factors separately
msrlist = {'EQ35_score','EQ37_score'};
glist = legend_LS_Q.q_abbr1;
A = nan(numel(glist),numel(msrlist));
for mi = 1:numel(msrlist)
    msr = msrlist{mi};
    X = Zscore.(msr);
    for gi = 1:numel(glist)
        G = LS_Ans(:,gi);
        [text,T,p,s,t,ST] = anova1_autoresults(X,G);
        A(mi,gi)=p;
    end
end
T = array2table(A,'VariableNames',msrlist,'RowNames',glist);
writetable(T,fullfile(pM,'anova p value.csv'),'WriteRowNames',1);
return




%%
S = [ScoreFinal(:,1:3)];
S = table2array(S);
S(any(isnan(S),2),:) = [];
[cidx2,cmeans2] = kmeans(S,2);
[silh2,h] = silhouette(S,cidx2,'sqeuclidean');

ptsymb = {'bs','r^','md','go','c_'};
for i =1:2
    clust = find(cidx2 ==i);
    plot3(S(clust,1),S(clust,2),S(clust,3),ptsymb{i});
    hold on

end
plot3(cmeans2(:,1),cmeans2(:,2),cmeans2(:,3),'ko');
plot3(cmeans2(:,1),cmeans2(:,2),cmeans2(:,3),'kx');
hold off
xlabel('score');
ylabel('RT');
zlabel('accuracy');
% view(-137,10);
grid on





