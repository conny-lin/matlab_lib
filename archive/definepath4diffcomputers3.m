function [p] = definepath4diffcomputers3(cd,grad)
%% works for grad student only
% Search for [BUG] and [CODE] for development
graduatestudentlist = {'Conny Lin';'Evan Ardiel'};
disp([num2cell((1:numel(graduatestudentlist))') graduatestudentlist]);
gradindex = not(cellfun(@isempty,regexp(graduatestudentlist,grad))); % get index to grad list
if sum(gradindex)==0;
   display 'Not authorized person';
    return
end

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
