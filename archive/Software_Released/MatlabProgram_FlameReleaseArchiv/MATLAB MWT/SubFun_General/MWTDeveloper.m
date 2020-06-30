function MWTDeveloper(p,pFun,id)
switch id
    case 'ungroupRC'
        pBet = p;
        ungroupRC(pBet,pFun);
        display('ungroup done');
    otherwise
        error('no such id exist');
end
end