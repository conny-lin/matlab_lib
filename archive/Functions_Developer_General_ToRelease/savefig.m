function savefig(titlename,pSave)
% save figures 
% titlename = 'CombinedGraph';
cd(pSave);
h = (gcf);
set(h,'PaperPositionMode','auto'); % set to save as appeared on screen
print (h,'-dtiff', '-r0', titlename); % save as tiff
saveas(h,titlename,'fig'); % save as matlab figure 
close;
end