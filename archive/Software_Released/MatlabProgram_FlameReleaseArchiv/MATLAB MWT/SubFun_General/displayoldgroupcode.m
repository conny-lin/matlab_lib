function displayoldgroupcode(pExp)
cd(pExp);
fn = dir('Groups*.mat'); % get filename for Group identifier
if isempty(fn)==1;
    return
end
fn = fn.name; % get group file name
load(fn); % load group files
display('This is the old group names')
disp(Groups(:,1:2));
end