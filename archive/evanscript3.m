function [MWTfsprevsum,MWTfevandat,MWTfsprevs] = ProcesChorsprevs(ti,int,tf,pExp)
%% Instruction:
% Source: evanscript1
% Instruction from Evan Ardiel
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

%% get paths
[mwtfn,pMWT] = dircontentmwt(pExp);
%%
MWTfsprevs = {};
MWTfevandat = {};
% create legend
MWTfsprevsL = {1,'object ID'; 2,'time';3,'reversal'}

for p = 1 : numel(pMWT); % for each mwt
    cd(pMWT{p});
    [~,ps] = dircontentext(pMWT{p},'*.sprevs');
    dirData = dir('*.sprevs');
    % import all .sprevs data (each file is one individual
    sprevscompile = [];
    for k = 1:size(ps,1);
        a = dlmread(ps{k}); % import .sprevs data
        sprevscompile = [sprevscompile;a];
    end
    MWTfsprevs(p,1) = mwtfn(p);
    MWTfsprevs(p,2) = {sprevscompile};

    % import .dat
    datevanimport = dircontentext(pMWT{p},'*evan.dat');  
    MWTfevandat(p,1) = mwtfn(p);
    MWTfevandat(p,2) = {dlmread(datevanimport{1})};

end % end loop for MWT folder
%%
 timedat = storedDatData(:,1);
    maxtimedat = max(timedat);
    mintimedat = min(timedat);
    time = sprevscompile(:,2);
    maxtime = max(time);
    mintime = min(time);
    

    
%% legends
MWTsprevsumL = {[1],'MinN';[2],'MaxN';[3],'Total duration tracked';[4],'NRev';...
[5],'NwormRev';[6],'MeanRevDist';[7],'MeanRevDur';[8],'TimeRevTotal'}

 %% create summary
 MWTfsprevsum = {};
    for t = 1:size(revInit,2); % for each stim
        stimRevs = sprevscompile(:,2) > revInit(1,t) & sprevscompile(:,2) < revTerm(1,t);
        stimSum{t,1} = t;
        stimSum{t,2} = sprevscompile(stimRevs,:);
        RevTerms = [];
        RevTerms(:,1) = stimSum{t,2}(:,2) + stimSum{t,2}(:,4);
        overTime = RevTerms(:,1)>revTerm(1,t);
        RevTerms(overTime,1) = revTerm(1,t);
        RevTerms(:,2) = RevTerms(:,1)-stimSum{t,2}(:,2);
        validTimes = storedDatData(:,1) > revInit(1,t) & storedDatData(:,1) < revTerm(1,t);
        MWTfevandat(x,1) = {t};
        MWTfevandat{x,2} = storedDatData(validTimes,:); % store imported dat
        Datdatum = storedDatData(validTimes,:);
        wormTime = diff(Datdatum(:,1));
        wormTime(:,2) = wormTime(:,1).*Datdatum(2:end,3); 
        MWTfsprevsum{p,1} = mwtn{p};
        MWTfsprevsum{p,2}(t,1) = min(Datdatum(1:end,3));
        MWTfsprevsum{p,2}(t,2) = max(Datdatum(1:end,3));
        MWTfsprevsum{p,2}(t,3) = sum(wormTime(:,2));
        MWTfsprevsum{p,2}(t,4) = size(sprevscompile(stimRevs,2),1);
        MWTfsprevsum{p,2}(t,6) = mean(sprevscompile(stimRevs,3));
        MWTfsprevsum{p,2}(t,7) = mean(sprevscompile(stimRevs,4));
        MWTfsprevsum{p,2}(t,8) = sum(RevTerms(2:end,2));
    end
cd(pExp);
save('MWTfsprevs.mat','MWTfsprevsum','MWTfevandat','MWTfsprevs');


%% make revInt and revTerm
if ti ==0;
    ti = 0.00001; % get rid of problem of zero initial time
end
revInit = ti:int:tf-int;
revTerm = ti+int:int:tf;  

    

