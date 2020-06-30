function [pO] = createOutputFolder(pScript)
%% createOutputFolder:
% create output folder with the same name of the script 
% and generate path to output folder (pO)

[p,scriptName] = fileparts(pScript); % find script path
% pO: Output paths = current script folder

pO = [p,'/',scriptName]; % set output path
if isdir(pO) == 0; mkdir(pO); end % make output foler if none
