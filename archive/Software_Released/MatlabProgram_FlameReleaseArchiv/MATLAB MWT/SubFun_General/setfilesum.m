% set file summary
%% STEP1: PATHS [Need flexibility] 
clearvars -except option
pMaestro = '/Volumes/AWLIGHT/MWT/Archived Analysis/Maestro';
pRose = '/Volumes/Rose/MultiWormTrackerPortal/MWT_Analysis_20130811';
pFun = '/Users/connylinlin/MatLabTest/MultiWormTrackerPortal/MWT_Programs';
pSet = '/Users/connylinlin/MatLabTest/MultiWormTrackerPortal/MWT_Programs/MatSetfiles';
pSum = '/Volumes/Rose/MultiWormTrackerPortal/Summary';
pSave = '/Volumes/Rose/MultiWormTrackerPortal/SummaryAnalysis';
addpath(genpath(pFun));
HomePath = pRose;
O = []; % [CODE] Define output O % temperary assign O = nothing

%% STEP2: CHOOSE OPTOIN
option1 = input('Refresh all summary [REFRESH] or only sum new MWT [NEW]?\n: ','s'); 

%% STEP3: GET MWT
[A] = MWTDataBaseMaster(HomePath,'FindAllMWT');
pMWTfD = A.pMWTfnR; MWTfnD = A.MWTfnR;
%% STEP4: FIND MWT WITHOUT SUM FILE
[a,~] = dircontentext(pSum,'*.mfi');
record = celltakeout(regexp(a,'^(\d{8})[_](\d{6})','match'),'singlerow');
MWTfnNoRecord = setdiff(MWTfnD,record);
str = '[%d] MWTf does not have record files';
display(sprintf(str,numel(MWTfnNoRecord)));
option = 'noshow';
switch option
    case 'noshow'
    case 'show'
        display 'MWTf below does not have record files'; 
        disp(MWTfnNoRecord); 
