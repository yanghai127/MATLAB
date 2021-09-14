function [W] = shangquan(P)
    e = -sum(P.*log(P),2)/log(5);
    d = 1-e;
    W = d/sum(d);
end

