function [MWTfsn] = correctMWTfnmanual(MWTfsn,pExp)
ID = 0;
MWTfsncorr = MWTfsn;
disp('');
displayallMWTfrunname2(MWTfsn);
displayoldgroupcode(pExp);
q1 = input('Are all MWTf named correctly? (y=1,n=0) ');
while q1==0;
displayallMWTfrunname2(MWTfsn);
for x = 1:size(MWTfsn,1);
    disp('');
    q0 = 0;
    while q0 == 0;
        disp('');
        disp(sprintf('for MWT experiment: %s',MWTfsn{x,1}));
        disp(sprintf('MWT current run name: %s',MWTfsn{x,2}));
        MWTfsncorr{x,2} = input('Enter the correct name: ','s');
        q0 = input('is this correct? (y=1,n=0) ');  
    end
end

displayallMWTfrunname2(MWTfsncorr); % display corrected
q1 = input('Are all MWTf named correctly? (y=1,n=0) ');    
display('restart name correction...');
end
 
changeMWTname(pExp,MWTfsn,MWTfsncorr); % correct files
[MWTfsn] = draftMWTfname2('*set',pExp); % reload MWTfsn