end
%% STEP5: GET EXP INFO FROM .SET
display 'Making MWT info summary, this will take a while...';  
switch option1;
    case 'NEW';  
        for x = 1:numel(MWTfnNoRecord)
            m = celltakeout(regexp(MWTfnD,MWTfnNoRecord{x}),'logical');
            pMWT = pMWTfD{m}; [~,MWTfn] = fileparts(pMWT);
            [fn,p] = dircontentext(pMWT,'*.set');
            
            % if there is no .set file
            if isempty(p)==1; 
                str = 'MWTf[%s] has no *.set file'; 
                display(sprintf(str,MWTfn));
                expcond = [MWTfn,'[NoSetFile]'];
                expathO = '';   
            
            % if there is .set file
            elseif iscell(p)==1 && numel(p)==1; pset = char(p); 
                
                % interpret .set file
                a = fileread(pset); b = regexp(a,'(FALSE)|(TRUE)','split')';
                
                % get original expath and MWTruname
                c = regexp(b{1},'\s','split')';
                % if path name is NOT found in .set file
                if isempty(c{end})==0 && isempty(c{end-1})==1;
                    display 'problems!';
                    expcond = [MWTfn,'[ProblemSetFile]']; expathO = ''; 
                
                    % if path name is found in .set file
                elseif isempty(c{end})==1 && isempty(c{end-1})==0;
                    MWTrunameO = c{end-1}; 
                    d = regexp(b{1},MWTrunameO,'split');
                    expathO = d{1}; d = regexp(expathO,'\','split');
                    expid1 = d{end-1}; 
                    expid2 = char(regexprep(d{end},'\s',''));
                    
                    % get original run condition
                    c = celltakeout(regexp(b(5),'\s','split')','split');
                    d = c(not(cellfun(@isempty,c)));
                    totalduration = str2num(d{end});
                    c = celltakeout(regexp(b(6),'\s','split')','split');
                    d = c(not(cellfun(@isempty,c)));
                    preplate = str2num(d{1}); ISI = str2num(d{2});
                    tapN = str2num(d{3}); tapVar = str2num(d{4});
                    aftertap = totalduration-((ISI*tapN)+preplate); 
                    
                    % make file name
                    expcond = [MWTfn,'[',num2str(totalduration),'s(',num2str(preplate),...
                    's',num2str(tapN),'x',num2str(ISI),'s',num2str(aftertap),'s)]',...
                    MWTrunameO,'[',expid1,'.',expid2,']'];
                end
                
 
            end
            %  save file
            savename = [expcond,'.mfi'];
            cd(pSum); fid = fopen(savename, 'w');
            fprintf(fid, '%s %d %d %d\n', expathO); fclose(fid); 
            
            % reporting
            option = 'noshow';
            switch option
                case 'noshow'
                case 'show'
                    display ' ';
                    str = 'Save name: %s'; a = sprintf(str,savename); disp(a);
                    str = 'original experiment path: %s'; a = sprintf(str,expathO); disp(a);
                    str = 'original MWT run name: %s'; a = sprintf(str,MWTrunameO); disp(a);
                    str = 'Total exp duration: %d(s)'; a = sprintf(str,totalduration); disp(a);
                    str = 'preplate: %d(s)'; a = sprintf(str,preplate); disp(a);
                    str = 'ISI: %d(s)'; a = sprintf(str,ISI); disp(a);
                    str = 'tap: %d'; a = sprintf(str,tapN); disp(a);
                    str = 'variable tap: %d'; a = sprintf(str,tapVar); disp(a);
            end
        end
        %%
    case 'REFRESH'; MWTfnWanted = MWTfnD;
        for m = 1:numel(pMWTfD)
            pMWT = pMWTfD{m};
            [fn,p] = dircontentext(pMWT,'*.set');
            if iscell(p)==1 && numel(p)==1; pset = char(p); 
            elseif isempty(p)==1; str = 'MWTf[%s]has no *.set file'; 
                display(sprintf(str,MWTfnD{m})); continue; 
            end
            a = fileread(pset); b = regexp(a,'(FALSE)|(TRUE)','split')';

            % get original expath and MWTruname
            c = regexp(b{1},'\s','split')';
            if isempty(c{end})==1; MWTrunameO = c{end-1}; 
            else display 'problems!'; return; end
            d = regexp(b{1},MWTrunameO,'split');
            expathO = d{1}; d = regexp(expathO,'\','split');
            expid1 = d{end-1}; expid2 = char(regexprep(d{end},'\s',''));

            % get original run condition
            c = celltakeout(regexp(b(5),'\s','split')','split');
            d = c(not(cellfun(@isempty,c)));
            totalduration = str2num(d{end});
            c = celltakeout(regexp(b(6),'\s','split')','split');
            d = c(not(cellfun(@isempty,c)));
            preplate = str2num(d{1}); ISI = str2num(d{2});
            tapN = str2num(d{3}); tapVar = str2num(d{4});

            % save file
            cd(pSum); aftertap = totalduration-((ISI*tapN)+preplate);
            [~,MWTfn] = fileparts(pMWT);
            expcond = [MWTfn,'[',num2str(totalduration),'s(',num2str(preplate),...
                's',num2str(tapN),'x',num2str(ISI),'s',num2str(aftertap),'s)]',...
                MWTrunameO,'[',expid1,'.',expid2,']'];
            savename = [expcond,'.mfi'];
            fid = fopen(savename, 'w');
            fprintf(fid, '%s %d %d %d\n', expathO); fclose(fid); 

            % reporting
            option = 'noshow';
            switch option
                case 'noshow'
                case 'show'
                display ' ';
                str = 'Save name: %s'; a = sprintf(str,savename); disp(a);
                str = 'original experiment path: %s'; a = sprintf(str,expathO); disp(a);
                str = 'original MWT run name: %s'; a = sprintf(str,MWTrunameO); disp(a);
                str = 'Total exp duration: %d(s)'; a = sprintf(str,totalduration); disp(a);
                str = 'preplate: %d(s)'; a = sprintf(str,preplate); disp(a);
                str = 'ISI: %d(s)'; a = sprintf(str,ISI); disp(a);
                str = 'tap: %d'; a = sprintf(str,tapN); disp(a);
                str = 'variable tap: %d'; a = sprintf(str,tapVar); disp(a);
            end
        end
end
