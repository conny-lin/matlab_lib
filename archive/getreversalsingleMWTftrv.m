function [MWTftrv1] = getreversalsingleMWTftrv(ptrv)
%% trv summary
% this formula does not account for 
%% test import .trv
% data produced by: pluginreversal = '--plugin MeasureReversal::tap::dt=1::collect=0.5::postfix=trv';
% filename = 'N2_3x4_t96h20C_100s30x10s10s_C05301.trv';
[fn,~] = dircontentext(ptrv,'*.trv');
[~,MWTfn] = fileparts(ptrv);
% check if trv exist
if isempty(fn) ==0;   
    cd(ptrv);
    A = dlmread(fn{1},' ',5,0);
    B = {};
    B(1,1) = {MWTfn};
    B(1,2) = fn;
    B(1,3) = {A};
    B{1,4} = A(:,5);
    B{1,6} = A(:,4); % N no response
    B{1,5} = A(:,4)+A(:,5); % total N
    B{1,7} = A(:,1); % time
    B{1,8} = A(:,5)./B{1,5}; % get freq graph
    B{1,9} = A(:,8).*A(:,5); % distance
    B{1,10} = A(:,8); % distance without accmodating for N
    MWTftrv1 = B;
else
    warning(sprintf('no trv file found in %s',MWTfn));
    B(1,1) = {MWTfn};
    MWTftrv1 = B;
end

%Nrev = A(:,5); % N reversed
%Nnr = A(:,4); % N no response
%N = Nrev+Nnr; % total N
%Rtime = A(:,1); % time
%Rfreq = Nrev./N; % get freq graph
%Rdist = A(:,8).*A(:,5); % distance

end
