%% INITIALIZING
clc; clear; close all;
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'FB','genSave',true);
% addpath(pM);




%% SETTING
pUserdata = '/Users/connylin/Dropbox/fb/Publication/20160317 Poster SAS Emotion App analysis/Results/1-Data preparation/LSData_Emotion.mat';
pFBTD = '/Users/connylin/Dropbox/FB/Database/Emotion_20160224/Matlab';
pLegend = '/Users/connylin/Dropbox/Code/Matlab/Library FB/Modules/2-Extraction Cleaning Annotation';

%% LOAD EMOTION USER DATA
U = load(pUserdata);
% get FBT userid
lsu = U.LS_ScoreInfo.user_id(~isnan(U.LS_ScoreInfo.user_id));
u = U.Userinfo.fb(ismember(U.Userinfo.ls,lsu));
% add FBT userinfo to LS userinfo
U.LS_ScoreInfo.fbuser_id = U.Userinfo.fb;

%% LOAD EMOTION QUESTION ANSWERS TEXT
% get reference data
cd(pLegend);
ref = load('legend_LS_questions_shortrev.mat');
revqid = find(~cellfun(@isempty,ref.Qshort_rev.rev_q));
qtextrev = ref.Qshort_rev.short_q;
qtextrev(revqid) = ref.Qshort_rev.rev_q(revqid);
mc = load('ind_LS_q_MC.mat');
mcqind = find(mc.Index_MultipleChoiceQuestions);
answers = load('legend_LS_answers.mat');
mcans = answers.Legend_Answers(mcqind,:);
mcans(:,sum(cellfun(@isempty,mcans))==size(mcans,1)) = [];
mcans = mcans';
mcans = mcans(1:end-1,:);
mcans(cellfun(@isempty,mcans)) = {''};
mcans = cell2table(mcans);
% create mc q
a = qtextrev(mcqind);
i = cell2mat(regexp(a,' ','once'));
mcqtxt = cell(size(a));
for ai = 1:numel(i)
    mcqtxt{ai}= a{ai}(1:i(ai)-1);
end

%% repeating games
gamelist = 35:38;
for gameseq =1:numel(gamelist)
    gameIDT = gamelist(gameseq); % get game id

    %% LOAD DATA: EMOTION
    D = load(pFBTD); Data = D.EQscore; clear D; 
    Data(isnan(Data.game_id),:) = [];
    dv = {'score','accuracy','RT','N','played_at_utc'};
    [Data,gu,iv,dv] = FBTscore_getIVDV(Data,'dv',dv,'gameid',gameIDT,'keepIV',true); 
    % exclusion criteria -------------------------------------
    % game 35 exclusion criteria: exclude RT=60|0
    Data((Data.RT==60 | Data.RT==0) & Data.game_id==35,:) = [];
    % game 36 exclusion criteria: none
    % game 37 exclusion criteria: exclude RT>=5|0
    Data((Data.RT>=5 | Data.RT==0) & Data.game_id==37,:) = [];
    % game 38 exclusion criteria: none
    % ----------------------------------------------------------
    % keep only score from LS users
    Data(~ismember(Data.user_id,U.LS_ScoreInfo.fbuser_id),:) = [];
    % keep only first game
    D = [Data.user_id Data.played_at_utc Data.id];
    D = sortrows(D,[1 2]);
    [iStart,iFinish,playN,userid] = find_userboundry(D(:,1));
    scoreid = D(iStart,3);
    Data = Data(ismember(Data.id,scoreid),:);
