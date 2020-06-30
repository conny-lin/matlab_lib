classdef anovarmObj
   properties
       gfactors
       groupnames
       gf
       rmfactors
       rmf_name
       rmfu
   end
   methods
       function groupnames = get.groupnames(obj)
          T = obj.gfactors;
          msrlist = T.Properties.VariableNames;
          A = cell(size(T));
          for msri = 1:numel(msrlist)
              msr = msrlist{msri};
              a = T.(msri);
              b = cellfunexpr(a,msr);
              c = strjoinrows([b a],'');
              A(:,msri) = c;
          end
          groupnames = strjoinrows(A,'_');
       end
       function rmf_name = get.rmf_name(obj)
           T = obj.rmfactors;
           rmf_name = T.Properties.VariableNames;
           if numel(rmf_name) ~=1
               error('too many rmfactors');
           end
           rmf_name = char(rmf_name);
       end
       function rmfu = get.rmfu(obj)
           T = obj.rmfactors;
           r = obj.rmf_name;
           a = unique(T.(r));
           T1 = table;
           T1.(r) = a;
           rmfu = T1; 
       end
       function gf = get.gf(obj)
          gf = obj.gfactors.Properties.VariableNames;
       end
       function textout = rmanova_all(
            % rmanova multi-factor +++++++
            rmTerms = sprintf('%s%d-%s%d ~%s',rmName,tpu(t1),rmName,tpu(t2),factorName);
            rm = fitrm(D,rmTerms,'WithinDesign',tptable);
            t = anovan_textresult(ranova(rm), 0, 'pvlimit',pvlimit);
            textout = sprintf('%s\nRMANOVA(%s:%s):\n%s\n',textout,rmName,factorName,t);
            % ----------------------------

       end
       
   end
    
end



























