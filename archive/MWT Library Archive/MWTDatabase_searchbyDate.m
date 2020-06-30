function [pExpT,ExpfnT] = MWTDatabase_searchbyDate(ExpfnD,pExpfD)

%% Input
% ExpfnD = A.ExpfnD;
% pExpfD = A.pExpfD;

%% get exp date
a = regexpcellout(ExpfnD,'_','split');
a = a(:,1);
b = regexpcellout(a,'[A-Z]','split');
b = b(:,1);
b = str2num(cell2mat(b));
display('experiment list:');
display(makedisplay((ExpfnD)));

%% get date input
i = input('Enter date [yyyymmdd]: ');



%% search after a certain date
k = b >= i;
pExpT = pExpfD(k); 
ExpfnT = ExpfnD(k);

%% re run database search
% [B] = GetExpTargetInfo(pExpT);
display(sprintf('[%d] experiment found',numel(ExpfnT)));
disp(ExpfnT);


end