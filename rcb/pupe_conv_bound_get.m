function pupe_bound = pupe_conv_bound_get(n, R, Q, Ka, L, p0to1, p1to0)

M = Q^(R*n);
cap_bound = cap_bound_get(Q, Ka, p0to1, p1to0);

pupe_bound = (Ka*R*log2(Q) - cap_bound - Ka/n*(1 + log2(L)))/(Ka*R*log2(Q) + Ka/n*log2(1/L - 1/M));

end

