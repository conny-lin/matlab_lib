function [diarysavename] = diaryNpaths(pFun,pExp)
diary off;
[diarysavename] = creatematsavenamewdate('MatlabDiary_','');
cd(pExp);
diary(diarysavename);
diary on;
end