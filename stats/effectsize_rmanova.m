function d = effectsize_rmanova(rmanovatable,conditionsname,repeatmsrname)

% conditionsname can be multiple conditions in cell array, i.e. {'strain',
% 'dose'} or character array 'strain:dose'
% repeatmsrname = repeated measures name, can be in cell or char

D = rmanovatable; % get relevant data
% process repeatmsrname
if ischar(repeatmsrname)
    repeatmsrname = {repeatmsrname};
end


% process conditions name
if iscell(conditionsname)
    if numel(conditionsname) > 1
        conditionsname = strjoin(conditionsname,':');
    end
else
    conditionsname = {conditionsname};
end

sterm = strjoin([conditionsname,repeatmsrname],':');
SSconditions = D.SumSq(sterm);

% search for data
sterm = sprintf('Error(%s)',char(repeatmsrname));
SSerror = D.SumSq(sterm);

% calculate
d = SSconditions / (SSconditions + SSerror); 
