function [MWTfsncorr] = validateMWTfnameparts(MWTfsn)
%% [c,h] = parseMWTRCall(MWTfsn)
MWTfsncorr = MWTfsn;
%% get run condition parts
display('Validating MWT run names parts...');
RCpart = {}; % declare output cell array
under(1:size(MWTfsn(:,2)),1) = {'_'};
[~,~,~,~,~,~,parts] = cellfun(@regexp,MWTfsn(:,2),under,'UniformOutput',0);
RCnameparts = {};
for x = 1:size(parts);
    RCnameparts(x,:) = parts{x,1};
end
tegp(1:size(MWTfsn(:,2)),1) = {'[A-Z]\d\d\d\d[a-z][a-z]'};
[~,~,~,m,~,~,~] = cellfun(@regexp,MWTfsn(:,2),tegp,'UniformOutput',0)
wrongtdgp = cellfun(@isempty,m);
if sum(wrongtdgp) ~=0;
    display('Tracker-date-group-plate code incorrect');
    i = find(wrongtdgp);
    for x = 1:size(i,1);
        newname = MWTfsn{i(x,1),2};
        q1 = 0;
        while q1 ==0;
            display(' ');
            disp(newname);
            newname = input('Please enter correct full name:\n','s');
            q1 = input('is this correct (y=1,n=0)? ');
        end
        MWTfsncorr{wrongtdgp(i(x,1),1),2} = newname;
    end
end


end