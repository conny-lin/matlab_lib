function savefigpdfx(figure,titlename,pSave)
% save figures 
% titlename = 'CombinedGraph';
cd(pSave);
h = figure;
set(h,'PaperPositionMode','auto'); % set to save as appeared on screen
print (h,'-dpdf', '-r150', titlename); % save as tiff
saveas(h,titlename,'fig'); % save as matlab figure 
close;
end