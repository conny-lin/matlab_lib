function Stats_HabCurveRMANOVA(Data,MWTDB,pSave,varargin)
%%

msrlist = {'RevFreq','RevSpeed','RevDur'};

tpu = unique(Data.tap);
measNames = num2cellstr(tpu);
tpnames = strjoinrows([cellfunexpr(measNames,'tap'),measNames],'');

%% create input table
mwtidu = unique(Data.mwtid);
A = nan(numel(mwtidu)*numel(msrlist),numel(tpu));
Leg = cell(numel(mwtidu)*numel(msrlist),2);
row1 = 1;
for mwti = 1:numel(mwtidu)
    for msri = 1:numel(msrlist)
        d = table2array(Data(Data.mwtid==mwtidu(mwti),msrlist(msri)));
        col = table2array(Data(Data.mwtid==mwtidu(mwti),{'tap'}));
        A(row1,col) = d;
        Leg{row1,1} = msrlist{msri};
        Leg{row1,2} = mwtidu(mwti);
        row1 = row1+1;
    end
end


A = array2table(A,'VariableNames',tpnames);
Leg = cell2table(Leg,'VariableNames',{'msr','mwtid'});
Leg.groupname = MWTDB.groupname(Leg.mwtid);
Leg.strain = MWTDB.strain(Leg.mwtid);
Leg.dose = num2cellstr(parseGname_TestmM(Leg.groupname));
DataS = [Leg A];

%% create rmanova options
tptable = table(tpu,'VariableNames',{'tap'});
alpha = 0.05;
cd(pSave); 
close all;
fid = fopen('RMANOVA.txt','w');
for msri = 1:numel(msrlist)
    msr= msrlist{msri};
    if msri==1
        fprintf(fid,'\n----- %s -----\n',msr);
    else
        fprintf(fid,'\n\n----- %s -----\n',msr);
    end
    %%
    i = ismember(DataS.msr,msr);
    D = DataS(i,:);
    
    rm = fitrm(D,'tap1-tap30~strain*dose','WithinDesign',tptable);
    fprintf(fid,'RMANOVA:\n%s\n',anovan_textresult(ranova(rm)));
    rm = fitrm(D,'tap1-tap30~groupname','WithinDesign',tptable);
    t = multcompare(rm,'groupname');
%     t(t.pValue >= alpha,:) = [];
    if isempty(t)
        fprintf(fid,'\nPosthoc(Tukey) HabCurve by group:\nAll comparison = n.s.\n');
    else
        fprintf(fid,'\nPosthoc(Tukey) HabCurve by group:\n%s\n',multcompare_text2016b(t));
    end
    t = multcompare(rm,'groupname','By','tap');
    t(t.pValue >= alpha,:) = [];
    if isempty(t)
        fprintf(fid,'\nPosthoc(Tukey)tap by gname:\nAll comparison = n.s.\n');
    else
        fprintf(fid,'\nPosthoc(Tukey)tap by gname:\n%s\n',multcompare_text2016b(t));    
    end
end

fclose(fid);















