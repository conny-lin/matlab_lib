function b = correct_digitstr(a,digit)

b = cell(numel(a),1);
s = sprintf('''%%.%df''',digit);
for x = 1:numel(a)
   s1 = sprintf(s,a(x));  
   b{x} = regexprep(s1,'['']','');
end



