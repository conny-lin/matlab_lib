function MWTDatabase_checkMWTintegrity(MWTfiles)


%% get var
MWTfn = MWTfiles(:,1);
pMWT = MWTfiles(:,2);




%% CHECK INTEGRITY OF MWT FILES
[pMWTval,pMWTbad,MWTfnval,MWTfnbad] = validateMWTcontent(pMWT);

%%

for x = 1:numel(pMWT)
    
    
    
end
% %%
% display 'Validating MWT folder contents...';
% % check for number of .blob files > 0
% fname = '*.blobs';
% a = cellfun(@numel,(cellfun(@dircontentext,pMWT,...
%     cellfunexpr(pMWT,fname),'UniformOutput',0))) > 0; 
% %% check existance of .summary
% fname = '*.summary';
% b = cellfun(@numel,(cellfun(@dircontentext,pMWT,...
%     cellfunexpr(pMWT,fname),'UniformOutput',0))) > 0; 
% % check existance of .set
% fname = '*.set';
% c = cellfun(@numel,(cellfun(@dircontentext,pMWT,...
%     cellfunexpr(pMWT,fname),'UniformOutput',0))) > 0; 
% 
% % create output array
% val = false(size(pMWT));
% % get validated MWT paths
% val(a == true & b == true & c == true) = true;
% pMWTval = pMWT(val);
% % get invalid MWT paths
% pMWTbad = pMWT(~val);
% 
% % get validated MWT names
% [~,MWTfnval] = cellfun(@fileparts,pMWTval,'UniformOutput',0);
% % get invalid MWT names
% [~,MWTfnbad] = cellfun(@fileparts,pMWTbad,'UniformOutput',0);
% 
% % summary structural array
% S.pMWTval = pMWTval;
% S.MWTfnval = MWTfnval;
% S.pMWTbad = pMWTbad;
% S.MWTfnbad = MWTfnbad;





%%

MWTBadFiles = pMWTbad;

%% MARK BAD MWT FILES
if isempty(MWTBadFiles)==0;
    
    % get bad MWT paths
%     p = pMWT(r); % % find files with missing MWT files
%     MWTBadFiles = pMWT(r);
    % report
    mark = 'misschorinput';
    str = 'marking [%d] bad MWT files as %s';
    display(sprintf(str,numel(p),mark));
    [~,fnx] = cellfun(@fileparts,p,'UniformOutput',0);
    disp(fnx)
    
    % mark bad mwt folder
    % make new name
    pmwark = {};
    for x = 1:1%numel(p)
        pmark{x,1} = [p{x},'_',mark];
        [p1,fn1] = fileparts(p{x});
        markfn = [fn1,'_',mark];
        mkdir(p1,markfn); % make folder
%         isdir(pmark{x,1})
    end
    
    %% copy file
    for x = 1:numel(p)
        [~,p1] = dircontent(p{x});
       cellfun(@movefile,p1,cellfunexpr(p1,pmark{x,1}));
       rmdir(p{x})
    end
    
    % update path for chor
    pMWT = pMWT(~r); 
    [MWTfG] = reconstructMWTfG(pMWT);
end
