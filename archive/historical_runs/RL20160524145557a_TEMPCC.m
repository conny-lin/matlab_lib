
% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',false);


return

%%
str = regexp(anovan_textresult(StatOut.t28_30.ranova),'\n','split')';
% str = (str;

a = regexpcellout(str,'(*)|(,)','split');
i = regexpcellout(a(:,4),' p=n.s.');
a(i,:) = [];
tap = cellfun(@str2num,regexprep(a(:,1),'tap',''));
g1 = a(:,2);
g2 = a(:,3);
b = regexprep(a(:,4),' ','');
pvalue = cellfun(@str2num,regexprep(b,'(p)|(=)|(<)',''));

