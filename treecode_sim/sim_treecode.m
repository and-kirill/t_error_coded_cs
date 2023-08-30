close all;
clc;
clear;
% Specify the point to optimize
sp = sys_params_default(15, 1);
sp.max_paths = 1024;
sp.bound = 'linear';
Ka = 50;
t = 1;

% Get the optimal point for treecode
V = get_optimal_point(sp, Ka, t);
ebno_db = evaluate_cs_bound(sp, Ka, t);
K0 = get_optimal_K0(sp, Ka, V, t, ebno_db);
[p_m, p_f] = get_slot_performance(sp, Ka, K0, V, ebno_db);


% Get an optimal bit allocation
Q = get_Q_matrix(sp, Ka, V, t, p_m, p_f);
[P_f, path_profile, inf_bits_pattern] = greedy_bits_allocation(sp, Ka, V, Q);
P_m = pupe_get(V, t, p_m);

% Generate the coding scheme
code_params.n = sp.n;
code_params.V = V;
code_params.t = t;
code_params.ks = sp.ks;
code_params.inf_bits = inf_bits_pattern;
code_params.G = treecode_G(code_params, sp);

% Run single decoding procedure:
[iwd, cwd] = treecode_encode(Ka, code_params, sp);
frame_output_raw = decode_inner_code(code_params, sp, cwd, p_m, p_f);
cwd_list = decode_outer_code(sp, code_params, frame_output_raw, cwd);