% function graphEy(DataG,strain,timeName,pSave,Setting)

pM = setup_std(mfilename('fullpath'),'RL','genSave',false);

return

% get data 
G = struct;

%%
gnu = cell(size(DataG,2),1);
for gi = 1:size(DataG,2)
   gnu{gi} = DataG(gi).name;
end
i = regexpcellout(gnu,'N2');
gnuseq = [gnu(i);gnu(~i)];
gnuindseq = [find(i);find(~i)]';


%%
for gi = 1:size(DataG,2)
    gii= gnuindseq(gi);
    x = DataG(gii).time(1,6:41);
    Y = DataG(gii).speedb(:,6:41);
    
    Y(:,6) = NaN;
    y = nanmean(Y);
    n = sum(~isnan(Y));
    e = nanstd(Y)./sqrt(n-1);
    e2 =e*2;
    g = {DataG(gi).name};    
    G.g(1,gi) = g;
    G.x(:,gi) = x';
    G.y(:,gi) = y';
    G.e(:,gi) = e2';
end


Setting.DisplayName = G.g;

figure1 = figure('Visible','off'); hold on;
errorbar1 = errorbar(G.x,G.y,G.e);
SettingNames = fieldnames(Setting);
for si = 1:numel(SettingNames)
    nms = SettingNames{si};
for gi = 1:size(errorbar1,2)
    errorbar1(gi).(nms) = Setting.(nms){gi};
end
end
title([strain,' (',regexprep(timeName,'_','-'),')'])
switch timeName
    case 't1'
        ylimNum = [-.5 .4];
    case 't28_30'
        ylimNum = [-.3 .4];
end 
xlim([-.5 2]);
ylim(ylimNum );
ylabel('velocity (body length/s)')

savename = sprintf('%s ephys %s',strain,timeName);
printfig(savename,pSave,'w',2,'h',2,'closefig',1);



