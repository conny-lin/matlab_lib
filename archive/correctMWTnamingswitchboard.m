function [A] = correctMWTnamingswitchboard(MWTfdat)
disp(MWTfdat(:,2)); % display all experiment names
if input('only group code incorect? (y=1,n=0): ')==1; 
    correctMWTfgcode(MWTfdat,pExp); % correct group code only
else
    error('Go to correct MWT naming program...');
end
A = MWTfdat;
end