function [Cond, variable] = createind4cond(pSave)
variable = char('[1]Dose','[2]Food','[3]Duration','[4]Age');
% 1- define alcohol dose
Cond{1,2} = {'Dose'};
Cond{1,4} = 1; % define control group code
Cond{1,3}(:,2) = {'0mM';'400mM';'100mM';'200mM';'300mM';'500mM';'600mM'};
% 2- define food
Cond{2,2} = {'Food'};
Cond{2,4} = 1; % define control group code
Cond{2,3}(:,2) = {'OnFood';'OffFood'};
% exposure duration
Cond{3,2} = {'Duration'};
Cond{3,4} = 4; % define control group code
Cond{3,3}(:,2) = {'0min';'30min'; '15min';'45min';'60min';'90min';'120min'};
% age
Cond{4,2} = {'Age'};
Cond{4,4} = 5; % define control group code
Cond{4,3}(:,2) = {'1d';'4d'; '2d';'3d';'3.5d';'4.5d';'5d';'6d';'7d'};

%% create index and display
% creare index for level 2
for x = 1:size(Cond,1); % for every level 1 variable
    Cond{x,3}(:,1) = num2cell(1:size(Cond{x,3},1))'; 
end
Cond(:,1) = num2cell((1:size(Cond,1))'); % create index for level 1

% create display for groups (display as Cond{y,5}
for x = 1:size(Cond,1);  
    z=[];
    for y = 1:size(Cond{x,3},1);
        i2 = strcat(num2str(Cond{x,3}{y,1}),'-',Cond{x,3}{y,2});
        z = strvcat(z,i2);
    end
     Cond{x,5}{1} = z;
end
cd(pSave); 
clearvars -except Cond variable;
save('variables.mat');
end