function simulator_demo()
sim_parameters = simulator.sim_parameters_default();
avg_delay = 0.001;
experiment_func = @(x) simple_experiment_function(x, sim_parameters, avg_delay);
sim_output_file = 'test.mat';
simulator.simulate(experiment_func, sim_parameters, sim_output_file);
simulator.postproc_file(sim_output_file, 'test.txt', 'out_fer');
end


% Simple expperinent function to valida the simulaion routines
function chs = simple_experiment_function(sigma_noise, sim_params, avg_delay)
bps = 2; % QPSK channel
n = 100;
t = 15; % The number of errors that can be corrected
cwd = randi([0, 1], 1, n);

[llr_in, symb_tx, symb_rx] = awgn_channel.awgn_qam_channel(cwd, bps, sigma_noise);

cwd_hat_channel = llr_in < 0;
if sum(cwd_hat_channel ~= cwd) <= t
    cwd_hat = cwd;
else
    cwd_hat = cwd_hat_channel;
end
% Construct output
chs = sim_params.channel_stats.empty();

chs.in_ber = mean((llr_in < 0) ~= cwd);
chs.in_ser = mean(symb_tx ~= symb_rx);
chs.out_ber = mean(cwd ~= cwd_hat);
chs.out_fer = sum(cwd_hat~= cwd) ~= 0;
chs.n_exp = 1;
% Apply random delay
pause(exprnd(avg_delay));
end
