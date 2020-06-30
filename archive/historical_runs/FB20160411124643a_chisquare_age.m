%% INITIALIZING
clc; clear; close all;
%% PATHS
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pSave = setup_std(mfilename('fullpath'),'FB','genSave',true);


%% calculation
cd(fileparts(pSave));
load('data.mat'); % load data

%% chi
chiResult = nan(size(A,1),2);
for x = 1:size(A,1)
    % Observed data
    
    A(x,:)./100
    return
    %%
    p1 = A(x,1)/100;
    p2 = A(x,2)/100;
    
    
    %%
    n1 = round(N1*p1);
    n2 = round(N2*p2);
    
    % Pooled estimate of proportion
    p0 = (n1+n2) / (N1+N2);
    
    return
    % Expected counts under H0 (null hypothesis)
    n10 = N1 * p0;
    n20 = N2 * p0;
    % Chi-square test, by hand
    observed = [n1 N1-n1 n2 N2-n2];
    expected = [n10 N1-n10 n20 N2-n20];
    chi2stat = sum((observed-expected).^2 ./ expected);
    p = 1 - chi2cdf(chi2stat,1);
    % store results
    chiResult(x,1) = chi2stat;
    chiResult(x,2) = p;

end
T = array2table(chiResult,'VariableNames',{'X','p'});
cd(pSave);

writetable(T,'chi_age.csv');

%%
% p0 = 0.0076
% chi2stat = 4.2419
% p = 0.0394

