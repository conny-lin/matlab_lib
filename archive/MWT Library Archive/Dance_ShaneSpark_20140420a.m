function [varargout] = Dance_ShaneSpark(varargin)



%% VARAGOUT
varargout{1} = {};


%% VARARGIN
switch nargin
    case 1
       MWTSet = varargin{1};
        
    otherwise
        error('coding');
end



%% get field out
% getstructvar(MWTSet); - function 
names = fieldnames(MWTSet);
for x = 1:numel(names)
   eval([names{x},'= MWTSet.',names{x},';']);
end


%% validate required input vs. var name
rinput = {'pMWTchorpass','pMWTf'};

for x = 1:size(rinput,1)
    
    % check if struct name is convereted to varname
    structname = rinput{x,1};
    
    if exist(structname,'var') == 1 % if it is
        % convert to desired var name
        varname = rinput{x,2};
        eval([varname,'= ',structname,';']);
    else % if it is not
        error('not enough input from MWTSet');       
    end    
end

        
%% GET MWT FILE PATH
% pMWTf = MWTSet.pMWTchorpass;
[~,MWTfn] = cellfun(@fileparts,pMWTf,'UniformOutput',0);


%% STEP4A: IMPORT .TRV 
% revised 20140419
A = MWTfn;
for m = 1:size(pMWTf,1);
    display(sprintf('processing[%d/%d]: %s',m,numel(pMWTf),MWTfn{m}));
    [~,p] = dircontentext(pMWTf{m},'*.trv'); 
    % validate trv output format
    pt = p{1};
    fileID = fopen(pt,'r');
    d = textscan(fileID, '%s', 2-1, 'Delimiter', '', 'WhiteSpace', '');
    fclose(fileID);
    % read trv
    if strcmp(d{1}{1}(1),'#') ==1 % if trv file is made by Beethoven
        a = dlmread(pt,' ',5,0); 
    else % if trv file is made by Dance
        a = dlmread(pt,' ',0,0);

    end
    A{m,2} = a(:,[1,3:5,8:10,12:16,19:21,23:27]); % index to none zeros

end
MWTfnImport = A;
MWTSet.Import = MWTfnImport;

%% legend
L = {'time','N?','N_NoResponse','N_Reversed','?','RevDist'
    };
    
%%

%% STEP4X: CHECK TAP CONSISTENCY
[r,c] = cellfun(@size,MWTfnImport(:,2),'UniformOutput',0);
rn = celltakeout(r,'singlenumber');
rfreq = tabulate(rn);
rcommon = rfreq(rfreq(:,2) == max(rfreq(:,2)),1);
str = 'Most common tap number = %d';
display(sprintf(str,rcommon));
rproblem = rn ~= rcommon;

if sum(rproblem)~=0;
    MWTfnP = MWTfn(rproblem); 
    pMWTfP = pMWTf(rproblem);

    str = 'The following MWT did not have the same tap(=%d)';
    display(sprintf(str,rcommon)); disp(MWTfnP);
    display 'Removing from analysis...'; 
    MWTSet.RawBad = MWTfnImport(rproblem,:);
    MWTfnImport = MWTfnImport(~rproblem,:);
    MWTfn = MWTfn(~rproblem);
    pMWTf = pMWTf(~rproblem);    
    
    % reconstruct
    [MWTSet.MWTfG] = reconstructMWTfG(pMWTf);

end



%% STEP4B: MAKING SENSE OF TRV 
% indexes of .trv
ind.RevDur = 13;

B = [];
B.MWTfn = MWTfn;
A = MWTfnImport;
for m = 1:size(pMWTf,1);
    
    % X = tap time
    % B.X.TapTime(:,m) = A{m,2}(:,1);
    B.X(:,m) = A{m,2}(:,1);
    
    % basic caluations
    B.N.NoResponse(:,m) = A{m,2}(:,3);
    B.N.Reversed(:,m) = A{m,2}(:,4); 
    
    B.N.TotalN(:,m) = B.N.Reversed(:,m)+B.N.NoResponse(:,m);
    
    % Frequency
    B.Y.RevFreq(:,m) = B.N.Reversed(:,m)./B.N.TotalN(:,m);
    % B.Y.RevFreqStd(:,m) = B.Y.RevFreq(:,m)/B.Y.RevFreq(1,m);
    
    % Distance
    B.Y.RevDist(:,m) = A{m,2}(:,5); 
    % B.Y.RevDistStd(:,m) = B.Y.RevDist(:,m)/B.Y.RevDist(1,m);
    % B.Y.SumRevDist(:,m) = B.Y.RevDist(:,m).*B.N.Reversed(:,m); 
    
    
    % Reversal Duration
    B.Y.RevDur(:,m) = A{m,2}(:,ind.RevDur);
    
    % Reversal Speed = RevDist/RevDur
    B.Y.RevSpeed(:,m) = B.Y.RevDist(:,m)./B.Y.RevDur(:,m); 
    
