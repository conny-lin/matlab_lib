%% correlation of Curve/Kink with width
% pSave = cd;
% load('matlab.mat','Graph');
% 
% 
% Measure = {'Curve';'Width';'Kink'};
% 
% for m = 1:numel(Measure)
%     A.(Measure{m}).sober = Graph.Y.(Measure{m})(:,1:4);
%     
%     A.(Measure{m}).drunk = Graph.Y.(Measure{m})(:,5:8);
% end
% 
% 
% %% Create correlation
% Par = 'Curve'; Base = 'Width';
% figure1 = figure;
% axes1 = axes('Parent',figure1,'FontSize',18);
% hold(axes1,'all');
% condition = 'sober';
% B = A.(Par).(condition);
% i = size(B,1)*size(B,2);
% B = reshape(B,i,1);
% A.(Par).(condition) = B;
% 
% C = A.(Base).(condition);
% i = size(C,1)*size(C,2);
% C = reshape(C,i,1);
% A.(Base).(condition) = C;
% D = [B,C];
% scatter(B,C,'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],...
%     'Parent',axes1,'DisplayName',condition);
% hold on;
% condition = 'drunk';
% B = A.(Par).(condition);
% i = size(B,1)*size(B,2);
% B = reshape(B,i,1);
% A.(Par).(condition) = B;
% C = A.(Base).(condition);
% i = size(C,1)*size(C,2);
% C = reshape(C,i,1);
% A.(Base).(condition) = C;
% D = [B,C];
% scatter(B,C,'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0],...
%     'Parent',axes1,'DisplayName',condition);
% xlabel(Par,'FontSize',25,'FontName','Arial');
% ylabel(Base,'FontSize',25,'FontName','Arial');
% legend1 = legend(axes1,'show');
% set(legend1,'EdgeColor',[1 1 1],...
%     'Position',[0.22 0.7 0.09 0.09],...
%     'FontName','Arial');
% savefigjpeg([Par,Base,'Corr'],pSave);
% 
% 
% %% kink
% Par = 'Kink'; Base = 'Width';
% figure1 = figure;
% axes1 = axes('Parent',figure1,'FontSize',18);
% hold(axes1,'all');
% condition = 'sober';
% B = A.(Par).(condition);
% i = size(B,1)*size(B,2);
% B = reshape(B,i,1);
% A.(Par).(condition) = B;
% 
% C = A.(Base).(condition);
% i = size(C,1)*size(C,2);
% C = reshape(C,i,1);
% A.(Base).(condition) = C;
% D = [B,C];
% scatter(B,C,'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],...
%     'Parent',axes1,'DisplayName',condition);
% hold on;
% condition = 'drunk';
% B = A.(Par).(condition);
% i = size(B,1)*size(B,2);
% B = reshape(B,i,1);
% A.(Par).(condition) = B;
% C = A.(Base).(condition);
% i = size(C,1)*size(C,2);
% C = reshape(C,i,1);
% A.(Base).(condition) = C;
% D = [B,C];
% scatter(B,C,'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0],...
%     'Parent',axes1,'DisplayName',condition);
% xlabel(Par,'FontSize',25,'FontName','Arial');
% ylabel(Base,'FontSize',25,'FontName','Arial');
% legend1 = legend(axes1,'show');
% set(legend1,'EdgeColor',[1 1 1],'YColor',[1 1 1],'XColor',[1 1 1],...
%     'Position',[0.22 0.7 0.09 0.09],...
%     'FontName','Arial');
% savefigjpeg([Par,Base,'Corr'],pSave);
% 
% %% curve vs kink
% Par = 'Curve'; Base = 'Kink';
% figure1 = figure;
% axes1 = axes('Parent',figure1,'FontSize',18);
% hold(axes1,'all');
% condition = 'sober';
% B = A.(Par).(condition);
% i = size(B,1)*size(B,2);
% B = reshape(B,i,1);
% A.(Par).(condition) = B;
% 
% C = A.(Base).(condition);
% i = size(C,1)*size(C,2);
% C = reshape(C,i,1);
% A.(Base).(condition) = C;
% D = [B,C];
% scatter(B,C,'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],...
%     'Parent',axes1,'DisplayName',condition);
% hold on;
% condition = 'drunk';
% B = A.(Par).(condition);
% i = size(B,1)*size(B,2);
% B = reshape(B,i,1);
% A.(Par).(condition) = B;
% C = A.(Base).(condition);
% i = size(C,1)*size(C,2);
% C = reshape(C,i,1);
% A.(Base).(condition) = C;
% D = [B,C];
% scatter(B,C,'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0],...
%     'Parent',axes1,'DisplayName',condition);
% xlabel(Par,'FontSize',25,'FontName','Arial');
% ylabel(Base,'FontSize',25,'FontName','Arial');
% legend1 = legend(axes1,'show');
% set(legend1,'EdgeColor',[1 1 1],'YColor',[1 1 1],'XColor',[1 1 1],...
%     'Position',[0.22 0.7 0.09 0.09],...
%     'FontName','Arial');
% savefigjpeg([Par,Base,'Corr'],pSave);
