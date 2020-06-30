function PairArray = pairwise_getpair2v(iv1,iv2)
%% input are list two ivs (do not need to be same length)
%% numeric input
nv1 = numel(iv1);
nv2 = numel(iv2);
n = nv1*nv2;
PairArray = nan(n,2); 
r1 = 1;
for i = 1:nv2
    a = repmat(iv1,nv2,1);
    r2 = r1+numel(a)-1;
    PairArray(r1:r2,1) = a;
    
    b = repmat(iv2(i),numel(a),1);
    PairArray(r1:r2,2) = b;
    r1 = r2+1;
end
PairArray = unique(PairArray,'rows');

%% take out repeat nans
if sum(isnan(PairArray(:,2))) > 0
   i = isnan(PairArray(:,2));
   a = PairArray(i,:);
   a(isnan(a))=Inf;
   a = unique(a,'rows');
   a(isinf(a)) =NaN;
   PairArray(i,:) = [];
   PairArray = [PairArray;a];
end

if sum(isnan(PairArray(:,1))) > 0
   i = isnan(PairArray(:,1));
   a = PairArray(i,:);
   a(isnan(a))=Inf;
   a = unique(a,'rows');
   a(isinf(a)) =NaN;
   PairArray(i,:) = [];
   PairArray = [PairArray;a];
end