end


Raw = B;


%% VARARGOUT
MWTSet.Raw = Raw;
varargout{1} = MWTSet;




%% [moved] STEP4C.SUBPLOTS
% 
% % source code: LadyGaGaSubPlot(MWTftrvG,pExp,SavePrefix)
% % define universal settings
% % switch graphing sequence
% i = [2,3,1,4];
% k = fieldnames(Stats.Y)';
% M = k(i);
% groupname = fieldnames(MWTfG)';
% groupsize = numel(fieldnames(MWTfG));
% gnshow = regexprep(groupname,'_',' ');
% xmax = size(Graph.X.(M{m}),1)+1;
% subplotposition(1,1:4) = [0.065 0.55 0.4 0.4];
% subplotposition(2,1:4) = [0.55 0.55 0.4 0.4];
% subplotposition(3,1:4) = [0.065 0.11 0.4 0.4];
% subplotposition(4,1:4) = [0.55 0.11 0.4 0.4];
% legendposition = 2;
% % preset color codes
% color(1,:) = [0,0,0];
% color(2,:) = [0.30 0.50 0.92]; %[0.04 0.14 0.42];
% color(3,:) = [0.168 0.505 0.337];
% color(4,:) = [0.847 0.16 0];
% % Create figure
% figure1 = figure('Color',[1 1 1]); 
% for m = 1:numel(M);
%     axes1 = axes('Parent',figure1,'FontName','Arial',...
%         'Position',subplotposition(m,1:4));
%     % 'XTickLabel','', (remove setting it off
%     ylim(axes1,[0 1.1]); xlim(axes1,[0 xmax]); hold(axes1,'all');
%     errorbar1 = errorbar(Graph.X.(M{m}),Graph.Y.(M{m}),...
%         Graph.E.(M{m}),...
%         'Marker','.','LineWidth',2);
%     ylabel(M{m},'FontName','Arial'); % Create ylabel
%     if numel(groupname) <=4
%         for g = 1:numel(groupname);
%             set(errorbar1(g),'DisplayName',gnshow{g},...
%                     'LineWidth',2,'Color',color(g,1:3),...
%                     'MarkerSize',20,'Marker','.'); 
%         end
%     elseif numel(groupname) >=5
%         for g = 1:4;
%             set(errorbar1(g),'DisplayName',gnshow{g},...
%                     'LineWidth',2,'Color',color(g,1:3),...
%                     'MarkerSize',20,'Marker','.'); 
%         end
%         for g = 5:numel(groupname);
%             set(errorbar1(g),'DisplayName',gnshow{g},...
%                     'LineWidth',2,...
%                     'MarkerSize',20,'Marker','.'); 
%         end  
%     end
% 
% 
%     if m ==legendposition; % if making righttop cornor
%         for g = 1:numel(groupname);
%             %set(errorbar1(g),'DisplayName',gnshow{g},...
%                 %'LineWidth',2);
% 
%             legend1 = legend(axes1,'show');
%             set(legend1,'EdgeColor',[1 1 1],'YColor',[1 1 1],...
%                 'XColor',[1 1 1],'TickDir','in',...
%                 'LineWidth',1);
%         end
%     end
% end
% 
% % create textbox for N
% for g = 1:numel(groupname); gN(g) = size(MWTfG.(groupname{g}),1); end
% n = num2str(gN'); b = cellfunexpr(groupname',' ');
% a = char(cell2mat(cellstr([n,char(b)])'));
% v = a(1,1:end); 
% t = 'N = '; 
% N = [t,v];
% annotation(figure1,'textbox',[0.003 0.02 0.20 0.05],'String',{N},...
%     'FontName','Arial','FitBoxToText','off','EdgeColor','none');
% 
% % save figure 
% %         h = (gcf);
% titlename = ['ShaneSpark_CombineGraph']; % set name of the figure
% savefigjpeg(titlename,pSaveA);
% %         set(h,'PaperPositionMode','auto'); % set to save as appeared on screen
% %         cd(pSaveA);
% %         print (h,'-dtiff', '-r0', titlename); saveas(h,titlename,'fig');
% % finish up
% %         display 'Graph done.';
% %         close;


%% STEP6C: SAVE MATLAB
% cd(pSaveA); save('matlab.mat');  
% O.pSaveA = pSaveA;
end