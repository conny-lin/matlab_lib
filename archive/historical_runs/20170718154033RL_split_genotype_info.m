%% INITIALIZING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; 
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');
pM = setup_std(mfilename('fullpath'),'RL','genSave',true); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load database
pDataBase = '/Volumes/COBOLT/MWT';
load(fullfile(pDataBase,'MWTDB.mat'));

%% split genotype information
S = MWTDB.strain;
genotypes = S.genotype;
a = regexpcellout(genotypes,'[(]|[)]|[;]|[[]|[]]','split');

%% go through each strain
varnames = {'genotype','promoter','gene','allele','chromosome','array','others'};
A = cell(size(genotypes,1),numel(varnames));
T = cell2table(A,'VariableNames',varnames);
startn = 1;

for ai = startn:size(a,1)
    % genotype
    genotype = genotypes{ai};
    T.genotype(ai) = {genotype};
    % get info
    b = a(ai,:)';
    b(cellfun(@isempty,b)) = [];
    for vi = 2:numel(varnames)
        if ~isempty(b)
            name = varnames{vi};
            switch name
                case 'gene'
                    searchterm = '(^[a-zA-Z]{1,}-\d{1,})|(^wildtype$)|mcherry|GFP';
                case 'chromosome'
                    searchterm = '^((I){2,3})|^I$(^IV$)|X|V$';
                case 'promoter'
                    searchterm = '^(P|p)[a-zA-Z]{1,}-\d{1,}[:]{1,}[a-zA-Z]{1,}-\d{1,}';
                case 'array'
                    searchterm = '(^(EX)|(Ex)([a-z]{1,}|[0-9]{1,}))|([a-z]{1,}Is[0-9]{1,})';
                case 'allele'
                    searchterm = '^[a-z]{1,}\d{1,}|(hawaiian)|(bristol)';
            end
            switch name 
                case 'others'
                    c = strjoinrows(b',', ');
                    
                otherwise
                    % process
                    c = regexpcellout(b,searchterm,'match');
                    i = regexpcellout(b,searchterm);
                    b(i) = [];

                    c(cellfun(@isempty,c)) = [];
                    if numel(c)>1
                        c = strjoinrows(c',', ');
                    end

            end
            if ~isempty(c)
                T.(name)(ai) = c;
            end
        end

    end
end

%% reorganize table
T1 = innerjoin(S,T);
writetable(T1,fullfile(pM,'strain information.csv'));