function [GA,MWTfgcode] = assigngroupnameswitchboard2(MWTfsn,pFun,pExpO,ID)
display(' ');
display('Running group name assignment...');
displayoldgroupcode(pExpO);
q = 0;
while q ==0;
if ID == 0;
    ID = input('Manually assign(1), use group files (2), autostrain assign(3): ');
end
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
        
    case 2 
        %% use group files
        cd(pExpO);
        fn = dir('Groups*.mat'); % get filename for Group identifier
        fn = fn.name; % get group file name
        load(fn); % load group files
        GA = Groups;
        MWTfgcode = MWTfgcode;
        
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
        [GA] = assigngroupname2(RCpart,pFun,pExpO,gcode);
        
    
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


