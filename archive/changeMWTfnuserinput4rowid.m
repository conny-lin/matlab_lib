function [MWTfsncorr] = changeMWTfnuserinput4rowid(MWTfsn,i)
MWTfsncorr = MWTfsn;
for x = 1:size(i,1);
    newname = MWTfsn{i(x,1),2};
    q1 = 0;
    while q1 ==0;
        display(' ');
        disp(newname);
        newname = input('Please enter correct full name:\n','s');
        q1 = input('is this correct (y=1,n=0)? ');
        MWTfsncorr{i(x,1),2} = newname;
    end   
end