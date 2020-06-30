%% Script name: RL201411201225
%% OBJECTIVE: combine 10, 15, 30, 45, and 60sISI for a particular strain

%% manually define data source folder names
DataSources = {'ShaneSpark_20141117025708_slo1 10sISI','S10sISI';
    'ShaneSpark_20141117034324_15sISI','S15sISI';
    'ShaneSpark_20141117051835_30sISI','S30sISI';
    'ShaneSpark_20141117052135_45sISI','S45sISI';
    'ShaneSpark_20141117073255_60sISI','S60sISI'};


%% define path for source data
pDataHome = '/Users/connylin/OneDrive/Dance_Output/';
pFun = '/Users/connylin/OneDrive/MATLAB/Functions_Developer';
addpath(pFun);
pScript = '/Users/connylin/OneDrive/RL_Scripts';
% create output folder
pSave = mfilename('fullpath'); % get script name
if isdir(pSave) == 0; mkdir(pSave); end % create output directory




%% get data and reorganize in array
A = struct;
A.Legend = DataSources(:,2)';

for x = 1:size(DataSources,1);
    p = [pDataHome,DataSources{x,1}]; % get data path
    % load data
    cd(p); load('matlab.mat','MWTSet');
    GroupNames = MWTSet.GraphGroup;
    measures = fieldnames(Data);

    for g = 1:numel(GroupNames)
        for m = 1:numel(measures)  
            M = measures{m};
            % get data
            A.(GroupNames{g}).(M).X(:,x)  = MWTSet.Graph.(M).X(:,g);
            A.(GroupNames{g}).(M).Y(:,x)  = MWTSet.Graph.(M).Y(:,g);
            A.(GroupNames{g}).(M).SD(:,x)  = MWTSet.Graph.(M).SD(:,g);
            A.(GroupNames{g}).(M).E(:,x)  = MWTSet.Graph.(M).E(:,g);
            A.(GroupNames{g}).(M).N(:,x)  = ((sd./e).^2)+1;
        end
    end
end

%% export legend
cd(pSave);
writetable(cell2table(A.Legend),'legend.txt','Delimiter','\t');

%% save mat
Data = A; cd(pSave); save('matlab.mat', 'Data');

%% reorganize in txt table
GroupNames = fieldnames(A);
GroupNames(ismember(GroupNames,'Legend')) = [];

for g = 1:numel(GroupNames)
    gname = GroupNames{g};
    measures = fieldnames(A.(gname));
    for m = 1:numel(measures)
        M = measures{m};
        T = struct2table(A.(gname).(M));
        cd(pSave);
        writetable(T,[char(gname),'_',char(M),'.txt'],'Delimiter','\t')
    end
end


%% graphing
linenames = A.Legend;
GroupNames = fieldnames(A);
GroupNames(ismember(GroupNames,'Legend')) = [];
for g = 1:numel(GroupNames)
    gname = GroupNames{g};
    measures = fieldnames(A.(gname));
      for m = 1:numel(measures)
            M = measures{m};  
            x = repmat((1:size(A.(gname).(M).X,1))',1,size(A.(gname).(M).X,2));
            y = A.(gname).(M).Y;
            e = A.(gname).(M).E;
            % Create figure
            figure1 = figure('Color',[1 1 1]);
            axes1 = axes('Parent',figure1,'FontSize',12); hold(axes1,'all');
            errorbar1 = errorbar(x,y,e);
            for x = 1:size(x,2)
                set(errorbar1(x),'MarkerSize',30,'Marker','.',...
                    'LineWidth',2,...
                'DisplayName',linenames{x});
            end
            title(char(gname),'FontSize',14);
            xlabel('Tap','FontSize',14);
            ylabel(char(M),'FontSize',14);
            legend1 = legend(axes1,'show');
           set(legend1,'EdgeColor',[1 1 1],'YColor',[1 1 1],'XColor',[1 1 1]);
            savefigjpeg([char(gname),'_',char(M)],pSave);
      end
     

end

%% CODE RETURN
display '*** CODE RETURN ***';
return