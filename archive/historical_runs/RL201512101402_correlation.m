%% setting
% pData = '/Volumes/COBOLT/MWT';
pD = '/Users/connylin/Dropbox/RL/PhD/Chapters/2-STH N2/Data/10sISI/1-All Exp/Dance_Glee_Showmance';
pSaveHome = [fileparts(pD),'/Dance_Glee_Showmance_Extension'];
cd(pD); load('Dance_Glee_Showmance.mat');
pSaveA = [pSaveHome,'/Stats Correlation'];
if isdir(pSaveA) == 0; mkdir(pSaveA); end
asrlist = {'Initial','HabLevel','HabRate_integral'};
msrx = 'RevFreq';
msry = 'RevSpeed';
msrz = 'RevDur';


%% create pairs
msrMatrix = {msrx msrx msry; msry msrz msrz};

%% create data
Db = MWTSet.Info.MWTDb;
DbIndex =  MWTSet.Info.VarIndex;
fid = fopen(sprintf('%s/Correlation by plates.txt',pSaveA),'w');

%% calculate
for ai = 1:numel(asrlist)
    asr = asrlist{ai};

    DH = MWTSet.Graph.(asr);
    % match mwtname
    [i,j] = ismember(DH.(msrx).Raw.mwtname, DH.(msry).Raw.mwtname);
    if sum(i) == numel(i) && issorted(j) ~= true
        error('mwtname do not match');
    end

    t = table;
    % get expname id
    [i,j] = ismember(Db.mwtname, DH.(msrx).Raw.mwtname);
    en = Db.expname(j(i));
    % get index to en
    [i,j] = ismember(en, DbIndex.expname);
    t.expname_id = j(i);
    t.expname = en;
    t.(msrx) = DH.(msrx).Raw.data;
    % get y
    t.(msry) = DH.(msry).Raw.data;
    t.(msrz) = DH.(msrz).Raw.data;
    cd(pSaveA); writetable(t,sprintf('%s.csv',asr));

    % correlation across plates
    for mi = 1:size(msrMatrix,2)
        msr1 = msrMatrix{1,mi};
        msr2 = msrMatrix{2,mi};
        X = [t.(msr1) t.(msr2)];
        [rho,pvalue] = corr(X);
        r = rho(1,2);
        p = pvalue(1,2);
        df = numel(X)-2;
        if p < 0.0001;
            fprintf('%s vs %s %s: r(%.0f) = %.2f, p < 0.0001\n',msr1,msr2,asr,df,r);
            fprintf(fid,'%s vs %s %s: r(%.0f) = %.2f, p < 0.0001\n',msr1,msr2,asr,df,r);
        else
            fprintf('%s vs %s %s: r(%.0f) = %.2f, p = %.4f\n',msr1,msr2,asr,df,r,p);
            fprintf(fid,'%s vs %s %s: r(%.0f) = %.2f, p = %.4f\n',msr1,msr2,asr,df,r,p);
        end
    end
end
fclose(fid);

 
%% is there by experiment variation, disregard of groups
%% correlation of initials per experiment, disregard groups, 

%%
% DH = MWTSet.Data.ByGroupPerPlate;

% grouplist = fieldnames(DH);
% for gi = 1:numel(grouplist)
%     gn = grouplist{gi};
%     D = DH.(gn);
%     msrlist = fieldnames(D);
%     msrlist(regexpcellout(msrlist,'^N|SE\>|MWTplateID|MWTind|time')) = [];
%     for mi = 1:numel(msrlist)
%         
%     end
%     return
%     msr1 = 'RevFreq';
%     msr2 = 'RevSpeed';
%     d1 = DH.(gn).([msr1,'_Mean'])(1,:);
%     d1 = DH.(gn).([msr2,'_Mean'])(1,:);
%     
% end









