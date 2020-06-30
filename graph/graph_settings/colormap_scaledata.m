function b = colormap_scaledata(map,a)

b = nan(size(a));    
if sum(sum(~isnan(a))) >1 % if more than one data point in a
    n = size(map,1);
    m = min(min(a));
    mx = max(max(a));
    scale = m:(mx-m)/(n-1):mx;
    for si = 1:numel(scale)-1
        b(a>=scale(si) & a<=scale(si+1)) = si;
    end
    b(a==scale(end)) = numel(scale)-1;
    b(isnan(a)) = n;
else % if 1 or less data point in a, use the second last color
    %%
    b(~isnan(a)) = size(map,1)-1;
end