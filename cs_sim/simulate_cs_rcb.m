function simulate_cs_rcb(ks, N_rx, use_awgn)
if nargin == 2
    use_awgn = false;
end

sys_params = sys_params_default(ks, N_rx, use_awgn);
Ka_series = get_Ka_series(sys_params);

do_simulate_cs(sys_params, Ka_series);
postproc(sys_params);
end
