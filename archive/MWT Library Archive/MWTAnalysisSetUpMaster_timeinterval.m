function [MWTSet] = MWTAnalysisSetUpMaster_timeinterval(MWTSet)
% origin: MWTAnalysisSetUpMaster_timeinterval 20150202 copy


% report start
display ' '; display('setting up time inputs');


% do not need time input
if sum(strcmp({'ShaneSpark','ShaneSpark2'},MWTSet.AnalysisName))~=0
    % reporting
    display('ShaneSpark analysis does not require time inputs');
else
    % define time
    display ' ';
    display 'Time interval setting options:'
    a = {'Mean of all data, every 10s from start to finish';
        'mean of data within 1s after every 5s from 10s to finish';
        'Manually enter time intervals'};
    disp(makedisplay(a))
    display ' ';
    method = a{input('Choose analysis time interval setting: ')};
    
    switch method
        case 'Mean of all data, every 10s from start to finish'
           TimeInputs = [NaN,10,NaN,NaN];
       
        case 'mean of data within 1s after every 5s from 10s to finish'
           TimeInputs = [10,5,1,NaN];
       
        case 'Manually enter time intervals'        
            display 'Enter analysis time periods: ';
            tinput = input('Enter start time, press [Enter] to use MinTracked: ');
            intinput = input('Enter interval, press [Enter] to use default (10s): ');
            tfinput = input('Enter end time, press [Enter] to use MaxTracked: ');
            display 'Enter duration after each time point to analyze';
            % (optional) survey duration after specifoied target time point
            durinput = input('press [Enter] to analyze all time bewteen intervals: '); 

            % organize time inputs
            if isempty(tinput) ==1; tinput = NaN; end
            if isempty(intinput) ==1; intinput = NaN; end
            if isempty(durinput) ==1; durinput = NaN; end
            if isempty(tfinput) ==1; tfinput = NaN; end
            TimeInputs = [tinput,intinput,durinput,tfinput];


    end
end

if exist('TimeInputs','var') ==1
    MWTSet.TimeInputs = TimeInputs;
end
