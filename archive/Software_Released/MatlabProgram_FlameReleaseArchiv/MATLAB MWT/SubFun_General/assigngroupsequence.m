function [GAA] = assigngroupsequence(pExp)
display ' ';
display 'assigning group graph sequence...';

% load Groups.mat
[groupmatname,p] = dircontentext(pExp,'Groups_*.mat');
if numel(groupmatname)==1 && iscell(groupmatname)==1;
    load(groupmatname{1});
elseif numel(groupmatname)>1 && iscell(groupmatname)==1;
    load(groupmatname{1});
else
    display 'No Groups_*.mat imported';
end
% show Groups var
if (exist('Groups','var'))==1;
    [dash] = char(cellfunexpr(Groups,')'));
    groupmatshow = [char(Groups(:,1)) char(dash) char(Groups(:,2))];
    display 'Previous Group files found and says this:';
    disp(groupmatshow);
    GA = Groups;
end
% assign group sequence for graphing % source code:  [GAA] = groupseq(GA)   
GAs = GA;
GAA = {};
i = num2cell((1:size(GA,1))');
GAs = cat(2,i,GA);
GAA = GAs;
disp(GAs);
q2 = input('is this the sequence to be appeared on graphs (y=1 n=0): ');
while q2 ==0;
    s = str2num(input('Enter the index sequence to appear on graphs separated by space...\n','s'));
    for x = 1:size(GAs,1);
        GAA(x,:) = GAs(s(x),:);
    end
    disp('')
    disp(GAA)
    q2 = input('is this correct(y=1 n=0): ');
end
cd(pExp);
save(groupmatname{1});


display 'done.';