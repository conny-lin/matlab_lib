function displayallMWTfrunname(MWTfsn)
    % the imported names are in column 2 of MWTfsn
    b = {}; 
    b(1:size(MWTfsn,1),1) = {MWTfsn{1,2}(end-3:end)}; % find ext from first file
    c = {};
    c(1:size(MWTfsn,1),1) = {''};
    disp(cellfun(@strrep,MWTfsn(:,2),b,c,'UniformOutput',0));
end