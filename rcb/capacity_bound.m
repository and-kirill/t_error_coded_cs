function [P_m, P_f] = capacity_bound(sys_params, Ka, V, t, p_m, p_f)
P_f = 0;
Q = 2^sys_params.ks;

R_target = sys_params.k / sys_params.n;
R_iu = (cap_bound_get(Q, Ka, p_f, p_m) / Ka) * (V  / sys_params.n);
P_m = sys_params.p_e * R_target / R_iu;
assert(P_m > 0);
end
