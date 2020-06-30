
function [Expfdat] = importungroupedExpraw(ext,pExp)
%% Import sum.dat, MWTf .dat and .trv from ungrouped data
[Expfdat] = importsumdata2(pExp,ext,5,1); % import Exp summary data
if isempty(Expfdat)==1; % status reporting
    display('no summary data...');
else
    display('summary data imported...');
end