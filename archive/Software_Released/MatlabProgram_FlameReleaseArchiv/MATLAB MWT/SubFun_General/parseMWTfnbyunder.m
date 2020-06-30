function [strain,seedcolony,colonygrowcond,runcond,trackergroup] = ...
    parseMWTfnbyunder(MWTruname)
[split] = regexp(MWTruname,'_','split');
% take out nameparts
strain = {};
seedcolony= {};
colonygrowcond= {};
runcond = {};
trackergroup  = {};
for x = 1:numel(split);
    strain = [strain;split{x}(1)];
    seedcolony = [seedcolony;split{x}(2)];
    colonygrowcond = [colonygrowcond;split{x}(3)];
    runcond = [runcond;split{x}(4)];
    trackergroup = [trackergroup;split{x}(5)];
end