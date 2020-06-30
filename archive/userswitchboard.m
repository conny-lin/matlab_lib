function [P,pFun] = userswitchboard(p,user,status)
%% Instruction:
% status = 'Grad' or 'Undergrad'
graduatestudentlist = {'Conny Lin';'Evan Ardiel'};
gradindex = not(cellfun(@isempty,regexp(graduatestudentlist,user))); % get index to grad list

%% [SUSPEND] user input
% switch status
%     case 'Any' % if accessing unrestricted area
%         if isempty(gradindex)==1; % is not a grad
%             % select grad supervisor name
%             display ' ';
%             display 'Graduate Supervisor List: ');
%             disp([num2cell((1:numel(graduatestudentlist))') graduatestudentlist]);
%             display 'Select the name of your grad supervisor';
%             gradindex = input('[press ENTRE if name is not listed]: '); % reocrd gradindx as empty
%             if isempty(gradindex) ==0; % if grad supervisor entered
%                 grad = graduatestudentlist(gradindex);
%             elseif isempty(gradindex) ==0; 
%                 display 'Please ask your supervisor to ask Conny to put his/her name on the grad list';
%             end
%         elseif isempty(gradindex) ==0; % is a grad
%             grad = user; % grad is the user
%         end
%     case 'GradOnly' % if tryin to access grad only area
% 
%         if isempty(gradindex) ==0; % is a gra
%             grad = user;
%             addpath(genpath(cd)); % add all paths for development
%         else % is not a grad 
%             display ' ';
%             % [CODE] create automatic add grad student interface
%             display 'This is a grad only area';
%             display 'To gain access, please ask Conny to ask your name on the grad list.'); 
%             disp ' ';
%             return
%         end
% end


%% check if cd path goes to MWT Portal
datalocation = input('Are your program in the same drive as your MWT Portal (y=1,n=0)? ');
switch datalocation
    case 0;
        display 'Please enter drive name of the MWTPortal containing your data: ';
        datadrivename = input('[e.g. Flame]: ','s');
        datadrivename = strcat('/Volumes/', datadrivename, '/');
        [P] = definepath4diffcomputers2(datadrivename,grad,status); % get predefined paths     
        P.Fun = p; % adjust pFun location
        pFun = P.Fun;
    case 1;     
        [P] = definepath4diffcomputers2(p,status); % get predefined paths
        pFun = P.Fun;
end
end


%% Subfunction
function [p] = definepath4diffcomputers2(cd,grad)
%% works for grad student only
% Search for [BUG] and [CODE] for development
graduatestudentlist = {'Conny Lin';'Evan Ardiel'};
disp([num2cell((1:numel(graduatestudentlist))') graduatestudentlist]);
a = input('Select your name: ');
gradindex = not(cellfun(@isempty,regexp(graduatestudentlist,a))); % get index to grad list


%% find hard drive name
path = cd;
n = regexp(path,'/Users/','split');
if numel(n) ==1; % if it is an external hard drive
    n = regexp(path,'/Volumes/','split');
    external = 1; % record external hard drive
else
    external = 0;
end
h = regexp(n{2},'/','split'); 
harddrive = h{1};

%% defining MWT Portal paths
if external ==1; % if it is a external hard drive
    pH = ['/Volumes/',harddrive];
elseif strcmp(harddrive,'connylinlin') ==1; % if it is conny's computer
    pH = '/Users/connylinlin/MatLabTest';
else
    pHt = input('paste the path of MWT Portal folder','s');
    pH = regexprep(pHt,'/MultiWormTrackerPortal');
end
[~,~,~,pf] = dircontent(pH);

gradindex = regexp(pf,'MultiWormTrackerPortal');
if sum(cellfun(@isempty,gradindex)) ==0;
    error ('no MultiWormTrackerPortal found..');
end
p.Portal = pf{not(cellfun(@isempty,gradindex))};

%% get the rest
p.Raw = [p.Portal,'/','MWT_Raw_Data'];
p.Expter = [p.Portal '/' 'MWT_Experimenter_Folders'];
p.Fun = [p.Portal,'/','MWT_Programs'];
p.Setting = [p.Fun '/' 'MatSetfiles'];
p.FunD = [p.Fun '/' 'SubFun_Developer'];
p.FunG = [p.Fun '/' 'SubFun_General'];
p.FunR = [p.Fun '/' 'SubFun_Released'];

%% prep grad student only folder
% [BUG] Needs to pre define this for students
grad = char(regexprep(grad,' ','_'));
p.Grad = [p.Expter,'/',grad];
p.GradA = strcat(p.Grad,'/','MWT_AnalysisReport');
if isdir(p.GradA) ==0;
    cd(p.Grad);
    mkdir('MWT_AnalysisReport');
end
p.GradRaw = strcat(p.Grad,'/','MWT_NewRawReport');
if isdir(p.GradRaw) ==0;
    cd(p.Grad);
    mkdir('MWT_NewRawReport');
end
end
