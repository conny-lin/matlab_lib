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

%%
pG = cellfun(@fileparts,pMWT,'UniformOutput',0); % get group path
[pExp,Gn] = cellfun(@fileparts,pG,'UniformOutput',0); % get group name
[~,Expn] = cellfun(@fileparts,pExp,'UniformOutput',0); % get group name


%% get same as group name
[i,r] = ismember(Gn,gnameT);
ExpnT = unique(Expn(i));

eval = false(size(Expn));
for x = 1:numel(ExpnT)
   eval(ismember(Expn,ExpnT(x))) = true;
end
pMWTT = pMWT(eval);

% 
% %%
% % [~,ExpfnT] = cellfun(@fileparts,pExp,'UniformOutput',0);
% pExp = pExp(i); % get exp with the group name
% 
% %%
% pExp = unique(pExp);
% display(sprintf('%d experiments found',numel(pExp)));
% [~,ExpfnT] = cellfun(@fileparts,pExp,'UniformOutput',0);
% i = ismember(Expn,ExpfnT);
% pMWT = pMWT(i);


%% search with exp

[MWTfG2] = reconstructMWTfG(pMWTT);


end