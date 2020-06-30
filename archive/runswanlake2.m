pData = '/Volumes/BlackPearl/MWT_Data';
pJava = '/Users/AngularGyrus/OneDrive/MATLAB/Projects_RankinLab/MWT_Dance/ChoreJava';
pFunD = '/Users/AngularGyrus/OneDrive/MATLAB/Functions_Developer';
addpath(pFunD);
%%
[chorscript] = chorjavasyntax_swanlake(pJava);
script_swanlake2all = chorscript{1};
script_swanlake2 = chorscript{2};

%%
[~,~,Expf,pExp] = dircontent(pData);
for e = 1:numel(pExp)
    display ' ';
    display(sprintf('processing experiment: %s',Expf{e}))
   [~,~,Gf,pG] = dircontent(pExp{e});
   
   i = ~ismember(Gf,'MatlabAnalysis');
   Gf = Gf(i);
   pG = pG(i);
   display('found group folders: ');
   disp(Gf);
   for g = 1:numel(pG)
       [~,~,MWTf,pMWT] = dircontent(pG{g});
       display(sprintf('%d MWT folder in group folder [%s]',numel(MWTf),Gf{g}));
       if isempty(pMWT) == 1
           break
       else
           
           disp(MWTf);

           for m = 1:numel(pMWT)
               display(sprintf('processing MWT [%s]',MWTf{m}));

%                [~,p] = dircontent(pMWT{m},'*.swanlake2all.*');      
%                if isempty(p) == 1
%                     file = strcat('''',pMWT{m},''''); 
%                     system([script_swanlake2all file], '-echo'); 
%                else
%                    display('swanlake2all found');
%                end  

%                [~,p] = dircontent(pMWT{m},'*swanlake2.dat');      
%                if isempty(p) == 1
                    file = strcat('''',pMWT{m},''''); 
                    system([script_swanlake2all file], '-echo'); 
%                else
%                    display('swanlake2 found');
%                end 

           end
       end
   end
    
end


