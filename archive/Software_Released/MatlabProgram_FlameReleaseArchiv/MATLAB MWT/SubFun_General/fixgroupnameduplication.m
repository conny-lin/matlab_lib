function [MWTfsncorr] = fixgroupnameduplication(pExp,MWTfsn)

%% [Developing, change t=1 to suspend] 
t = 1;
switch t
    case 0
        return
    case 1
    T = tabulate(MWTfsn(:,2));
    i = find(cell2mat(T(:,2))>1);
    if isempty(i) ==0;
        duplicateN = size(i,1); % number of duplicated files
        display(sprintf('Found %d names used more than once',duplicateN));
        duplicatename = sortrows(T(i,1));
        disp(duplicatename); % display duplicated file
        corrind = setdiff((1:size(T,1)'),i); % get number 
        %corrN = sortrows(T([corrind],1)); % file not duplicated
        P = 0;
    else
        P = 1;
    end
end



%% resolve group code duplication
displayoldgroupcode(pExp); % look at Groups mat% display groups
[groupcodemwt,mwtnamewogroupcode,groupcodeU,P] = findNvalidategroupcodes(MWTfsn);    
% mark all mwtf thats duplicated and report it
MWTfgcode = {};
MWTfgcode = cat(2,MWTfsn(:,1),groupcodemwt); % match gcode with mwt
diA = [];
diNA = [];
for x = 1:size(i,1); 
    di = find(ismember(MWTfsn(:,2),T(x(x)))); % find row of duplicated file
    diN = size(di,1);
    diNA = cat(1,diNA,diN);
    diA = cat(1,diA,di);       
end

ind = 1:size(MWTfsn,1)';
diAR = setdiff(ind,diA');
MWTfgcode([diA'],3) = {'dup'};
MWTfgcode([diAR],3) = {'-'};
MWTfgcode(:,4) = num2cell(ind);
MWTfgcodesort = sortrows(MWTfgcode,2);
display('MWTf sequence looks like this:');
disp(MWTfgcode(:,1:4));
display('groups sorted looks like this:');
disp(MWTfgcodesort(:,1:4));
    
    
%% USER input   
q = 1;
disp(MWTfgcode);
q2 = input('correct all at once(1) or individually (2)? ');
switch q2 
case 2
    while q ~=0;
        while isnumeric(x) ==0;
        x = input('Enter the index# to fix: '); 
        end
        while ischar(n) ~=1;
            n = input('Enter the correct group code: ','s');
        end
        MWTfgcode{x,2} = n;
        MWTfgcode{x,3} = 'corr';
        display(MWTfgcode);
        q = input('More to correct (y=1,n=0)? ');
    end
case 1
    n = [];
    while size(n,1) ~= size(MWTfsn,1);
        n = input('enter group codes for all plates above separated by space:\n','s');
        n = (regexp(n,' ','split'))';
        if size(n,1) == size(MWTfsn,1);
            MWTfgcode(:,2) = n;
        end
    end
end
gc = MWTfgcode(:,2);
%% put group code back
[MWTfsncorr] = reasemblemwtname2(MWTfsn(:,1),mwtnamewogroupcode,gc);


end