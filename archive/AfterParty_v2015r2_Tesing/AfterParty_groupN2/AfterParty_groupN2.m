function AfterParty_groupN2

%% organize by strain
% {'KJ300_400mM_120h';'KJ300_400mM_5d'};
% BackStage_corrGroupName('N2_7d_c','N2_ER7d_c')



%% group N2
addpath('/Users/connylin/Dropbox/MATLAB/Function_Library_Public');
addpath('/Users/connylin/Dropbox/MATLAB/programs_rankinlab/Library/MWT Common Modules');

pH = '/Users/connylin/Dropbox/Dissimination/20150801 Manuscript Alcohol STH/Results/Data/Dance_ShaneSpark2 20150605182201 10sISI/AfterParty_IndividualPlates_v2015r1 20150605183314/N2';
p = pH;
[f,p] = dircontent(p);
a = regexprep(f,'.eps','');
a = regexpcellout(a,' ','split');
a = a(:,4);
aU = unique(a);


%% N2 groups
fg = {{'dose',{ 
'N2'
'N2_100mM'
'N2_200mM'
'N2_300mM'
'N2_400mM'
'N2_500mM'
'N2_600mM'
}};
{'pilot',{
'N2_Test'
'N2_pilot'
'N2_400mM_Pilot'
}};
{'exposure_time',{
'N2_400mM_ExpTime0min'
'N2_400mM_ExpTime30min'
'N2_400mM'
'N2_400mM_ExpTime60min'
'N2_400mM_ExpTime90min'
'N2_400mM_ExpTime120min'
}};
{'no food',{
'N2'
'N2_NoFood'
'N2_400mM'
'N2_400mM_NoFood'
}};
{'age',{
'N2_3d'
'N2_400mM_3d'
'N2'
'N2_400mM'
'N2_5d'
'N2_400mM_5d' 
}};
{'liquid_tsf',{
'N2_TsfPick'
'N2_TsfLiquid'
'N2_TsfLiquidM9'
'N2_TsfLiquidM9Maybe'
'N2_TsfLiquidTime30to90'
'N2_TsfLiquidTime120to180'
'N2_400mM_TsfPick'  
'N2_400mM_TsfLiquid'
}};
{'preexposure',{
'N2_400mM_PreExp3do400mM12h'
}};
{'larval_tapforce',{
'N2_ER4d_TapForceNormal'
'N2_ER4d_TapForce1Pi'
'N2_ER4d_TapForce3Pi'
'N2_ER3d_400mM_TapForceNormal'
'N2_ER3d_400mM_TapForce1Pi'
'N2_ER3d_400mM_TapForce3Pi'
}};
{'larval',{
'N2_a'
'N2_b'
'N2_ER2d_e'
'N2_ER3d_a'
'N2_ER3d_b'
'N2_ER3d_c'
'N2_ER3d_g'
'N2_ER4d'
'N2_ER4d_a'
'N2_ER4d_b'
'N2_ER4d_c'
'N2_ER4d_d'
'N2_ER4d_f'
'N2_ER4d_h'
'N2_ER4d_i'
'N2_ER5d_a'
'N2_ER5d_b'
'N2_ER5d_c'
'N2_ER5d_a'
'N2_ER5d_b'
'N2_ER5d_c'
'N2_ER6d_a'
'N2_ER6d_b'
'N2_ER6d_c'
'N2_ER7d_a'
'N2_ER7d_b'
'N2_ER7d_c'
}};
{'embryonic',{
'N2_EEUT'
'N2_EE0'
'N2_EE5'
'N2_EE10'
'N2_EE10_3d'
}};
 };  

%%
cd(pH);
for fgi = 1:size(fg,1)
    foldername = fg{fgi}{1};
    mkdir(foldername);
    gn = fg{fgi}{2};
    i = ismember(a,gn);
    source = f(i);
    dest = cellfunexpr(f(i),[pH,'/',foldername]);
    cellfun(@copyfile,source,dest);
end
%% delete all files
cellfun(@delete,p);

%% go into each folder and sort by type
[~,~,~,pf] = dircontent(pH);
cd(pH);

for pfi = 1:numel(pf)
p = pf{pfi};
[ff,pp] = dircontent(p);
a = regexprep(ff,'.eps','');
a = regexpcellout(a,' ','split');
type = a(:,3);
tU = unique(type);

for tUi = 1:numel(tU)
tnow = tU(tUi);
s = pp(ismember(type,tnow));
dh = [p,'/',char(tnow)];
mkdir(dh);
d = regexprep(s,p,dh);
cellfun(@movefile,s,d);
end
end


%%
% cd(pSave);
% for gui = 1:numel(gu)
%     gt = gu{gui};
%     i = ismember(a,gt);
%     mkdir(gt);
%     cellfun(@movefile,f(i),cellfunexpr(f(i),[pSave,'/',gt]));
% end
% dest = cellfunexpr(pf,pCorr);
% cellfun(@movefile,pf,dest,cellfunexpr(pf,'f'));
% if isempty(dircontent(p)) == 1; rmdir(p,'s'); end