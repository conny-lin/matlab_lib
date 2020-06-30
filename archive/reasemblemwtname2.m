function [MWTfsnresmb] = reasemblemwtname2(MWTf,part1,part2)

Partresmb = cellfun(@strcat,part1,part2,'UniformOutput',0); % reconstruct
MWTfsnresmb = cat(2,MWTf,Partresmb);
end