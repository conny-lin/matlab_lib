function [varargout] = Dance_SampleTime(RCT,varargin)

% [optional] sampleint
i = find(strcmp(varargin,'sampleint'))+1;
if isempty(i) ==0 && isnumeric(varargin{i})==1;
    sint = varargin{i};
else
    sint = 10; % sample interval default setting
end

% [optional] sampledur
i = find(strcmp(varargin,'sampledur'))+1;
if isempty(i) ==0 && isnumeric(varargin{i})==1;
    SampleDur = varargin{i};
else
    SampleDur = 0.5; % default setting
end

%% DEFINTE SAMPLETIME
%% get time info from RCT (run condition)
% get run condition
rct = regexp(RCT,'[s,x]','split');

% construct sample interval
% every 10 second from beginning to first tap, i.e. 10:10:preplate-10
preplate = str2double(rct{1}); 
pretapint = 10:sint:(preplate-sint);
% every tap interval 100s preplate:10sISI:(30taps*10sISI+100s preplate)
tap1 = preplate;
tapN = str2double(rct{2});
tapint = str2double(rct{3});
tapend = (tapN*tapint+preplate-tapint);
tapt = preplate:tapint:tapend;

% every 10 seconds after last tap: 
    % (30taps*10sISI+100s preplate + 10s):10s:
    % ((30taps*10sISI+100spreplate+after tap time10s)
taftertap = str2double(rct{4});
recordend = tapend+taftertap+tapint;
aftertapint = (tapend+sint):sint:recordend;

% set sample times
SampleTime_NoTap = [pretapint,aftertapint];
SampleTime_Tap = tapt;
SampleTime = sort([SampleTime_NoTap,SampleTime_Tap]);

%% create varagout
S.all = SampleTime;
S.notap = SampleTime_NoTap;
S.tapN = tapN;
S.Tap = SampleTime_Tap;
S.Sdur = SampleDur;
varargout{1} = S;

