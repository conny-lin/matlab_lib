function e1 = graphApplySetting(e1,gsetname)
% apply settings 
gp = graphsetpack(gsetname);
gpn = fieldnames(gp);

for gi = 1:numel(e1)

% for gi = 1:numel(gp.Color)
    for gpi = 1:numel(gpn)
        e1(gi).(gpn{gpi}) = gp.(gpn{gpi}){gi};
    end
end
% -----