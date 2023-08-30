function cap_bound = cap_bound_get(Q, Ka, p_f, p_m)
temp = ((Q - 1) / Q) ^ Ka;
p = (1 - temp) * (1 - p_m) + temp * p_f;
cap_bound = max(0, Q * (bin_h_get(p) - (1 - temp) * bin_h_get(p_m) - temp * bin_h_get(p_f)));
end

