function [GAA] = groupseq(GA)
%% assign sequence of groups for graphing
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

end