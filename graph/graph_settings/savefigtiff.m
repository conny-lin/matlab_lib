function savefigtiff(titlename,pSave)
    % save figures 
    % titlename = 'CombinedGraph';
    cd(pSave);
    h = (gcf);
    set(h,'PaperPositionMode','auto'); % set to save as appeared on screen
    saveas(h,titlename,'fig'); % save as matlab figure 
    print (h,'-dtiff', '-r0', titlename); % save as (r600 will give better resolution)
    close;
end