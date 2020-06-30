function zipall(pExp)
%% zipall
[~,~,f,p] = dircontent(pExp);
cd(pExp);
for x = 1:size(p,1);
zip(f{x,1},p{x,1});
end
end