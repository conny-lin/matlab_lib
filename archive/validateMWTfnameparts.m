function [MWTfsncorr] = validateMWTfnameparts(MWTfsn)
%% underscore number needs to be validated first
display('Validating MWT names parts...');
MWTfsncorr = MWTfsn;

%% validate nuber of x
[parse,partnumber] = parseby(MWTfsn(:,2),'x')
xnot4 = find(partnumber ~=4);
if isempty(xnot4) ~=0; % if there is some files with more than 4 x
    warning('file structure has too many X');
end


%% get run condition parts
[RCcomp,strain, startcolony,tsfagetemp,runcond,trackercoldategp] = ...
    RCcomponent(MWTfsn);

%% strain
% capitals followed by number
[straincorr,P] = cellfun(@validatestrainname2,strain,'UniformOutput',0); 
% fix individually if not passed

    
%% startcolony \dx\d
[parse,partnumber] = parseby(startcolony,'x');
xnot2 = find(partnumber ~=2);
if isempty(xnot2) ~=0; 
    warning('start colony name is wrong');
end

[message] = gencellfunexpr(parse(:,1),'worm used to syn is not numeric');
[Wns] = cellfun(@validatenamenumeric,parse(:,1),message);
[message] = gencellfunexpr(parse(:,1),'worm used to syn is not numeric');
[Wns] = cellfun(@validatenamenumeric,parse(:,1),message);

%% tsfagetemp

%% runcond

%% trackercolddategp
%%
[gp] = findgroupcodefromRCcomp(trackercoldategp);


%% check trackers-date-group-plate
[tdgp] = gencellfunexpr(trackercoldategp,'[A-Z]\d\d\d\d[a-z][a-z]');
[match,failmatch,P] = findcellrowmatchname(trackercoldategp,tdgp);
if P~=1;
    display('Tracker-date-group-plate code incorrect');
end
%%

%wrongtdgp = cellfun(@isempty,m);

    
 %   i = find(wrongtdgp);
  %  for x = 1:size(i,1);
   %     newname = MWTfsn{i(x,1),2};
    %    q1 = 0;
     %   while q1 ==0;
      %      display(' ');
       %     disp(newname);
        %    newname = input('Please enter correct full name:\n','s');
         %   q1 = input('is this correct (y=1,n=0)? ');
          %  MWTfsncorr{i(x,1),2} = newname;
            
        %end   
    %end
%end

%% change file name
%changeMWTname(pExp,MWTfsn,MWTfsncorr);
%[MWTfsn] = getMWTfdatsamplename('*.set',MWTf,pMWTf); % reload MWTfsn

end