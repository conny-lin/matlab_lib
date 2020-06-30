function deleteMWTfext(pExp,ext)
[~,pf] = getallfileMWTfext(pExp,ext);
for x = 1:numel(pf);
delete(pf{x});
end
end

