function S = varargin_pair_parse(V)


% check if even number, 
if isinteger(numel(V)/2) == 1
    % invalidate if not even number
    error('variable entries incorrect')
end


% take out odd inputs as var name
callName = V(1:2:numel(V));
% validate if all inputs are characters
a = cellfun(@ischar,callName);
if sum(a)~=numel(a)
   error('some varargin input names are not characters') 
end
% take out even inputs as var values
setValue = V(2:2:numel(V)); 
% put in structure array S
S = struct;
for si = 1:numel(callName)
    % get call name
    n = callName{si};
    % get value
    a = setValue{si};
    % create eval
    eval(sprintf('S.%s = a;',n))
    
    
end