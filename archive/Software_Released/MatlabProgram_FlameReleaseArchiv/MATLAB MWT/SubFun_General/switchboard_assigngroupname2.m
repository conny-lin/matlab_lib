function [GA,MWTfgcode] = switchboard_assigngroupname2(MWTfsn,pFun,pExp,ID)
display(' ');
display('Running group name assignment...');
q = 0;
while q ==0;
switch ID;
    case 1 
        %% manually assign
        [~,gcode,~,MWTfgcode,~] = getMWTRC2(MWTfsn);
        GA = gcode;
        display('The following group codes are found:');
        disp(gcode);
        disp('type in the name of each group as prompted...');
        q1 = 'Name for group [%s]: ';
        i = {};
        for x = 1:size(GA,1);
             GA(x,2) = {input(sprintf(q1,GA{x,1}),'s')};
        end
        
    case 3 
        %% auto assign strain and manual assignt the rest
        [code,gcode,~,MWTfgcode,groupname] = getMWTRC2(MWTfsn);
        GA = gcode;
        % if strain is the only variable, auto assign
        if size(unique(code(:,3))) == size(unique(code(:,2)));
            A = unique(cellfun(@strcat,code(:,2),code(:,3),'UniformOutput',0));
            for x = 1:size(gcode,1);
                g(1:size(A,1),1) = gcode(x,1);    
                i = find(cellfun(@regexp,A,g));
                GA(x,2) = code(i,3);
            end
        else
            display('strain is not the only varialbe, auto assign strain name coding in progress..'); 
            
        end

    case 0 
        %% select assign (by continueing)
        [code,gcode,~,MWTfgcode,groupname] = getMWTRC2(MWTfsn)
        %%
        [GA] = assigngroupname2(RCpart,pFun,pExp,gcode);
        
    case 2 
        %% use group files
        cd(pExp);
        fn = dir('Groups*.mat'); % get filename for Group identifier
        fn = fn.name; % get group file name
        load(fn); % load group files
        GA = Groups;
    otherwise
        error('please enter 0 or 1');
end
   
%% create display
a = {};
a(1:size(GA,1),1) = {'['};
b = {};
b(1:size(GA,1),1) = {']'};
%%
GAd = char(cellfun(@strcat,a,GA(:,1),b,GA(:,2),'UniformOutput',0));
disp(GAd);
q = input('Are all group names correct (y=1,n=0)? ');



end


