function [namepass] = validateletter(name,numberofletter,errormessage)
namepass = name;
[t1,nametest] = regexp(name,'[a-zA-Z]','start','match');
    if isempty(t1) ==1 || isequal(size(t1,2),numberofletter)==0;
        error(errormessage,numberofletter);
        namepass = [];
    end
end
    