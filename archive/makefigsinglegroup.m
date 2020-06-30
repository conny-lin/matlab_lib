function makefigsinglegroup(Mean,SE,Yn,Xn,GroupName)
%% settings
FontName = 'Ariel';
%% create figure 
figure1 = figure('Color',[1 1 1]); % Create figure with white background
x = 1;
axes1 = axes('Parent',figure1,'FontName',FontName);
hold(axes1,'all');
errorbar1 = errorbar(Mean,SE,'Marker','.','LineWidth',1,...
    'DisplayName',GroupName);
%ylim(axes1,[G.Ymin(x) G.Ymax(x)]);
%xlim(axes1,[G.Xmin(x) G.Xmax(x)]);
ylabel(Yn,'FontName',FontName);
xlabel(Xn,'FontName',FontName);

legend(axes1,'show');
set(legend,'Location','NorthEast','EdgeColor',[1 1 1],'YColor',[1 1 1],...
    'XColor',[1 1 1],'TickDir','in','LineWidth',1);

end



