function ShankSparkGraph(pExp,pSet,MWTftrvG,MWTftrvL,option)


%% descriptive stats -------------------------------------------------------
% source code: [HabGraph3,X3,Y3,E3] = ShaneSparkstatcurvehab2(MWTftrvG,MWTftrvL,'Dist/TotalN');
% construct 'Graph.Dist.Mean'
[HabGraph3,X3,Graph.Dist.Mean,Graph.Dist.SE] = ShaneSparkstatcurvehab2(MWTftrvG,MWTftrvL,'DistNRev')
% HabGraph = MWTftrvG(:,1); % group name
% timeind = find(not(cellfun(@isempty,regexp(MWTftrvL(:,2),'Time'))));
% dataind = find(not(cellfun(@isempty,regexp(MWTftrvL(:,2),'Dist/NRev'))));
% 
% for g = 1:size(MWTftrvG,1); % for every group  
%     A = {};
%     HabGraph{g,2} = cell2mat((MWTftrvG{g,2}(:,timeind))'); % raw time 
%     HabGraph{g,3} = (1:size(HabGraph{g,2},1))'; % scaled time
%     A = cell2mat((MWTftrvG{g,2}(:,dataind))'); % get data option selected
%     HabGraph{g,4}= mean(A,2); 
%     HabGraph{g,5}= SE(A);
% end
% X = cell2mat(HabGraph(:,3)');
% Graph.Dist.Mean = cell2mat(HabGraph(:,4)'); 
% Graph.Dist.SE = cell2mat(HabGraph(:,5)');
%%
% graphing ----------------------------------------------------------------
% prep graphing --------
% source [G] = figvprep5(HabGraph,2,3,pFun,pExp,setfilename,GL,Yn,Xn,GAA);
% load graph settings
cd(pSet);
G = load('GraphSetting.mat');

% input variables
fname = [option '.ShankSparkStats'];
G.Ylabel = option;
G.Xlabel = 'Tap';
G.XTickLabel = cellstr(num2str(X(:,1)))';

% group names and graphing sequence
[~,p] = dircontentext(pExp,'Groups_*');
cd(pExp);
load(p{1});
G.legend = Groups(:,2);
% see if group needs to be resorted
if exist('GAA','var') ==0;   
    G.legend = Groups(:,2); X=X; Y=Y; E=E;
else
    k = cell2mat((GAA(:,1))'); 
    groupname = GAA(:,3);
    G.legend = groupname(k',1); Y = Y(:,k); X = X(:,k); E = E(:,k);   
end


% create figure % source: makefig(G); -----------
figure1 = figure('Color',[1 1 1]); % Create figure with white background
x = 1;
axes1 = axes('Parent',figure1,'FontName',G.FontName);
hold(axes1,'all');
errorbar1 = errorbar(X,Y,E,'Marker','.','LineWidth',1);
for i = 1:size(Y,2);
    set(errorbar1(i),'DisplayName', G.legend{i,1},'Color',G.Color(i,:)); 
end
%ylim(axes1,[G.Ymin(x) G.Ymax(x)]);
%xlim(axes1,[G.Xmin(x) G.Xmax(x)]);
ylabel(G.Ylabel,'FontName',G.FontName);
xlabel(G.Xlabel,'FontName',G.FontName);

legend(axes1,'show');
set(legend,'Location','NorthEast','EdgeColor',[1 1 1],'YColor',[1 1 1],...
    'XColor',[1 1 1],'TickDir','in','LineWidth',1);

% annotation: N
N = size(Y,2);
s = 'N=%d';
text = sprintf(s,N);
annotation(figure1,'textbox',G.Gp(6,1:4),'String',{text},'FontSize',10,...
    'FontName',G.FontName,'FitBoxToText','on','EdgeColor','none');

% annotation: experiment name
% fix names
[~,expname] = fileparts(pExp);
expname = strrep(expname,'_','-');
for x = 1:size(G.legend);
    G.legend{x,1} = strrep(G.legend{x,1},'_','-');
end
annotation(figure1,'textbox',G.Gp(7,1:4),'String',{expname},...
    'FontSize',10,'FontName',G.FontName,'FitBoxToText','on',...
    'EdgeColor','none');

% soure code: savefig(Yn,pSave);
% save figures 
titlename = option;
cd(pExp);
h = (gcf);
set(h,'PaperPositionMode','auto'); % set to save as appeared on screen
print (h,'-dtiff', '-r0', titlename); % save as tiff
saveas(h,titlename,'fig'); % save as matlab figure 
close;

end
