%% RNAseq
cd('/Users/connylinlin/Dropbox/Lab/RNAseq/Data');
filename = 'exported_analyses_400-392_RNA-Seq_8M_08142013_3SEQ2.txt';
%% load the files
fid = fopen(filename);
C = textscan(fid, '%s %f %f %f','delimiter','\t');
fclose(fid);
%% gene expression data
G = cellstr(C{:,1});
E = [C{:,2},C{:,3},C{:,4}];
%% calculate
% which genes has more expression
a(:,1) = E(:,2)-E(:,1); % EN-CN
a(:,2) = E(:,3)-E(:,1); % ED-CN
a(:,3) = E(:,3)-E(:,2); % ED-EN
%% which genes are opposite
display ' ';
display 'Compared to CN:';
str = '%d genes overexpressed in EN but under expressed in ED';
i = a(:,1) > 0 & a(:,2) < 0; % EN over expressed but ED under expressed
A = cellstr(G(i));
display(sprintf(str,numel(A)));
str = '%d genes overexpressed in ED but under expressed in EN';
i = a(:,1) < 0 & a(:,2) > 0; % EN under expressed but ED over expressed
A = cellstr(G(i));
display(sprintf(str,numel(A)));
display ' ';
display 'Compared to EN:';
str = '%d genes over-expressed in ED';
i = a(:,3) > 0; % ED over expressed compared to EN
A = G(i);
display(sprintf(str,numel(A)));
str = '%d genes under-expressed in ED';
i = a(:,3) < 0; % ED over expressed compared to EN
A = G(i);
display(sprintf(str,numel(A)));
display ' ';
display 'Using a higher threshold (>100 copies)';
display 'Compared to CN:';
str = '%d genes overexpressed in EN but under expressed in ED';
i = a(:,1) > 100 & a(:,2) < -100; % EN over expressed but ED under expressed
A = cellstr(G(i));
display(sprintf(str,numel(A)));
str = '%d genes overexpressed in ED but under expressed in EN';
i = a(:,1) < -100 & a(:,2) > 100; % EN over expressed but ED under expressed
A = cellstr(G(i));
display(sprintf(str,numel(A)));
display ' ';
display 'With even higher threshold (>500 copies)';
display 'Compared to CN:';
str = '%d genes overexpressed in EN but under expressed in ED';
i = a(:,1) > 500 & a(:,2) < -500; % EN over expressed but ED under expressed
A = cellstr(G(i));
display(sprintf(str,numel(A)));
str = '%d genes overexpressed in ED but under expressed in EN';
i = a(:,1) < -500 & a(:,2) > 500; % EN over expressed but ED under expressed
A = cellstr(G(i));
display(sprintf(str,numel(A)));
%%



