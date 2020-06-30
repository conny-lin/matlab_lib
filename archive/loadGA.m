function [GA,MWTfgcode] = loadGA(pExp)
cd(pExp);
fn = dir('Groups*.mat'); % get filename for Group identifier
fn = fn.name; % get group file name
load(fn); % load group files
end