function [varargout] = MWTpathMaster(option,pFun,varargin)


%% MWT Coding by Conny using Rose as pData Source
if strcmp(option,'MWTCodingRose') == 1
    pRose = '/Volumes/Rose';
    % if user path is connylinlin
    if isempty(strfind(userpath,'conny')) == 0
        pDoc = '/Users/connylinlin/Documents/Lab';
        pSave = [pDoc,'/Lab Project & Data/Lab Data Matlab'];
        pData = [pRose,'/MWT_Analysis_20131020'];
        % get analysis pack
        pFunA = [pFun,'/Dance_AnalysisPack'];
        AnalysisPackName = dircontent(pFunA);
        pJava = [pFun,'/ChoreJava'];
        A = [];
        A.pData = pData;
        A.pSave = pSave;
        A.pJava = pJava;
        A.pFun = pFun;
        A.pFunA = pFunA;
        A.AnalysisPackName = AnalysisPackName;
        varargout{1} = A;
    end
end




end


% 
% optionlist = {'Rose';'Coding'};
%     
% 
% %% STEP1: PROGRAM DEFAULT PATHS 
% switch coding
%     case 'Coding'
%         
% 
%     case 'Rose'
%         pProgram = '/Users/connylinlin/Documents/Programming/MATLAB/MATLAB MWT Projects/MWT009_DanceReview';
%     case 'Flame'
%         % add program path (Mac only)
%         pProgram = cd;
% end
% 
% % %% running in Flame
% % p = pProgram;
% % a = {}; % create cell array for output
% % a = dir(cd); % list content
% % a = {a.name}'; % extract folder names only
% % a(ismember(a,{'.','..','.DS_Store'})) = []; 
% % for x = 1:size(a,1); % for all files 
% %     p1 = [p,'/',a{x,1}]; % make path for files
% %     if isdir(p1) ==1; % if a path is a folder
% %         addpath(p1);
% %     end
% % end
% % % output
% % varargout{1} = pProgram;
% 
% 
% 
% 
% 
% %% OTHER PATHS
% % Get experiment home folders
% switch coding
%     case 'DataTest'
%         p = fileparts(pProgram);
%         pData = [p,'/DataTest'];
%         pSave = '/Users/connylinlin/Documents/Lab/Lab Project & Data/Lab Data Matlab';
%     case 'Rose'
%         pData = '/Volumes/Rose/MWT_Analysis_20131020';
%         pSave = '/Users/connylinlin/Documents/Lab/Lab Project & Data/Lab Data Matlab';
%     case 'Flame'
%         display ' ';
%         display 'Choose experiment home folder';
%         [fn,p] = dircontent(fileparts(p));
%         % get rid of .xxx folders
%         i = cellfun(@isempty,regexp(fn,'[.]|(AnalysisProgram)'));
%         fn = fn(i); p = p(i);
%         display(makedisplay(fn));
%         display ' ';
%         i = input('folder: ');
%         pData = p{i};
% 
%         % get save folder path
%         savefoldername = 'AnalysisResults';
%         pSave = [pData,'/',savefoldername ];
%         if exist(pSave,'dir') ~=7
%             mkdir(pData,savefoldername);
%             display 'made analysis folder';
%         end
% end
% 
% 
% 
% 
% 
% end