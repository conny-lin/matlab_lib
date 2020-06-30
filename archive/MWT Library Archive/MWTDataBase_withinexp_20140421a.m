function [MWTfG2] = MWTDataBase_withinexp(MWTfG)

%%
gname = fieldnames(MWTfG);
disp(makedisplay(gname));
a = input('select groups that must be in a valid expriments\n: ','s');
gnameT = gname(str2num(a'));


%% GET group name from MWTfG
if isstruct(MWTfG) ==1
    A = celltakeout(struct2cell(MWTfG),'multirow');
    pMWT = A(:,2); 
end
p = cellfun(@fileparts,pMWT,'UniformOutput',0); % get group path
[pExp,gfn] = cellfun(@fileparts,p,'UniformOutput',0); % get group name
[~,expname] = cellfun(@fileparts,pExp,'UniformOutput',0); % get group name


% get same as group name
[i,r] = ismember(gfn,gnameT);
sum(r);
% [~,ExpfnT] = cellfun(@fileparts,pExp,'UniformOutput',0);
pExp = pExp(i); % get exp with the group name

pExp = unique(pExp);
display(sprintf('%d experiments found',numel(pExp)));
[~,ExpfnT] = cellfun(@fileparts,pExp,'UniformOutput',0);
i = ismember(expname,ExpfnT);
pMWT = pMWT(i);


%% search with exp

[MWTfG2] = reconstructMWTfG(pMWT);


end