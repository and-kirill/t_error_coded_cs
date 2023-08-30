function simulate_cs_capacity()
sys_params = sys_params_default(15, 1);
sys_params.bound = 'capacity';
Ka_series = get_Ka_series(sys_params);

do_simulate_cs(sys_params, Ka_series);
postproc(sys_params);
end
