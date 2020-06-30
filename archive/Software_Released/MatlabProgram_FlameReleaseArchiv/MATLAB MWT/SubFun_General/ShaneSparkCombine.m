% Analysis_CombineExp
% set up program path
clear;
input('is Analysis program under your current folder? Y=1,N=0: ');
if ans==1;
    Path.Program=cd;
else
    Path.Program=input('\nCopy and Paste the Path to matlab programs\n', 's');
end 

% Prepare folders for matlab output
Path.Data=input('cut and paste the home folder path: ','s');
cd(Path.Data);
Path.Save=strcat(Path.Data,'/MatLabAnalysis_Combined');
mkdir('MatLabAnalysis_Combined');


% create variables
VD.LabelY = {'Dist' 'Freq' 'DistStd' 'FreqStd'};    % label dependent variables
% label of independent variables
VI.LabelX = {'ISI' 'Group' 'Plate' 'Tap'};
VI.LabelY = {'size' 'data type'};
VI.Property = [];
VI.Property(1,1) = input('enter ISI (i.e. 10 or 60): ');
VI.Property(1,3) = 0;
VI.Property(1,4) = input('enter number of stim: ');
recoverytap = input ('enter the number of recovery taps: ');
a = input('Confirm? 1=yes, 0=no: ');


% Get folder names
cd(Path.Data);
list=dir;
a=1;
group={' '};
b={'MatLabAnalysis_Combined'};
c={'.'};
d={'..'};
for a=1:size(list,1);
    if list(a).isdir==1;
        if strcmp(list(a).name,b)==1;
        elseif strcmp(list(a).name,c)==1
        elseif strcmp(list(a).name,d)==1
        else
            group(1,end+1)={list(a).name};
        end
    else
    end
end
group=group(2:end);


% check experiment folders
a=num2cell(1:size(group,2));
group=cat(1,group,a);
display(group');
input('enter (1) if the above folders are correct, (0) if not: ');
while ans==0;
    fname=input('which one is not a exp folder? ');
    group=cat(2,group(1,1:fname-1),group(1,fname+1:end));
    a=num2cell(1:size(group,2));
    group=cat(1,group,a);
    group'
    input('is the above exp folders correct? Y=1 N=0: ');
end

% save folder info as variable
VI.Folders=group(1,:);


% create path to .mat data, import data and variables
n=size(group,2);
VI.Property(1,5)=n;
a= 'Mat%d';
VI.GroupByFolder={};
exp=1;
for exp=1:n;
    b=char(VI.Folders(1,exp));
    c=sprintf(b,exp);
    fname=sprintf(a,exp);
    % set up path to exp folder
    Path.(fname)=strcat(Path.Data,'/',c);
    cd(strcat(Path.(fname),'/MatLabAnalysis'));
    Temp=load('matlab.mat','Import', 'VI');
    Process.(fname)=Temp;
    % get group names for each folder (some might not have all the groups)
    clearvars s;
    s(1:size(Process.(fname).VI.Group,2))=exp;
    s=num2cell(s);
    g=Process.(fname).VI.Group(1,:);
    s=cat(1,g,s);
    VI.GroupByFolder=cat(2,VI.GroupByFolder,s);
end



% identify groups to combine 
VI.Group = unique(VI.GroupByFolder(1,:)); % find unique groups from all experiments

% check desired group to combine
a=num2cell(1:size(VI.Group,2));
group=cat(1,VI.Group,a);
display(group');
input('enter (1) if the above group are correct, (0) if not: ');
while ans==0;
    fname=input('which one is not desired group to analyze? ');
    group=cat(2,group(1,1:fname-1),group(1,fname+1:end));
    a=num2cell(1:size(group,2));
    group=cat(1,group,a);
    group'
    input('is the above exp groups correct? Y=1 N=0: ');
end
%% sort groups (under construction)

VI.Group = group(1,:); % code new groups into VI.Group


%% Combine data
a = 'Mat%d'; % set exp path name variable 
VI.Property(1,2)=size(VI.Group,2);
% repeat for all groups 
g = 1; % reset group# index
for g=1:size(VI.Group,2); % add loop
    gn = char(VI.Group(1,g)); % get group name as character array

    % repeat for all measure types 
    m = 1;% reset measure index 
    for m = 1:size(VD.LabelY,2);% add loop
        mn = char(VD.LabelY(1,m)); % get measure name
        dn = char(strcat(mn,gn)); % get data name as character array
    
        % repeat for all experiments
        f = 1; % reset experiment index
        Import.(dn) = []; % reset  output structure array
        for f=1:VI.Property(1,5); % loop for all exp 
            fn = sprintf(a,f); % set current exp path name

            % find whether an exp contains the desired group
            h = Process.(fn).VI.Group(1,:); % convert to cell array with only string
            h = h'; 
            y = strmatch(gn,h,'exact'); % search if exp contains specified group
            q = y>0;  % determine if exp contains specified group
            if q ==1;  % if exp contains the specified group
                % proceed with data combining   
                i = []; % reset i
                i = Process.(fn).Import.(dn);    
                Import.(dn) = cat(2,Import.(dn),i); % combine data with previous data
            else %otherwise skip to next exp  
            end

        end
    end
    
    VI.Plate(1,g)=size(Import.(dn),2); % code plate number for this group
end
display('combine complete'); % check combining progress


% Run Descriptive Statistics
cd(Path.Program);
Analysis_DescriptiveStats;
display('descriptive stats completed'); % check descriptive analysis progress

% Prepare Curve data and SPSS input data
cd(Path.Program);
Analysis_ANOVArm;
display('curve & SPSS output completed'); % check SPSS analysis progress

%Graphing
cd(Path.Program);
Analysis_Subplot;

% Save .mat data and clean up
clearvars -except Import Path Stats VD VI Transpose Graph
cd(Path.Save);
save;
cd(Path.Program);
clearvars -except Path;
cd(Path.Data);
delete combined*; % delete Beethoven graphs
cd(Path.Program);
display('analysis completed');







