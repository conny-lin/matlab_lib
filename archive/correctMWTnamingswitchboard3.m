function [MWTfsn] = correctMWTnamingswitchboard3(pExp)
display('Running correctMWTnamingswitchboard3...');
%% get names
[MWTfsn,MWTfail] = draftMWTfname3('*set',pExp);

%% Auto corrections
display('Validate name underscore structure');
[MWTfsn] = validateMWTnamestructure(MWTfsn,pExp);

%% detect duplicated names

displayoldgroupcode(pExp); % look at Groups mat
[MWTfsn] = correctduplicatename(MWTfsn,pExp);

%% manually correct name
[MWTfsn] = correctMWTfnmanual(MWTfsn,pExp);


%% [DEVELOPING...] 
t = 0; % turn off this part for now
switch t
    case 0
    case 1
        displayoldgroupcode(pExp); % show old group code to gi to give an idea
        % strain name incorrect, correct it automatically
        % validate name parts
        [MWTfsncorr] = validateMWTfnameparts(MWTfsn);
        %% manually change names part by part (16 parts)
        correctMWTnamebyparts(MWTfsn,pExp);
end
end
