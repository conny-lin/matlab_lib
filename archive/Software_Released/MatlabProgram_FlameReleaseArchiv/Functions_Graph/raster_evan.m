
%% Evan's instruction 
% To make the raster plots I analyze individual runs in Choreography using this command:
% 
% java -jar '/home/crankin/Desktop/Chore_1.3.0.r1035.jar' -p 0.027 -s 0.1 -t 20 -M 2 --shadowless -S -N all -o nNss*b12 --plugin Reoutline::exp --plugin Respine 
% 
% Then I put each of the analyzed folders into one grand folder for the group. If there's only one run to be plotted, the analyzed folder still needs to be in a grand folder. The grand folder should be the current directory when you run the attached matlab command. In the command there a few places where you'll need to add info about your run:
% 
% timeInit = 335;  %%this is when in the experiment you want the plot to start (in seconds)
% timeFinal = 349.9; %%this is when in the experiment you want the plot to stop (in seconds)
% 
% lightDur = [340 342]; %%this is for adding a blue bar to represent the stimulus - in this case a 2s light pulse that initiated 340s into the exp't
% 
% NOTE: 1) Worms will only be plotted if they exist for the entire duration between timeInit and timeFinal. 2) All worms in the grand folder are plotted together with no distinction of plate. 3) This program is really slow!
% 
% %%


%% USER DEFINED VARIABLES
timeInit = 335;
timeFinal = 349.9;
lightDur = [340 342];



folderlist = dir(pwd);

counting = 0;
n = 20;

%% GRAPHING
hold on;
area(lightDur, [400 400],'FaceColor',[0.6784 0.9216 1],...
 'EdgeColor','none');


for z = 1 : numel(folderlist)
    if folderlist(z).isdir && ~any(strcmp(folderlist(z).name, {'.' '..'}))
        counting=counting+1;
        group(counting).name = folderlist(z).name;
        parentfolder = folderlist(z).name;
        cd(parentfolder);

        dirData = dir('*.dat');

        a=1;

        for i =1:size(dirData,1);
            storedData1 = dlmread(dirData(i).name);
            if min(storedData1(:,1)) < timeInit && max(storedData1(:,1))>timeFinal && max(storedData1(:,2)) ==1;
                validDats(a,1) = i;
                a = a+1;
            end
        end



        for i=1:size(validDats,1);
            n = n+1;
            storedData2 = dlmread(dirData(validDats(i,1)).name);
            storedData2(1,6) = 1;
            storedData2(end-1,6) = -1;
            storedData2(end,6) = 1;
            condition1 = storedData2(:,6) == -1;
            storedData2(condition1,6) = 4;
            condition2 = storedData2(:,6) == 0;
            storedData2(condition2,6) = 1;
            condition3 = isnan(storedData2(:,6));
            storedData2(condition3,6) = 1;
            dstoredData2 = diff(storedData2);
            dstoredData2 = [1 1 1 1 1 1 1 1;dstoredData2];
            condition4 = dstoredData2(:,6) == 3;
            condition5 = dstoredData2(:,6) == -3;
            revStart = find(condition4);
            revStop = find(condition5);

            for j = 1:size(revStart)
                revTimes(j,1) = storedData2(revStart(j,1),1);
                revTimes(j,2) = storedData2(revStop(j,1),1);
            end

            y = [n n];

            %% GRAPH
            hold on;
            for k = 1:size(revTimes);
                plot(revTimes(k,1:2),y,'k');axis([timeInit timeFinal 0 400]);axis off;
            end
            
            clearvars revStart revStop revTimes storedData2 dstoredData2;
            clear condition1 condition2 condition3 condition4 condition5;

        end

        clear dirData
        clear validDats;

        cd ('..');



    end


end

