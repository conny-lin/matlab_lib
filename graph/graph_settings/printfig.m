function printfig(savename,pSave,varargin)
%% designed to print publishable grade graphs

%% default
ext = 'pdf';
dpi = 300;
w = 3;
h = 3;
closefig = 1;
version = 1;
% process varargin
vararginProcessor

%% 

%% print
h1 = gcf;
cd(pSave); 

switch version
    case 1
        set(h1,'PaperUnits','inches','PaperPosition',[0 0 w h]);
        set(h1,'Units','inches');
        h1.Position(3:4) = [w h];
        h1.PaperSize = [w h];
%         set(h1,'PaperPosition','-bestfit');
%         set(h1,'PaperPositionMode','auto')
%         print(savename,['-d',ext],['-r',num2str(dpi)],'-bestfit'); 
        print(savename,['-d',ext],['-r',num2str(dpi)],'-fillpage'); 

    
    case 2
        h1.PaperUnits = 'inches';
        h1.Units = 'inches';
        h1.PaperSize = [w h];
        h1.PaperPosition = [0 0 h1.PaperSize];
        h1.Position = [0 0 h1.PaperSize];
%         print(savename,['-d',ext],['-r',num2str(dpi)],'-fillpage'); 
        print(savename,['-d',ext],['-r',num2str(dpi)],'-bestfit'); 

    case 3 % fille to the edge
        h1.Units = 'inches';
        h1.PaperUnits = 'inches';
        h1.PaperSize = [w h];
        h1 = fillpage(h1);
        
%         h1.PaperPosition = [0 0 w h];
%         h1.Position = [0 0 w h];
%         h1.OuterPosition = h1.Position;
        print(savename,['-d',ext],['-r',num2str(dpi)],'-fillpage'); 

  
end

%%


if closefig
    close;
end

