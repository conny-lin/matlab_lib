function CreateMWTPortal(p)
Grad = input('Are you a graduate student (y=1,n=0): ');
GradName = input('Your full name:  ','s');
GradName = regexprep(GradName,' ','_');
cd(p);
mkdir('MultiWormTrackerPortal'); % create MultiWormTrackerPortal
pPortal = strcat(p,'/','MultiWormTrackerPortal'); 
cd(pPortal);
mkdir('MWT_Raw_Data');
mkdir('MWT_Experimenter_Folders');
mkdir('MWT_Programs');
pPF = strcat(pPortal,'/','MWT_Experimenter_Folders'); 
pGrad = strcat(pPF,'/',GradName); % identify gradaute student folder
if isdir(pGrad) ==0;
    mkdir(pGrad);
end
cd(pGrad);
mkdir('MWT_RawDataReport'); % create pRawGraduateStudent
mkdir('MWT_AnalysisReport'); % create pAnalysisReport to Graduate student
display('MWT Portal creation completed.');
end