function simulate_cs_linear(ks, N_rx, max_paths)
sys_params = sys_params_default(ks, N_rx);
sys_params.bound = 'linear';

Ka_series = get_Ka_series(sys_params);

if nargin == 2
    max_paths = 1024;
end
sys_params.max_paths = max_paths;

do_simulate_cs(sys_params, Ka_series);
postproc(sys_params);
end