return

    %% construct LS scores vs emotion score matrix
    % change user id to FBT userid
    A = U.LS_score;
    [i,j] = ismember(A.user_id,U.Userinfo.ls);
    A.user_id(i) = U.Userinfo.fb(j(i));

    %% combine with 
    B = outerjoin(A,Data,'Leftkey',{'user_id'},'RightKey',{'user_id'},'MergeKeys',1);
    % correct variable names
    fn = B.Properties.VariableNames;
    B.Properties.VariableNames(ismember(B.Properties.VariableNames,'id')) = {'fb_score_id'};
    B.Properties.VariableNames(ismember(B.Properties.VariableNames,'played_at_utc')) = {'fb_playtime'};
    B.Properties.VariableNames(ismember(B.Properties.VariableNames,'score_id')) = {'ls_score_id'};
    B(isnan(B.score) |isnan(B.qid),:) = [];

    %% how many yes/ no
    dv = {'score','accuracy','RT'};
    iv = {'qid','ansid'};
    pair = unique(B(:,iv),'rows');
    N = nan(size(pair,1),1);
    for ri = 1:size(pair,1)
       i = B.qid==pair.qid(ri) & B.ansid==pair.ansid(ri);
       N(ri) = sum(i);
    end
    icol = pair.ansid+1;
    irow = pair.qid;
    A = nan(numel(unique(pair.qid)),numel(unique(pair.ansid)));
    A(sub2ind(size(A),irow,icol)) = N;
    A(isnan(A)) = 0;
    cd(pSave); dlmwrite(['LS N',num2str(gameIDT),'.csv'],A);

    %% calculate mean
    dv = {'score','accuracy','RT'};
    iv = {'qid','ansid'};
    pair = unique(B(:,iv),'rows');
    M = nan(size(pair,1),numel(dv));
    for ri = 1:size(pair,1)
       i = B.qid==pair.qid(ri) & B.ansid==pair.ansid(ri);
       D = B(i,dv);
       s = statsBasic(table2array(D),'outputtype','table');
      M(ri,:) = s.mean';
    end

    M = array2table(M,'VariableName',dv);
    M = [pair M];
    
        
    %% export initial dv with reversed answer and calculated %
    % calcualte
    dv = {'score','accuracy','RT'};
    icol = M.ansid+1;
    irow = M.qid;
    % construct Q&A sheet for yes/no
    T = table;
    T.question = qtextrev;
    MC = cell(1,numel(dv));
    for dvi = 1:numel(dv);
        % get answers
        A = nan(numel(unique(M.qid)),numel(unique(M.ansid)));
        A(sub2ind(size(A),irow,icol)) = M.(dv{dvi}); 
        A(isnan(A)) = 0;
        % reverse answers to switch to positive predictor sentences
        a = A(revqid,1);
        b = A(revqid,2);
        A(revqid,1:2) = [b a];
        % calcualte % change of yes from no
        d = (A(:,1)-A(:,2))./A(:,2);
        % store in table
        T.(dv{dvi}) = d;

        %% cal MC q
        mcdata = A(mcqind,:)';
        % calcualte all diff from first row
        a = repmat(mcdata(1,:),size(mcdata,1),1);
        mcdata = (mcdata-a)./a;
        % store mc
        MC{dvi} = mcdata;
    end
    % export yes/no
    DF = T;
    T(mcqind,:) = []; % remove mc
    savename = ['G',num2str(gameIDT),' positive predictor.csv'];
    cd(pSave); writetable(T,savename);
    
    %% export mc
    MCT = table;
    for mi = 1:size(mcans,2)
        MCT.(mcqtxt{mi}) = table2cell(mcans(:,mi));
        for dvi = 1:numel(MC)
            MCT.([dv{dvi},num2str(mi)]) = MC{dvi}(:,mi);
        end
    end
    savename = ['G',num2str(gameIDT),' MC.csv'];
    cd(pSave); writetable(MCT,savename);
    
    
    
    
    %% calculate effect size for yes/no
    dv = {'score','accuracy','RT'};
    iv = {'qid','ansid'};
    pair = unique(B(:,iv),'rows');
    qidu = unique(pair.qid);
    E = table;
    for dvi = 1:numel(dv);
        E.([dv{dvi},'_es']) = cell(size(qidu));
        for qi = 1:numel(qidu)
           a = pair.ansid(pair.qid==qidu(qi),:);
           comppair = pairwisecomp_getpairs(a);
           if ismember(qi,revqid) % flip comparison if is reversed
              comppair = flip(comppair);
           end
           A = nan(size(comppair,1),1);
           for ci =1:size(comppair,1)
               x1 = B.(dv{dvi})(B.qid==qidu(qi) & B.ansid==comppair(ci,1));
               x2 = B.(dv{dvi})(B.qid==qidu(qi) &B.ansid==comppair(ci,2));
               d = effectsize_cohend(x1,x2);
               A(ci) = d;
           end
           E.([dv{dvi},'_es']){qi} = A;
        end 
    end
    % export mc effect size
    f = E.Properties.VariableNames;

    DFMC = DF(mcqind,:); 
    EMC = E(mcqind,:);
    n = numel(cell2mat(table2array(EMC(:,1))));
    T = cell(n,3);
    D = nan(n,numel(dv));
    r1 = 1;
    for qi = 1:numel(mcqind)
        a = pair.ansid(pair.qid==mcqind(qi),:);
        comppair = pairwisecomp_getpairs(a);
        a = table2cell(mcans(comppair(:,1)+1,qi));
        b = table2cell(mcans(comppair(:,2)+1,qi));
        r2 = r1+numel(a)-1;
        T(r1:r2,1) = qtextrev(mcqind(qi));
        T(r1:r2,2:3) = [a b];
        for dvi = 1:size(EMC,2)
            D(r1:r2,dvi) = EMC.([dv{dvi},'_es']){qi};
        end
        r1 = r2+1;
    end
    
    
    % save

    T = cell2table(T,'VariableNames',{'q','a1','a2'});
    for dvi = 1:numel(dv)
        T.(f{dvi}) = D(:,dvi);
    end
    savename = ['G',num2str(gameIDT),' MC effect size.csv'];
    cd(pSave); writetable(T,savename);
    

    % export yes/no
    DF(mcqind,:)  = [];
    E(mcqind,:) = [];
    E = array2table(cell2mat(table2array(E)),'VariableNames',f);
    T = [DF E];
    savename = ['G',num2str(gameIDT),' positive predictor ES.csv'];
    cd(pSave); writetable(T,savename);
    

    

end





%% FINISH
fprintf('\nDONE\n');
return














