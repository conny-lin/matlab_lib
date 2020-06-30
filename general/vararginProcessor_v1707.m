function [InputStruct] = vararginProcessor_v1707(varexist,vararginInput, varargin)


%% DEFAULTS
VAR(:)= vararginInput(:);
assign2base = false;
vararginN = numel(VAR);
varexist

%% check if varargin names matches any existing var
% check if varargins are paired
varN = vararginN/2;
if isinteger(varN) == 1
    error('variable entries incorrect')
end

% get pairs
callName = VAR(1:2:vararginN); % get call name
setValue = VAR(2:2:vararginN); % get input values

% check if call names are strings
for callnamei = 1:numel(callName)
   if ischar(callName{callnamei}) == 0
       error('some var names not strings');
   end
end

% check if call names have defaults
[i,j] = ismember(callName,{varexist.name});
if any(~i)
    error('Not found as optional inputs: %s',strjoin(callName(~i),', '));
end

% find types of default inputs
a = {varexist.class}; % get class
default_class = a(j);
clear a;
% get class of inputs
var_class = cellfun(@class, setValue, 'UniformOutput',0);
class_check = cellfun(@isequal, var_class, default_class);
if any(~class_check)
    error('Optional inputs class not the same as default class\n: %s', strjoin(callName(~class_check), ', '));
end

%% put in structure
InputStruct = struct;
for i = 1:varN
    InputStruct.(callName{i}) = setValue{i};
end

%% process each depending on class
if assign2base
    for varNi = 1:varN
        assignin('caller',callName{varNi},setValue{varNi});
    end
end












