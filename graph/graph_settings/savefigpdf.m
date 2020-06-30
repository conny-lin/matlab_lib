function savefigpdf(titlename,pSave,varargin)

%%
figsave = 0;
closefig = 1;
vararginProcessor;

h = (gcf);
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches',...
    'PaperSize',[pos(3), pos(4)]);

cd(pSave);
print(h,'-dpdf', titlename); % save as tiff
if figsave
    savefig(titlename);
end
if closefig
close;
end
end