function [sout,StatsTable] = anovan_std(Y,G,gvarnames,pSave,varargin)

%% default
posthocname = 'tukey-kramer';
pv = 0.05;
suffix = '';
prefix ='';
export = {'textsave'};
ext = 'txt';
%%
vararginProcessor;
if isempty(suffix)==false
   suffix = [' ',suffix]; 
end
sout = '';

%% anovan
[~,t,~,~] = anovan(Y,G,'varnames',gvarnames,'model','full','display','off');
[anovatxt,T] = anovan_textresult(t);



%% find pair wise comparison statistics
G1 = cell(numel(G{1}),numel(G));
for x = 1:numel(G)
    G1(:,x) = G{x};
end
G1 = strjoinrows(G1);
[~,~,stats] = anova1(Y,G1,'off');
[c,~,~,gnames] = multcompare(stats,'ctype',posthocname,'display','off','alpha',pv);
% note: for 2016a, c(:,6) = pvalue, dsiabled old code
multcomptext = multcompare_text2016b(c,'grpnames',gnames);
% [~,r,TC,~] = multcompare_pairinterpretation(c,gnames,'nsshow',1,'pvalue',pv);

%% get estat
g = stats.gnames;
% i = regexpcellout(g,'N2');
% [find(i);find(~i)]
% [~,ind] = output_sortN2first(g);
StatsTable = grpstatsTable(Y,G1);
StatsTable = output_sortN2first(StatsTable,'tblcolname','gnameu');
eStatext.gname = strjoinrows(StatsTable.gnameu',', ');
eStatext.n = strjoinrows(num2cellstr(StatsTable.n'),', ');
eStatext.mean = strjoinrows(num2cellstr(StatsTable.mean'),', ');
eStatext.se = strjoinrows(num2cellstr(StatsTable.se'),', ');

%% export
if any(ismember(export,{'text','textsave'}))
    factorname = char(strjoinrows(gvarnames,' x ')); % create factorname
    % estat
    dsstr = sprintf('*** Descriptive Stats ***\n');
    f = fieldnames(eStatext);
    for fi = 1:numel(f)
        fn = f{fi};
        s = char(eStatext.(fn));
        dsstr = sprintf('%s%s = %s\n',dsstr,fn,s);
    end
    % manova
    sanova = sprintf('*** Multifactorial ANOVA, %s (%s) %s ***\n',prefix,factorname, suffix);
    for x = 1:numel(anovatxt)
        sanova = sprintf('%s%s\n',sanova,anovatxt{x}); 
    end
    % posthoc
    sposthoc = sprintf('*** Posthoc %s ***\n%s',posthocname,multcomptext);
    % construct 
    sout = sprintf('%s\n%s\n%s',dsstr,sanova,sposthoc);
end
if any(ismember(export,{'textsave'}))
    % export anovan text output
    fid = fopen(sprintf('%s/%sMANOVA%s.%s',pSave,prefix,suffix,ext),'w');
    fprintf(fid,'%s',sout);
    fclose(fid);
end

% if strcmp(export,'all') % export ANOVAN table
%     writetable(T,sprintf('%s/%s MANOVA%s.csv',pSave,prefix,suffix));
% end
% if strcmp(export,'all') % write table
%     savename = sprintf('%s/%s posthoc %s%s.csv',pSave,prefix,posthocname,suffix);
%     writetable(TC,savename,'Delimiter',',');
% end



