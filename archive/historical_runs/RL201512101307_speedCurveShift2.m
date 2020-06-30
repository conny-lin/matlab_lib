%% setting
pData = '/Volumes/COBOLT/MWT';
pSaveHome = '/Users/connylin/Dropbox/RL/PhD/Chapters/2-STH N2/Data/10sISI/1-All Exp';
pA = '/Users/connylin/Dropbox/RL/PhD/Chapters/2-STH N2/Data/10sISI/1-All Exp/Dance_Glee_Showmance';

cd(pA); load('Dance_Glee_Showmance.mat');

%% get speed data
% find initial mean
a1 = mean(MWTSet.Data.ByGroupPerPlate.N2.RevSpeed_Mean(1,:));
a2 = mean(MWTSet.Data.ByGroupPerPlate.N2_400mM.RevSpeed_Mean(1,:));
% find difference between N2 inital mean and N2_400mM initial mean
df = a2-a1;
%% see if still RMANOVA diff
pSaveA = [pA,'/Stats HabCurve Speed Norm']; if isdir(pSaveA) == 0;mkdir(pSaveA); end
msrname = 'RevSpeed';
A = {};
A{1} = MWTSet.Data.ByGroupPerPlate.N2.RevSpeed_Mean';
A{2} = (MWTSet.Data.ByGroupPerPlate.N2_400mM.RevSpeed_Mean-df)';
% repeated measures anova
if numel(A) > 1
    [p,t] = anova_rm(A,'off');
    b = anovan_textresult(t);
    str = sprintf('%s/%s HabCurve RMANOVA.txt',pSaveA,msrname);
    fid = fopen(str,'w');
    fprintf(fid,'Repeated Measures ANOVA of %s all groups:\n',msrname);
    for x = 1:numel(b)
        fprintf(fid,'%s\n',b{x});
    end
    fclose(fid);
end

%% graph
e = [(std(A{1})./sqrt(size(A{1},1)-1))' (std(A{2})./sqrt(size(A{2},1)-1))'];
y = [mean(A{1})' mean(A{2})'];
errorbar(y,e)
savefigeps('RevSpeed Normalized',pSaveA);