function [varargout] = Dance_OptionInterpretation(OPTION)
%% STEP4: ANALYSIS OPTION INTERPRETATION
option = OPTION.Program;
% create option list [VERSION UPDATES]
OptID = {'ShaneSpark';'AnnaPavlova';'LadyGaGa';'DrunkPosture';'SwanLake'}; 
% options do not require time input
OptNoTime = {'ShaneSpark';'AnnaPavlova'}; 

% OPTION SELECTION 
i = celltakeout(regexp(OptID,option),'logical'); % match option with OptID
if sum(i)~=1; % if option input on on the optoin list
    % display instruction and choose from OptID list
    display 'option entered not found';
    display 'please select from the following list:';
    [show] = makedisplay(OptID,'bracket'); disp(show);
    display 'Enter analysis number,press [ENTER] to abort';
    a = input(': ');
    if isempty(a) ==1; return; else option = OptID{a}; end
end
varargout{1} = option;