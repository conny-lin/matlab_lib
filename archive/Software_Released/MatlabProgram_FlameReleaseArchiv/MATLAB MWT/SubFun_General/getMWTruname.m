function [MWTfsn,MWTsum] = getMWTruname(pMWTf,MWTfn)
% get names of MWT run name
display 'Importing MWT run names...';
MWTfsn = {};
for x = 1:numel(pMWTf); % for each MWTf
    [fn,~] = dircontentext(pMWTf{x,1},'*.set');
    if isempty(fn) == 1; % if no 
        str = 'No .set, use all extensions';
        [fn,~,~,~] = dircontent(pMWTf{x,1});
        a = regexp(fn,'[.]','split'); % take out extension
        if isempty(fn) ==1;
            str = 'MWT folder is empty [%s]';
            display(sprintf(str,MWTfn{x}));
            MWTsum = {};
            MWTfsn = {};
            return
        else
            MWTfsn{x,1} = a{1}{1}; % record name of file imported without extention name         

        end
        
    else
        MWTfsn{x,1} = fn{1}(1:end-4); % record name of file imported without extention name         

    end

end

% reporting and contruct master list
display(sprintf('>> %d [%d unique] MWT run names found',numel(MWTfsn),...
    numel(unique(MWTfsn))));
MWTsum = [pMWTf MWTfn MWTfsn];% construct master list