%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170721%
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pSaveM = setup_std(mfilename('fullpath'),'RL','genSave',false);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170721%

%% MAKE INFO TABLE: REV %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170725%
T = table;
T.group = groupnames;
T.gene = genenames;
T.strain = strainnames;
colnames = {'resp_area_N','rev_wt_area_ttest','rev_mut_area_ttest','rev_mtmut_anova'};
% make empty table
for ci = 1:numel(colnames)
    cn = colnames{ci};
    if ismember(cn,{'resp_area_N'})
        T.(cn) = cell(numel(strainnames),1);
    else
        T.(cn) = nan(numel(strainnames),1);
    end
end

% enter information
for si = 1:numel(strainnames)
    pdata = fullfile(pstrains{si},'TWR_Area','TWR.mat');
    if ~exist(pdata,'file'); error('missing file'); end                
        % load data
        load(pdata);
        % treatment by colname
        for ci = 1:numel(colnames)
            cn = colnames{ci}; % get column name
            switch cn
                case 'resp_area_N'
                    % get relevant number
                    n = MWTSet.area_pctctrl.RevFreq.descriptive.n;
                    % get group name
                    g = MWTSet.area_pctctrl.RevFreq.descriptive.group;
                    % sort
                    n = sortN2first(g,n);
                    % get stats matching measure name
                    n = strjoin(n',', ');
                    % put in table
                    T.(cn){si} = p;
                case 'rev_wt_area_ttest'
                    % get relevant number
                    pvalue = MWTSet.area_pctctrl.RevFreq.ttest_against0.N2_400mM.p;
                    % get stats matching measure name
                    p = pvalues(i);
                    % put in table
                    T.(cn)(si) = p;
                case 'rev_mut_area_ttest'
                    % get strain field name
                    a = strainname{si};
                    a = regexprep(a,' New','');
                    a = sprintf('%s_400mM',a);
                    % get relevant number
                    pvalue = MWTSet.area_pctctrl.RevFreq.ttest_against0.(a).p;
                    % get stats matching measure name
                    p = pvalues(i);
                    % put in table
                    T.(cn)(si) = p;
            end
        end
end


colnames = {'resp_N',...
                'rev_wt_area_ttest','rev_mut_area_ttest','rev_wt_sig','rev_mut_ko',...
                'acc_wt_sig','acc_mut_ko'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170725%
