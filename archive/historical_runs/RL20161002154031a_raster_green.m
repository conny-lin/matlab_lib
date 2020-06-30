%% INFORMATION
% adapted from Raster_New_RL201602092252.m

%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true);
addpath(pM);


%% create colour map %%%%
Blue = [0 0 1];
Cyan = [0 1 1];
White = [1 1 1];
Yellow = [1 1 0];
Red = [1 0 0];
Dblue = [0 0 0.5];
Dred = [0.5 0 0];
step1 = 20;
step2 = 60;
Grad2 = [linspace(Blue(1),Cyan(1),step1+step2);linspace(Blue(2),Cyan(2),step1+step2);linspace(Blue(3),Cyan(3),step1+step2)];
Grad3 = [linspace(Yellow(1),Red(1),step2);linspace(Yellow(2),Red(2),step2);linspace(Yellow(3),Red(3),step2)];
Grad4 = [linspace(Red(1),Dred(1),step1);linspace(Red(2),Dred(2),step1);linspace(Red(3),Dred(3),step1)];
colourmap =[Grad2'; White; Grad3'; Grad4'];
%%%% create colour map end %%%%



%%
Data = DataG(2).speedb;
time = DataG(2).time(1,:);
%% define max color gradient
% define max min
gradmax = 0.6;
gradmin = -0.8;
% check max min 3SD speed
d = reshape(Data,numel(Data),1);
f = d(d > 0);
speed_max = mean(f) + 3*std(f);
if speed_max > gradmax; warning('forward+3SD speed > %.1f',gradmax); end
r = d(d < 0);
speed_min = mean(r) - 3*std(r);
if speed_min < gradmin; warning('reverse-3SD speed < %.1f',gradmin); end

% figure1 = rasterPlot_colorSpeed_gradient(Data,time,1);
%% convert speed 2 color based on gradmax
Speedcolor = nan(size(Data));

i = Data > 0;
F = Data./gradmax;
Speedcolor(i) = F(i);

i = Data < 0;
R = Data./-gradmin;
Speedcolor(i) = R(i);

i = Data == 0;
Speedcolor(i) = 0;

Speedcolor(Speedcolor > 1) = 1;
Speedcolor(Speedcolor < -1) = -1;
%%

figure1 = rasterPlot_colorSpeed_gradient(Data,time,1);

%%
figure1 = figure;
colormap(figure1,colourmap);
imagesc(Speedcolor)





























