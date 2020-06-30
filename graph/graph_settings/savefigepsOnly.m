function savefigepsOnly(titlename,pSave)
% save figures 
% titlename = 'CombinedGraph';
cd(pSave);
h = (gcf);
set(h,'PaperPositionMode','auto'); % set to save as appeared on screen
% saveas(h,titlename,'fig'); % save as matlab figure 
print (h,'-depsc', '-r1200', titlename); % save as tiff

%print (h,'-djpeg', titlename); % save as tiff

close;
end