function [MWTfsncorr] = correctdupgroupcode(MWTfgcode,MWTfsn,mwtnamewogroupcode)
q = 1;
disp(MWTfgcode);
q2 = input('correct all at once(1) or individually (2)? ');
switch q2 
    case 2
        while q ~=0;
        i = 'x';
        while isnumeric(i) ~=1;
            i = input('Enter the index# to fix: '); 
        end
        n = 1;
        while ischar(n) ~=1;
            n = input('Enter the correct group code: ','s');
        end
        MWTfgcode{i,2} = n;
        MWTfgcode{i,3} = 'corr';
        display(MWTfgcode);
        q = input('More to correct (y=1,n=0)? ');
        end
    case 1
        n = [];
        while size(n,1) ~= size(MWTfsn,1);
            n = input('enter group codes for all plates above separated by space:\n','s');
            n = (regexp(n,' ','split'))';
            if size(n,1) == size(MWTfsn,1);
                MWTfgcode(:,2) = n;
            end
        end
end
gc = MWTfgcode;
%% put group code back

[MWTfsncorr] = reasemblemwtname2(MWTfsn(:,1),mwtnamewogroupcode,gc);



