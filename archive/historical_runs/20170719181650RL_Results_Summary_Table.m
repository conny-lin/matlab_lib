%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% paths
pDataBase = '/Volumes/COBOLT/MWT';
pData = fullfile(fileparts(pM),'Data');

%% GET STRAIN INFO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170719%
% get group names
[fn,p] = dircontent(pData);
% minus archive code folder
p(regexpcellout(fn,'[_]')) = [];
% get gene names
[fn,p] = cellfun(@dircontent,p,'UniformOutput',0);
p = celltakeout(p);
% get strain names
[fn,p] = cellfun(@dircontent,p,'UniformOutput',0);
pstrains = celltakeout(p);
strainnames = celltakeout(fn);
% get gene name
p = cellfun(@fileparts,pstrains,'UniformOutput',0);
[p,genenames] = cellfun(@fileparts,p,'UniformOutput',0);
% get groupname
[p,groupnames] = cellfun(@fileparts,p,'UniformOutput',0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170719%


%% MAKE INFO TABLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170719%
T = table;
T.group = groupnames;
T.gene = genenames;
T.strain = strainnames;
colnames = {'curve_wt_sig','curve_mut_ko','curve_mut_reduced','rev_N','rev_wt_sig','rev_mut_ko','acc_wt_sig','acc_mut_ko'};
for ci = 1:numel(colnames)
    cn = colnames{ci}; % get column name
    % treatment by colname
    switch cn
        case 'rev_wt_sig' 
            A = cell(numel(strainnames),1);
            for si = 1:numel(strainnames)
                dancename = 'Dance_ShaneSpark4';
                pdata = fullfile(pstrains{si},'TWR',dancename,'RMANOVA.txt');
                if ~exist(pdata,'file')
                    dancename = 'Dance_ShaneSpark5';
                    pdata = fullfile(pstrains{si},dancename,'RMANOVA.txt');
                    if ~exist(pdata,'file')
                        error('missing file');
                    end
                end
                if exist(pdata,'file')   
                    fid = fopen(pdata,'r');
                    D = textscan(fid, '%s%[^\n\r]', 'Delimiter', '',  'ReturnOnError', false);
                    fclose(fid);
                    D = [D{1:end-1}];
                    % find stats
                    a = D(regexpcellout(D,'^N2(*)N2_400mM, p'));
                    pvalues = regexpcellout(a,'(?<=^N2(*)N2_400mM, )p(<|=).+','match');
                    % find measure name
                    a = D(regexpcellout(D,'(?<=(-{5}.Rev))\w+'));
                    msrs = regexpcellout(a,'(?<=(-{5}.Rev))\w+','match');
                    i = ismember(msrs,'Freq'); 
                    % get stats matching measure name
                    p = pvalues(i);
                    % if p is n.s.
                    if strcmp(p,'p=n.s.')
                        A{si} = 'no'; % mark not ok
                    else
                        % if p is significant
                        % mark ok
                        A{si} = 'yes';
                    end
                end
            end
            
        case 'rev_N' % reversal plate number
            % set up output array
            A = cell(numel(strainnames),1);
            for si = 1:numel(strainnames)
                % get files
                dancename = 'Dance_ShaneSpark4';
                pdata = fullfile(pstrains{si},'TWR',dancename,'Dance_ShaneSpark4.mat');
                if ~exist(pdata,'file')
                    dancename = 'Dance_ShaneSpark5';
                    pdata = fullfile(pstrains{si},dancename,'Dance_ShaneSpark5.mat');
                    if ~exist(pdata,'file')
                        error('missing file');
                    end
                end
                D = load(pdata);
                D = D.MWTSet.MWTDB.groupname;
                % tabulate
                D = tabulate(D);
                % sort N2 first
                D = sortN2first(D(:,1),D(:,2));
                % get number
                a = cellfun(@num2str,D,'UniformOutput',0)';
                % transform into text strin
                a = strjoin(a',', ');
                % put in output array
                A{si} = a;
            end
            
        case 'rev_mut_ko' % effect of mutant, if not sig that means ko
            % set up output array
            A = cell(numel(strainnames),1);
            for si = 1:numel(strainnames)
                dancename = 'Dance_ShaneSpark4';
                pdata = fullfile(pstrains{si},'TWR',dancename,'RMANOVA.txt');
                if ~exist(pdata,'file')
                    dancename = 'Dance_ShaneSpark5';
                    pdata = fullfile(pstrains{si},dancename,'RMANOVA.txt');
                    if ~exist(pdata,'file')
                        error('missing file');
                    end
                end
                if exist(pdata,'file')   
                    fid = fopen(pdata,'r');
                    D = textscan(fid, '%s%[^\n\r]', 'Delimiter', '',  'ReturnOnError', false);
                    fclose(fid);
                    D = [D{1:end-1}];
                    % find stats
                    s = strainnames{si};
                    s = regexprep(s,' New','');
                    str = sprintf('^%s[*]%s_400mM, p',s,s);
                    a = D(regexpcellout(D,str));
                    str = sprintf('(?<=^%s[*]%s_400mM, )p(<|=).+',s,s);
                    pvalues = regexpcellout(a,str,'match');
                    % find measure name
                    a = D(regexpcellout(D,'(?<=(-{5}.Rev))\w+'));
                    msrs = regexpcellout(a,'(?<=(-{5}.Rev))\w+','match');
                    i = ismember(msrs,'Freq'); 
                    % get stats matching measure name
                    p = pvalues(i);
                    if strcmp(p,'p=n.s.')   % if p is n.s.
                        A{si} = 'yes'; % mark ko
                    else % if p is significant
                        A{si} = 'no'; % mark no ko
                    end
                end
            end
            
        case 'acc_wt_sig' % effect of mutant, if not sig that means ko
            % set up output array
            A = cell(numel(strainnames),1);
            for si = 1:numel(strainnames)
                dancename = 'Dance_rType';
                pdata = fullfile(pstrains{si},'TAR',dancename,'AccProb RMANOVA.txt');
                if ~exist(pdata,'file')
                    dancename = 'Dance_rType2';
                    pdata = fullfile(pstrains{si},dancename,'AccProb RMANOVA.txt');
                    if ~exist(pdata,'file')
                        error('missing file');
                    end
                end
                if exist(pdata,'file')   
                    fid = fopen(pdata,'r');
                    D = textscan(fid, '%s%[^\n\r]', 'Delimiter', '',  'ReturnOnError', false);
                    fclose(fid);
                    D = [D{1:end-1}];
                    % find stats
                    s = 'N2';
                    str = sprintf('^%s[*]%s_400mM, p',s,s);
                    a = D(regexpcellout(D,str));
                    str = sprintf('(?<=^%s[*]%s_400mM, )p(<|=).+',s,s);
                    pvalues = regexpcellout(a,str,'match');
                    p = pvalues;
                    % if p is n.s.
                    if strcmp(p,'p=n.s.')
                        A{si} = 'no'; % mark not ok
                    else
                        % if p is significant
                        % mark ok
                        A{si} = 'yes';
                    end
                end
            end

        case 'acc_mut_ko' % effect of mutant, if not sig that means ko
            % set up output array
            A = cell(numel(strainnames),1);
            for si = 1:numel(strainnames)
                dancename = 'Dance_rType';
                pdata = fullfile(pstrains{si},'TAR',dancename,'AccProb RMANOVA.txt');
                if ~exist(pdata,'file')
                    dancename = 'Dance_rType2';
                    pdata = fullfile(pstrains{si},dancename,'AccProb RMANOVA.txt');
                    if ~exist(pdata,'file')
                        error('missing file');
                    end
                end
                if exist(pdata,'file')   
                    fid = fopen(pdata,'r');
                    D = textscan(fid, '%s%[^\n\r]', 'Delimiter', '',  'ReturnOnError', false);
                    fclose(fid);
                    D = [D{1:end-1}];
                    % find stats
                    s = strainnames{si};
                    s = regexprep(s,' New','');
                    str = sprintf('^%s[*]%s_400mM, p',s,s);
                    a = D(regexpcellout(D,str));
                    str = sprintf('(?<=^%s[*]%s_400mM, )p(<|=).+',s,s);
                    pvalues = regexpcellout(a,str,'match');
                    p = pvalues;
                    if strcmp(p,'p=n.s.') % if p is n.s.
                        A{si} = 'yes'; % marked ko
                    else % if p is significant
                        A{si} = 'no'; % mark not ko
                    end
                end
            end

        case 'curve_wt_sig' % effect of mutant, if not sig that means ko
            % set up output array
            A = cell(numel(strainnames),1);
            for si = 1:numel(strainnames)
                s = strainnames{si};
                s = regexprep(s,' New','');
                pdata = fullfile(pstrains{si},sprintf('%s stats writeup.txt',s));
                if ~exist(pdata,'file')
                   error('no file');
                end
               
                if exist(pdata,'file')   
                    fid = fopen(pdata,'r');
                    D = textscan(fid, '%s%[^\n\r]', 'Delimiter', '',  'ReturnOnError', false);
                    fclose(fid);
                    D = [D{1:end-1}];
                    r = D{1}; % first paragraph = body curve
                    % find stats
                    a = regexp(r,',','split')';
                    a = regexprep(a,' ','');
                    a = regexpcellout(a,'^p((=)|(<))0[.]\d+','match');
                    a(cellfun(@isempty,a)) = [];
                    p = a{1}; % the first p value is wildtype
                    % if p is n.s.
                    if strcmp(p,'p=n.s.')
                        A{si} = 'no'; % mark not ok
                    else
                        % if p is significant
                        % mark ok
                        A{si} = 'yes';
                    end
                end
            end

        case 'curve_mut_ko' % effect of mutant, if not sig that means ko
            % set up output array
            A = cell(numel(strainnames),1);
            for si = 1:numel(strainnames)
                s = strainnames{si};
                s = regexprep(s,' New','');
                pdata = fullfile(pstrains{si},sprintf('%s stats writeup.txt',s));
                if ~exist(pdata,'file')
                   error('no file');
                end
                if exist(pdata,'file')   
                    fid = fopen(pdata,'r');
                    D = textscan(fid, '%s%[^\n\r]', 'Delimiter', '',  'ReturnOnError', false);
                    fclose(fid);
                    D = [D{1:end-1}];
                    r = D{1}; % first paragraph = body curve
                    % find stats
                    a = regexp(r,',','split')';
                    a = regexprep(a,' ','');
                    a = regexpcellout(a,'^p((=)|(<))0[.]\d+','match');
                    a(cellfun(@isempty,a)) = [];
                    p = a{2}; % the 2nd p value is mutant
                    if strcmp(p,'p=n.s.') % if p is n.s.
                        A{si} = 'yes'; % mark ko
                    else % if p is significant
                        A{si} = 'no'; % mark not ko
                    end
                end
            end

        case 'curve_mut_reduced' % effect of mutant, if not sig that means ko
            % set up output array
            A = cell(numel(strainnames),1);
            for si = 1:numel(strainnames)
                s = strainnames{si};
                s = regexprep(s,' New','');
                pdata = fullfile(pstrains{si},sprintf('%s stats writeup.txt',s));
                if ~exist(pdata,'file')
                   error('no file');
                end
                if exist(pdata,'file')   
                    fid = fopen(pdata,'r');
                    D = textscan(fid, '%s%[^\n\r]', 'Delimiter', '',  'ReturnOnError', false);
                    fclose(fid);
                    D = [D{1:end-1}];
                    r = D{1}; % first paragraph = body curve
                    % find stats
                    a = regexp(r,',','split')';
                    a = regexprep(a,' ','');
                    a = a(regexpcellout(a,'^p'));
                    a = regexprep(a,'([)][.]$)|([)])','');
                    p = a{3}; % the 3rd p value is comparison 
                    if strcmp(p,'p=n.s.') % if p is n.s.
                        A{si} = 'no';
                    else % if p is significant
                        A{si} = 'yes'; 
                    end
                end
            end
  
    end
    T.(cn) = A;
end

%% qualifier
Q = T(:,{'curve_mut_reduced','rev_mut_ko','acc_mut_ko'});
A = table2cell(Q);
Q.type = cell(size(Q,1),1);

i = regexpcellout(Q.curve_mut_reduced,'yes') & regexpcellout(Q.rev_mut_ko,'yes') & regexpcellout(Q.acc_mut_ko,'yes');
Q.type(i) = {'all'};
i = regexpcellout(Q.curve_mut_reduced,'yes') & regexpcellout(Q.rev_mut_ko,'no') & regexpcellout(Q.acc_mut_ko,'yes');
Q.type(i) = {'curve & acc'};
i = regexpcellout(Q.curve_mut_reduced,'yes') & regexpcellout(Q.rev_mut_ko,'no') & regexpcellout(Q.acc_mut_ko,'no');
Q.type(i) = {'curve'};
i = regexpcellout(Q.curve_mut_reduced,'yes') & regexpcellout(Q.rev_mut_ko,'yes') & regexpcellout(Q.acc_mut_ko,'no');
Q.type(i) = {'curve & rev'};
i = regexpcellout(Q.curve_mut_reduced,'no') & regexpcellout(Q.rev_mut_ko,'yes') & regexpcellout(Q.acc_mut_ko,'no');
Q.type(i) = {'rev'};
i = regexpcellout(Q.curve_mut_reduced,'no') & regexpcellout(Q.rev_mut_ko,'no') & regexpcellout(Q.acc_mut_ko,'no');
Q.type(i) = {'none'};
i = regexpcellout(Q.curve_mut_reduced,'no') & regexpcellout(Q.rev_mut_ko,'yes') & regexpcellout(Q.acc_mut_ko,'yes');
Q.type(i) = {'rev & acc'};

%%
T.type = Q.type;
%% write summary table
writetable(T,fullfile(pM,'Result summary.csv'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20170719%









