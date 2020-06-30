%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%
p = '/Users/connylin/Dropbox/RL Pub PhD Dissertation/Chapters/2-Wildtype/3-Results/Figures & Data/Fig2-1 Body Curve 60m 3 4 5 do/AssayAge/Stats_v3_selectTimes10min';
pd = fullfile(p,'curve rmANOVA.txt');

A = rmANOVAextractTxtOutputObj;
A.datapath =pd;
A.txt_t_identifier = 'Posthoc[(]Tukey[)]t by game';

%%
D = A.txtcontent;
txtsep = 'Posthoc[(]Tukey[)]t by game';
i = find(regexpcellout(D,txtsep));
fulltxt = D(i(2)+1:end);
b = regexpcellout(fulltxt,'(*)|(, )','split');
T = table;
T.tap = str2numcell(regexprep(b(:,1),'tap',''));
T.g1 = b(:,2);
T.g2 = b(:,3);
T.ptxt = b(:,4);
r = strjoinrows(b(:,1:3),'*');
T.Properties.RowNames = r;
T.pvalue = convertPvalueText2Num(T.ptxt);       
