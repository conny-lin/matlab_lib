function [MWTfdatGG,ExpGA,GAA] = getMWTfdatcombined(pBet)

%% get GA from pBet
[~,~,Expf,pExpf] = dircontent(pBet);
ExpGA = {};
for x = 1:size(pExpf,1);
    pExp = pExpf{x,1};
    cd(pExp);
    [f,pf] = dircontentext(pExp,'import*.mat');
    load(f{1},'GA','GAA');
    A = {};
    A(1:size(GA,1),1) = Expf(x,1);
    A = cat(2,A,GA);
    ExpGA = cat(1,ExpGA,A);  
end

%% find unique group
MWTfdatGG = cell(size(unique(ExpGA(:,3)),1),2);
MWTfdatGG(:,1) = unique(ExpGA(:,3));

% for each group


for x = 1:size(ExpGA,1);% for each group of each experiment, 
    gc = ExpGA(x,2); % find group code
    pExp = strcat(pBet,'/',ExpGA{x,1});
    cd(pExp); % go to the exp folder
    [f,pf] = dircontentext(pExp,'import*.mat');
    load(f{1},'MWTfgcode','MWTfdat'); 
    [~,~,i] = intersect(gc,cell2mat(MWTfgcode(:,1))); % go to MWTfgcode, 
    di = MWTfgcode{i,3}; % find where the data is MWTfgcoe(gcoderow,3)
    A = {};
    for y = 1:size(di,2);
        iff = di(1,y); % get index to MWTf
        A{y,1} = MWTfdat{iff,1}; % get raw data MWTf name 
        A(y,2) = MWTfdat(iff,3);% get MWTfdat raw data
    end
    % get previous data
    gname = ExpGA{x,3}; % get gname
    [~,~,is] = intersect(gname,char(MWTfdatGG(:,1)),'rows'); % find location of group in MWTfdatGG
    B = MWTfdatGG{is,2}; % get old data out 
    C = cat(1,B,A); % cat it
    MWTfdatGG{is,2} = C; % put it back
    
end

cd(pBet);
savename = strcat('Combine_',date);
save(savename);

end