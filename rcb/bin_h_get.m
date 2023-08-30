function bin_h = bin_h_get(p)
% Check boundary conditions
if p <= 0 || p >= 1
    bin_h = 0;
    return;
end

bin_h = - p*log2(p) - (1-p)*log2(1-p);

end

