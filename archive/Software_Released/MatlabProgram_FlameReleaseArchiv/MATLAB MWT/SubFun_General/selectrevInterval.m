function [revInit,revTerm,ti,int,tf] = selectrevInterval
    %% input options
% revInit = 180:10:200; % startin from 180 second, for every 10 seconds, end at 200 seconds
% revTerm = 190:10:210; % first time end at 190 second, for every 10 seconds, last end at 210 seconds
% user input
choice = 'Conny User Input';
switch choice
    case 'Conny User Input'
        ti = input('Enter start time(s): ');
        if ti ==0;
            ti = 0.00001; % get rid of problem of zero initial time
        end
        int = input('Enter interval(s): ');
        tf = input('Enter end time(s): ');
        revInit = ti:int:tf-int;
        revTerm = ti+int:int:tf;  
    case 'Evan';
        revInit = 10:10:400; % startin from 180 second, for every 10 seconds, end at 200 seconds
        revTerm = 20:10:410; % first time end at 190 second, for every 10 seconds, last end at 210 seconds
end
end