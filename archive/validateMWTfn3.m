function [T,P] = validateMWTfn3(MWTf,pMWTf)
% make sure the dir is a MWT folder (20130407_153802)
if isempty(MWTf)==1;
    P = 0;
    T = 0;
else
    T = [];
    for x = 1:size(MWTf,1);
        % set conditions
        c1 = isequal(isdir(pMWTf{x,1}),1); % c1=1 if it is a dir
        c2 = isequal(size(MWTf{x,1},2),15); % c2=1 if name is 15 characters
        if c2 ==0;
            T(x,1) = 0; % record fail
        else
            c3 = isequal(strfind(MWTf{x,1},'_'),9); % c3=1 if _ at position9
            c4 = isnumeric(str2num(MWTf{x,1}(1:8))); % first 8 digit numeric
            c5 = isnumeric(str2num(MWTf{x,1}(10:15))); % last 6 digit numeric
            if (c1+c2+c3+c4+c5) ==5; % if satisfies all 5 conditions
                T(x,1) = 1; % record pass
            else
                T(x,1) = 0; % record fail
            end
        end
    end
    P = isequal(size(MWTf,1),sum(T));
end
end

