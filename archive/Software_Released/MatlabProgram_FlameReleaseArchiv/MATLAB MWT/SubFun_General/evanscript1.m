function evanscript1(revInit,revTerm,pExp)
%% Evan Ardiel
% Instruction:
% This will give you a .txt file for every object listing each reversal 
% for that object. The following matlab script will combine your plates
% for 1 condition and give a .sprev file for whatever intervals you 
% specify in the %input options section. In the script below you'd get the 
% spontaneous reversals from 180-190s, 190-200s, 200-210s, but this could 
% be adjusted however you needed. For example, for spontaneous reversals 
% for the first three minutes, it'd be

% revInit = 0:60:120;
% revTerm = 60:60:180;
% 
% The .sprev files contain summarized info about the spontaneous reversals 
% for each interval. This script works, but it's not very elegant so I'll be 
%     embarrassed if you show it to your programming boyfriend! I can explain
%     more about the output in person if you want it.


%%%%%%%%
% input options
%revInit = 180:10:200;
%revTerm = 190:10:210;
%


for t = 1:size(revInit,2);
%Motherfoldercontents = dir(pwd);
[~,parentfolder] = dircontentmwt(pExp);


%counting counts the group folders
counting = 0;
Togetherness= zeros(1,5);

%Loops through folders
%for z = 1 : numel(Motherfoldercontents)
for z = 1 : numel(parentfolder)
    %if Motherfoldercontents(z).isdir && ~any(strcmp(Motherfoldercontents(z).name, {'.' '..'}))
        counting=counting+1;
        %group(counting).name = Motherfoldercontents(z).name;
        %parentfolder = Motherfoldercontents(z).name;
        cd(parentfolder{z});
        
        reversals = zeros(1,4);
        dirData = dir('*.sprevs');

        for k = 1:size(dirData,1);
            storedData = dlmread(dirData(k).name);
            stimRevs = storedData(:,2) > revInit(1,t) & storedData(:,2) < revTerm(1,t);
            datum = storedData(stimRevs,:);
            reversals = [reversals; datum];
        end

    RevTerms(:,1)=reversals(:,2)+reversals(:,4);
    overTime = RevTerms(:,1)>revTerm(1,t);
    RevTerms(overTime,1) = revTerm(1,t);
    RevTerms(:,2) = RevTerms(:,1)-reversals(:,2);

    dirDatData = dircontentext(cd,'*evan.dat');
    storedDatData = dlmread(dirDatData{1});
    validTimes = storedDatData(:,1) > revInit(1,t) & storedDatData(:,1) < revTerm(1,t);
    Datdatum = storedDatData(validTimes,:);
    wormTime = diff(Datdatum(:,1));
    wormTime(:,2)=wormTime(:,1).*Datdatum(2:end,3);


    Summary(counting,1) = min(Datdatum(1:end,3));
    Summary(counting,2) = max(Datdatum(1:end,3));
    Summary(counting,3) = sum(wormTime(:,2));
    Summary(counting,4) = size(reversals(2:end,2),1);
    Summary(counting,5) = size(unique(reversals(2:end,1)),1);
    Summary(counting,6) = mean(reversals(2:end,3));
    Summary(counting,7) = mean(reversals(2:end,4));
    Summary(counting,8) = sum(RevTerms(2:end,2));

    cd ('..');
    clearvars -except Summary pExp revInit revTerm parentfolder counting z t

    %end
%currentDirectory = pwd;
%[upperPath, deepestFolder] = fileparts(currentDirectory);
[~,deepestFolder] = fileparts(pExp);
% if revInit(1,t)<0.1;
%     revInitO=revInit;
%     revInitO(1,t)=0;
% else
%     revInitO= revInit;
% end
stimNum = num2str(revInit(1,t));

underscore = '_';

saveProg = ['save ' deepestFolder underscore stimNum '.sprevs Summary /ascii'];

eval(saveProg);

end




clearvars -except revInit revTerm parentfolder pExp counting

end
%clear all

