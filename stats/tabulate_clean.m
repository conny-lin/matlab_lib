function a= tabulate_clean(D)

    a = tabulate(D);
    a(:,3) = [];
    a(a(:,2)==0,:) = [];