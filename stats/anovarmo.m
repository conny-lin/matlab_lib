classdef anovarmo
   properties
       Data
       rmName
       factors
       dvname
       idname
       alpha = 0.05
       pvlimit = 0.001
       % move to dependent
   end
   properties (Dependent)
       factorname 
       factorpairs
       factorsvar
       rmlist
       rmvartable
       DatarmANOVA
       rmANOVA
       rmANOVAtxt
   end
   methods
       function factorname = get.factorname(obj)
            factorname = char(strjoin(obj.factors,'*'));
       end
       function rmlist = get.rmlist(obj)
            rmlist = unique(obj.Data.(obj.rmName));
       end
       function rmvartable = get.rmvartable(obj)
              rmvartable = array2table(obj.rmlist,'VariableNames',{obj.rmName});
       end
       function factorsvar = get.factorsvar(obj)
            if numel(obj.factors)>1
                d = obj.Data(:,obj.factors);
                factorsvar = strjoinrows(d,'*');
            else
                factorsvar = obj.Data.(obj.factors);
            end
       end
       function factorpairs = get.factorpairs(obj)
            g = unique(obj.factorsvar);
            gg = pairwisecomp_getpairs(g);
            factorpairs = strjoinrows(gg,' x ');
       end
       function DatarmANOVA = get.DatarmANOVA(obj)
           % get general data
           D = obj.Data;
           rn = obj.rmName;
           rl = obj.rmlist;
           
           % create rows
           var = [obj.factors {obj.idname}];
           IV = D(:,var);
           for i = 1:numel(var)
               if isnumeric(IV.(var{i}))
                  IV.(var{i}) = num2cellstr(IV.(var{i}));
               end
           end
           iv = strjoinrows(IV,'*');
           ivu = unique(iv); % get uniqiue dv pairs
           % break up ivu
           ivusep = regexpcellout(ivu,'*','split');
           IVT = cell2table(ivusep,'VariableNames',var);
           IVT.factors = ivu;
           % assign rows
           [~,rowi] = ismember(iv,ivu);
           
           % create output matrix
           O = nan(numel(ivu),numel(rl));
           ind = sub2ind(size(O),rowi,D.(rn));
           O(ind) = D.(obj.dvname);
           
           % create variable names
           a = repmat({rn},numel(rl),1);
           b = num2cellstr(rl);
           v = strjoinrows([a b],'_');
           OT = array2table(O,'VariableNames',v);
           
           DatarmANOVA = [IVT OT];

       end
       function rmANOVA = get.rmANOVA(obj)
            % rmanova multi-factor +++++++
            rmTerms = sprintf('%s%d-%s%d~%s',obj.rmName,obj.rmlist(1),obj.rmName,obj.rmlist(end),'factors')
            rmANOVA = fitrm(obj.DatarmANOVA,rmTerms,'WithinDesign',obj.rmvartable);
            % ----------------------------
       end
       function rmANOVAtxt = get.rmANOVAtxt(obj)
           t = anovan_textresult(ranova(obj.rmANOVA), 0, 'pvlimit',obj.pvlimit);
           rmANOVAtxt = sprintf('*** RMANOVA(%s:%s) ***\n%s\n',obj.rmName,obj.factorname,t);
       end
   end
   
end

% function textout = anovarmo(DataTable,rmName,factors,varargin)
% %% 

% 
%% create rmanova options =================================================
% 
%% transpose


%%

% =========================================================================


%% RMANOVA ================================================================
% decide which to run
% if multiStrain && multiDose; factorName = 'strain*dose';
% elseif multiStrain && ~multiDose; factorName = 'strain';
% elseif ~multiStrain && multiDose; factorName = 'dose';
% end
% textout = '';


% rmanova multi-factor +++++++

% ----------------------------
% 
% % rmanova pairwise by each factor ++++++++
% for i = 1:numel(factors)
%     compName = factors{i};
%     rmTerms = sprintf('%s%d-%s%d~%s',rmName,rmlist(1),rmName,rmlist(end),compName);
%     rmANOVA = fitrm(D,rmTerms,'WithinDesign',rmvartable);
%     t = multcompare(rmANOVA,compName);
%     % text output
%     textout = sprintf('%s\n*** Posthoc(Tukey) by %s ***:\n',textout,compName);
%     if isempty(t)
%         textout = sprintf('%s\nAll comparison = n.s.\n',textout);
%     else
%         t = multcompare_text2016b(t,'pvlimit',pvlimit,'alpha',alpha);
%         textout = sprintf('%s\n%s\n',textout,t);
%     end
% end
% % ----------------------------------
% 
% % comparison by taps +++++++++++
% t = multcompare(rmANOVA,compName,'By',rmName);
% %  keep only unique comparisons
% a = strjoinrows([t.([compName,'_1']) t.([compName,'_2'])],' x ');
% t(~ismember(a,factorpairs),:) =[]; 
% % record
%     textout = sprintf('%s\n\n*** Posthoc(Tukey)%s by %s ***\n',textout,rmName,compName); 
% if isempty(t)
%     textout = sprintf('%s\nAll comparison = n.s.\n',textout);
% else
%     t = multcompare_text2016b(t,'pvlimit',pvlimit,'alpha',alpha);
%     textout = sprintf('%s\n%s\n',textout,t);
% end
% % --------------------------------
% end
% =========================================================================



















