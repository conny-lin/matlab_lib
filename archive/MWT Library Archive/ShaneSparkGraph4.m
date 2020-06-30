function ShaneSparkGraph4(pExp,pSave,pSet,MWTftrvG)
%% import settings
%% get Groups*.mat for MWTfcode and GAA
[groupmatname,p] = dircontentext(pExp,'Groups_*');
if numel(groupmatname)>=1 && iscell(groupmatname)==1;
    cd(pExp);
    load(groupmatname{1});
    if exist('MWTfgcode','var')==0; 
        error 'Missing MWTfgcode var from Groups_*.mat import';
    end
else
    error 'No Groups_*.mat imported';
end

% get expname
[~,expname] = fileparts(pExp); 

%% [suspend] import MWTftrv 
% [fn,pmat] = dircontentext(pExp,'ShaneSparktrv*');
% if isempty(fn)==0 && numel(fn)==1;
%     load(fn{1});
% elseif isempty(fn)==1;
%     display 'No ShaneSparktrv.mat found';
%     return
% elseif numel(fn)>1;
%     display 'More than one ShaneSparktrv.mat found';
%     return
% end


%% stats
display(' ');
display('Calculating curve descriptive statistics...');
[HabGraph] = statcurvehab1(MWTftrvG);
[HabGraphStd] = statstdcurvehab1(MWTftrvG);
display('done');

%% Graphing
display(' ');
display('Graphing...');
if exist('GAA','var')==1;
elseif exist('Groups','var')==1 && exist('GAA','var')==0;
    GAA = [num2cell((1:numel(Groups(:,1)))'),Groups];
end
[G] = habgraphindividual2(HabGraph,HabGraphStd,'GraphSetting.mat',GAA,...
    pSet,pExp,pSave);
[savename] = creatematsavename3(expname,'stats_','.mat');
save(savename);
cd(pSave);
display('done');