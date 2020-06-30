function makemissfolder(pH,pD,foldername)
if isdir(pD) ==0; 
    mkdir(pH,foldername);
end
