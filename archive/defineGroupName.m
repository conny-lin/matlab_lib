function [gnmaster,groupnameU] = defineGroupName(pExp)
% [DEVELOP] Group MWT into folders and 
%[GA,MWTfgcode] = assigngroupnameswitchboard2(MWTfsn,pFun,pExp,0);
[MWTfsn,~] = draftMWTfname3('*set',pExp); % get names
A = MWTfsn(:,2); % get run names

%% get parts of name % NM1968_12x2_l96h20C_100s30x10s10s_C0306ch.set
i = regexp(A,'_'); % parse name
for x = 1:numel(A); 
    group{x,1} = A{x}(end-1); % get group name
    runcondition{x,1} = A{x}(i{x}(3)+1:i{x}(4)-1); % run condition
    strain{x,1} = A{x}(1:i{x}(1)); % strain
end

%% prepare group name
% create initial group name from strain and run condition
groupnamelist = cellfun(@strcat,strain,runcondition,'UniformOutput',0);
% create display
b1(1:numel(groupnamelist),1) = {'['};
b2(1:numel(groupnamelist),1) = {']'};
groupnameshow = cellfun(@strcat,b1,group,b2,groupnamelist,'UniformOutput',0);
% construct master
gnmaster = [group groupnamelist groupnameshow];
% get unique value
groupU = unique(gnmaster(:,1));
groupnameU = unique(gnmaster(:,2));
groupnameShow = unique(gnmaster(:,3));
% evaluate if more IV is needed
moreIV = (numel(unique(groupU))/numel(groupnameU))~=1; % see how many other conditions
if moreIV ~=1;
    display 'Only variable found is strain';
    display(groupnameU);
    CHECK = input('Correct (y=1,n=0)? ');
    if CHECK ==0;
        save('GroupNameProblem.mat');
    end
end

while moreIV ==1;  
    % display instruction
display 'Adding independent variables(IV) to group name one at a time...';
display '1) enter the name of the IV (i.e. ethanol, food)';
display '2) enter the names of the IV variables separated by [space]';
display '   *DO NOT enter control variable, such as 0mM*';
display '   i.e. for ethanol (IV), enter variable names as 400mM';
% add other conditions to name
display ' ';
display 'Enter the name of an experimental condition (i.e. ethanol)';
IV = {};
IV{1,1} = input(': ','s'); % ask for condition name (i.e. ethanol) - loop
display 'Enter the names of the IV variables separated by [space]';
IVvar = {};
IVvar(1,:) = regexp(input(': ','s'),' ','split');
% prmopt to add IVvar to group name
disp(groupnameShow);
for x = 1:numel(IVvar)
display 'Enter all group codes separated y [space]';
display(sprintf('that belongs to [%s] group',IVvar{x}));
g = regexp(input(': ', 's'),' ','split'); % find group code to be added the IVvar
for y = 1:numel(g) 
    i = not(cellfun(@isempty,regexp(gnmaster(:,1),g{y}))); % find group code in master list 
    % add name
    k = find(i); % find number to change
    [underscore] = cellfunexpr(k,'_');
    [newVar] = cellfunexpr(k,IVvar{x});
    gnmaster(i,2) = cellfun(@strcat,gnmaster(i,2),underscore,newVar,'UniformOutput',0); % addIVvar
end
end
% renew group name master
% re-create groupnameshow
b1(1:numel(groupnamelist),1) = {'['};
b2(1:numel(groupnamelist),1) = {']'};
groupnameshow = cellfun(@strcat,b1,group,b2,gnmaster(:,2),'UniformOutput',0);
% re-construct master
gnmaster = [group gnmaster(:,2) groupnameshow];
% get unique value
groupU = unique(gnmaster(:,1));
groupnameU = unique(gnmaster(:,2));
% evaluate if more IV is needed
moreIV = (numel(unique(groupU))/numel(groupnameU))~=1;  % see how many other conditions


end
% save
cd(pExp);
save('GroupName.mat','groupnameU','gnmaster');
end
