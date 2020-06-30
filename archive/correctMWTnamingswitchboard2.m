function correctMWTnamingswitchboard2(MWTfsn,pMWTf,pExp)

[fUG,pUG] = dircontentext(pExp,'UngroupRecord*'); % see if there are Grouped files or Ungroup record
[fGmat,pGmat] = dircontentext(pExp,'Group*.mat');
%% group by UnGroupRecord
if isempty(fUG)==0 
    % import UngroupRecord*.mat
    [f,p] = dircontentext(pUG{1},'UngroupRecord*.mat');
    cd(pUG{1});
    load(f{1}); 
    count = tabulate(cell2mat(UngroupRecord(:,1)));
    UngroupRecord = sortrows(UngroupRecord,1);
    for x = 1:size(count,1);
        if x == 1
            ri = 1;
        else
            ri = count(x-1,2)*(x-1)+1;
        end
        rf = count(x,2)*x;
        A = cell2mat(UngroupRecord(ri:rf,4));
        MWTfdatT = cell2mat(MWTfsn(:,1));
        [~,~,i] = intersect(A,MWTfdatT,'rows');
        % get display
        [p,~] = fileparts(UngroupRecord{ri,5});
        [~,gn] = fileparts(p);
            for y = 1:size(i,1); % get i and assign group
                MWTfdatA(y,1:2) = MWTfsn(i(y,1),1:2); % get selected files
                pMWTfA(y,1) = pMWTf(i(y,1),1); % get selected paths
            end
        correctMWTfgcodeungrouped(MWTfdatA,pMWTfA,gn);
    end
    
elseif isempty(fGmat)==0;
    display('coding for grouping through Group*mat...')% import Group*.mat
    
%% only correct group code
else
    disp(MWTfsn(:,2)); % display all experiment names
    if input('only group code incorect? (y=1,n=0): ')==1; 
        correctMWTfgcode2(MWTfsn,pExp); % correct group code only
    else
        error('Go to correct MWT naming program...');
    end
    
    
    
    A = MWTfsn;
end

