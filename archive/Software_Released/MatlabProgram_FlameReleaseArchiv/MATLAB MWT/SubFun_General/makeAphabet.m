function [alphabet] = makeAphabet
a1 = ['a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o'];
a2 = ['p' 'q' 'r' 's' 't' 'u' 'v' 'w' 'x' 'y' 'z'];
alphabet = [a1 a2];
alphabet = cellstr(alphabet');