% STEP2D: eliminate zero game scores
function [Data] = eliminatezeros(Data,index)
display(sprintf('eliminating zeros on column %d',index));
a = not(Data(:,index) ==0);
Data = Data(a,:);
str = '%d score=0 removed, %d valid datapoints';
display(sprintf(str,sum(not(a)),size(Data,1)));
