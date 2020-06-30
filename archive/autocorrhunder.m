function [new] = autocorrhunder(part)
%% Auto correct [h_] to [h]...
display 'Auto correct [h_] to [h]...';
[new] = regexprep(part,'h_','h'); % replace h_ with h
% detect how many files different
diff = setdiff(part,new);
display(sprintf('%d files autocorrected',numel(diff)));
disp(diff);
end