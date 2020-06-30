function [MWTSet] = MWTSetUp_OutputFolder(MWTSet)
display ' ';
display 'Name your analysis output folder';
name = [char(MWTSet.AnalysisName),'_',generatetimestamp,'_',input(': ','s')];
cd(MWTSet.pSave);
mkdir(name);
MWTSet.pSaveA = [MWTSet.pSave,'/',name];