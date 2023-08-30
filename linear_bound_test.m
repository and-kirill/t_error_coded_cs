p_m = 0.0391;
p_f = 7.322e-04;
t = 1;
Ka = 50;
sp = sys_params_default(15, 1);
sp.bound = 'linear';
sp.max_paths = 1024;

[P_m, P_f] = evaluate_bit_allocation(sp, [10, 8], Ka, t, p_m, p_f)
[P_m, P_f] = evaluate_bit_allocation(sp, [10, 7], Ka, t, p_m, p_f)
[P_m, P_f] = evaluate_bit_allocation(sp, [10, 0], Ka, t, p_m, p_f)

b = [10, 7, 8, 8, 9, 8, 9, 8, 9, 9, 8, 7, 0, 0];
[P_m, P_f] = evaluate_bit_allocation(sp, b, Ka, t, p_m, p_f)