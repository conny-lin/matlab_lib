function [diarysavename] = diarysavename(pExp)
diary off;
[diarysavename] = creatematsavenamewdate('MatlabDiary_','');
cd(pExp);
diary(diarysavename);
diary on;
end