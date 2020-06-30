function [T] = timeconvert(Datat,time)
%% instruction
% xL{1,1} = 'secs';   xf(1,1) = 1;            
% xL{1,2} = 'mins';   xf(1,2) = 60;           
% xL{1,3} = 'hours';  xf(1,3) = 60*60;        
% xL{1,4} = 'days';   xf(1,4) = 60*60*24;    
% xL{1,5} = 'weeks';  xf(1,5) = 60*60*24*7;   
%% set parameter
xL{1,1} = 'secs';   xf(1,1) = 1;            
xL{1,2} = 'mins';   xf(1,2) = 60;           
xL{1,3} = 'hours';  xf(1,3) = 60*60;        
xL{1,4} = 'days';   xf(1,4) = 60*60*24;    
xL{1,5} = 'weeks';  xf(1,5) = 60*60*24*7;   

i = celltakeout(regexp(time,xL)','logical')';
if sum(i) ==1; T = Datat./xf(1,i); 
else error 'time entry invalid'; 
end
end