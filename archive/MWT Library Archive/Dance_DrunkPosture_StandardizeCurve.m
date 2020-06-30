
cd(pSaveA); load('matlab.mat','Graph','MWTfG');

%% STANDARDIZE CURVE
Graph.GroupName = cell(size(Graph.MWTfn));
groupnames = fieldnames(MWTfG);
for g = 1:numel(groupnames)
    i = ismember(Graph.MWTfn,MWTfG.(groupnames{g})(:,1)');
    Graph.GroupName(i) = groupnames(g);  %Graph.MWTfN
end

% select group name to be standard
groupnames = fieldnames(MWTfG);
makedisplay(groupnames,1);
controlname = groupnames(input('choose control group: '));
i = ismember(Graph.GroupName,controlname);

% create control
GraphS.GroupName = Graph.GroupName(~i);
GraphS.GroupNameControl = Graph.GroupName(i);
GraphS.MWTfn = Graph.MWTfn(~i);
GraphS.MWTfnControl = Graph.MWTfn(i);

% create exp groups
measure = fieldnames(Graph.Y); 
gnames = fieldnames(MWTfG);
gnames = gnames(~ismember(gnames,controlname));

% move groups
for m = 1:numel(measure)
%     disp(measure{m});    
    GraphS.YControl.(measure{m}) = Graph.Y.(measure{m})(:,i);
    GraphS.Y.(measure{m}) = Graph.Y.(measure{m})(:,~i);
end



%% calculate and graph
for m = 1:numel(measure)

    ctrlmean = nanmean(GraphS.YControl.(measure{m}),2)';
    ctrlerror = nanstd(GraphS.YControl.(measure{m})');
    % divide by control mean

    Y = []; E = [];
    X = Graph.X(2:end);
    expmean = []; experror = [];
    for g = 1:numel(gnames)
        groupname = gnames(g);
        i = ismember(GraphS.GroupName,groupname);
        expdata = (GraphS.Y.(measure{m})(:,i))';
        expsize = size(expdata,1);
        expstd = expdata./repmat(ctrlmean,expsize,1);
        Y(g,:) = nanmean(expstd);
        E(g,:) = nanstd(expstd./sqrt(expsize));
    end
    
    
    %% plot standard graph
    figure('Color',[1 1 1]);
    axes('FontSize',20); hold on
    ylabel(measure{m}); hold on
    % plot control
    ctrline = ones(size(ctrlmean));
    upper = ctrlerror + ctrline;
    lower = ctrline - ctrlerror;
    area(X,upper,'BaseValue',0.0002,'FaceColor',[0.8 0.8 0.8],...
        'LineStyle','none'); 
    area(X,lower,'BaseValue',0.0001,'FaceColor',[1 1 1],...
        'LineStyle','none','EdgeColor','none')
    line(X,ctrline,'Color',[0 0 0],'LineWidth',2); hold on;
    groupsize = numel(gnames);
    % plot error bar
    hold on
    errorbar(repmat(X,groupsize,1)',Y',E','LineWidth',2);%,'Color',[0 0 0]);
    savename = ['Std_',controlname{1},'_',measure{m}];
    savefigjpeg(savename,pSaveA);

    %% save legend just for first graph
    if m ==1
        f1 = figure('Color',[1 1 1]);
        line(X,ctrline,'Color',[0 0 0],'LineWidth',2); hold on;
        errorbar(repmat(X,groupsize,1)',Y',E','LineWidth',2);
        gnameshow = [controlname,regexprep(gnames,'_',' ')];
        legend(gnameshow,'FontSize',12);
        savefigjpeg('legend_stdgraph',pSaveA);
    end
end


%% SPEED AVERAGE BAR GRAPH
for m = 1:1%numel(measure)
    ctrldata = GraphS.YControl.(measure{m});
    ctrldata = reshape(ctrldata,numel(ctrldata),1);
    ctrlmean = nanmean(ctrldata);
    ctrlerror = nanstd(ctrldata);
    % divide by control mean
% 

    expmean = []; experror = [];
    Y = []; E = [];
    for g = 1:numel(gnames)
            groupname = gnames(g);
            i = ismember(GraphS.GroupName,groupname);
            expdata = (GraphS.Y.(measure{m})(:,i))';
            expdata = reshape(expdata,numel(expdata),1);
            expmean(g) = nanmean(expdata);
            experror(g) = nanstd(expdata);
    end
end

%%
Y = [ctrlmean,expmean];
bar([1 2],Y)


%%

 fprintf = {'20130430C_CL_0s360x10s0s_Basal60m';
    '20130622X_AH_0s360x10s0s';
    '20130626X_AH_0s360x10s0s';
    '20130919C_CL_0s360x10s0s_60minBasalInverted'};















