function [Expfdat] = importsumdata2(pExp,ext,r,c)
%% Import data from pExp
%% [NEED USING IT] import .dat file 
% i.e. ext = '*.dat';
% import file
cd(pExp); % go to path
a = dir(ext); % list content
a = {a.name}'; % get just the name of the file
d = {};
for x = 1:size(a,1);
    d(x,1) = a(x,1); % name of file imported
    d{x,2} = dlmread(a{1},' ', r,c); % import 
end
Expfdat = d;
end