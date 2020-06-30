function [B] = MWTfnCorrect(MWTfsn,A,pExp)
changeMWTname(pExp,MWTfsn,[MWTfsn(:,1) A]); % correct file names
[B] = draftMWTfname3('*set',pExp); % reload MWTfsn