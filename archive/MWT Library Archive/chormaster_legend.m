function [MWTSet] = chormaster_legend(MWTSet)
% chorscript
chorscript = MWTSet.chorscript;

%% reference for chor legend
sL = {
    'f frame -- the frame number';
    't time -- always the first column unless included again ';
    'n number -- the number of objects tracked ';
    'N goodnumber -- the number of objects passing the criteria given ';
    'p persistence -- length of time object is tracked ';
    's speed ';
    'S angular -- angular speed ';
    'l length -- measured along major axis, not curve of object ';
    'L rellength -- instantaneous length/average length ';
    'w width ';
    'W relwidth -- instantaneous width/average width ';
    'a aspect -- length/width ';
    'A relaspect -- instantaneous aspect/average aspect ';
    'm midline -- length measured along the curve of object ';
    'k kink -- head/tail angle difference from body (in degrees) ';
    'b bias -- fractional excess of time spent moving one way ';
    'c curve -- average angle (in degrees) between body split into 5 segments ';
    'd dir -- consistency of direction of motion ';
    '1 tap -- whether a tap (stimulus 1) has occurred ';
    '2 puff -- whether a puff (stimulus 2) has occurred';
    '3 stim3 -- whether the first custom stimulus has occurred ';
    '4 stim4 -- whether the second custom stimulus has occurred';
    'D id -- the object ID ';
    'e area ';
    'M morphwidth -- mean width of body about midline ';
    'P pathlen -- distance traveled forwards (backwards=negative) ';
    'x loc_x -- x coordinate of object (mm) ';
    'y loc_y -- y coordinate of object (mm) ';
    'u vel_x -- x velocity (mm/sec) ';
    'v vel_y -- y velocity (mm/sec) ';
    'o orient -- orientation of body (degrees, only guaranteed modulo pi) ';
    'r crab -- speed perpendicular to body orientation ';
    };

%% create chorscript legend
chorfile = MWTSet.chorfile;
fn = {};
for cc = 1:numel(chorfile)
    fn{cc} = regexprep(chorfile{cc},'*|[.]','');
    
    targetfilename = fn{cc};
    % create legend names
    a = regexp(sL,' ','split');
    for x = 1:size(a,1)
        sLcode(x,1) = a{x,1}(1,1);
        sLname(x,1) = a{x,1}(1,2);
    end
    % get script
    c = chorscript{cc};
    if isempty(regexp(c,'MeasureReversal')) ==1
        a = regexp(c,'-o | --plugin','split');
        script = a{2};
        % scriptL: translate legend names
        for x = 1:numel(script)
           scriptL(x) = sLname(strcmp(sLcode,script(x))); 
        end
        MWTSet.scriptL{cc} = scriptL;
    else
        warning('function needed for MeasureReversal legends');
    end
end