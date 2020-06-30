function [varargout] = MWTAdminMaster_DataStructure(pData)



%% get data structure
% look at database
    [A] = MWTDataBaseMaster(pData,'GetStdMWTDataBase');
    Expfn = A.ExpfnD;
    pExp = A.pExpfD;

    %% get run condition
    a = celltakeout(regexp(A.ExpfnD,'_','split'),'split');
    RC = a(:,3); 
    RCU = unique(RC);
    
    Summary = unique(RC);
    D = {}; S = {};
    for x = 1:size(Summary,1)
        i = ismember(RC,Summary{x});
        Summary{x,2} = Expfn(i);
        ExpfnT = Expfn(i);
        Summary{x,3} = pExp(i);
        pExpT = pExp(i);
        % get group folder
        e = {};
        for y = 1:size(Summary{x,2},1)
            [~,~,f,pf] = dircontent(Summary{x,3}{y,1});
            i = ~ismember(f,{'MatlabAnalysis'});
            f = f(i);
            pf = pf(i);
            Summary{x,2}(y,2:numel(f)+1) = f';
            
            %% get MWT folder count
            g = {};
            for z = 1:numel(pf)
                % check if folder is a MWT folder
                [mwtf,pmwt] = dircontent(pf{z},'Option','MWTall');
                g{z,1} = f{z};
                g{z,2} = numel(mwtf);
            end
            e = [repmat(ExpfnT(y),z,1),g];
            D = [D;e];
        end
        S = [S;[repmat(RCU(x),size(D,1),1),D]];
    end
    %% output
    varargout{1} = Summary;
    varargout{2} = S;
end
