function do_simulate_rs(sys_params, Ka, V, kx, snr_range)
output_filename = get_output_file(sys_params,  Ka, V, kx);
% Perform sanity checks
if kx < 1 || kx >= sys_params.ks
    fprintf('Skip prefix size of size %d\n', kx);
    return;
end

if V >= 2^(sys_params.ks - kx)
    fprintf('kx = %d, V = %d. The RS length can not be higher than Q_rs. Skip\n', kx, V);
    return;
end

if (sys_params.ks - kx) * V <= sys_params.k
    fprintf('Insufficient slot count.skip...\n');
    return;
end

sim_params = simulator.sim_parameters_default();

sim_params.snr_db_min      = sys_params.snr_db_min;
sim_params.snr_db_max      = sys_params.snr_db_max;

sim_params.min_error_prob  =  5e-2;
sim_params.max_experiments =   1e5;
sim_params.snr_db_step     =  0.25;
sim_params.batch_size      =   240;
sim_params.n_workers       =     8;

sim_params.channel_stats.empty =       @(x) rs_stats.empty(sys_params, Ka, V);
sim_params.channel_stats.merge =       @rs_stats.merge;
sim_params.channel_stats.print =       @rs_stats.print;
sim_params.channel_stats.stop  =       @rs_stats.stop;
sim_params.channel_stats.error_count = @rs_stats.error_count;
sim_params.channel_stats.error_prob =  @rs_stats.error_prob;


experiment_func = @(x) rs_single_run(x, sys_params, Ka, V, kx);

if nargin == 4
    snr_range = [sim_params.snr_db_min, sim_params.snr_db_max];
end

simulator.simulate(experiment_func, sim_params, output_filename, snr_range);
end


% File system processing routines
function filename = get_output_file(sys_params,  Ka, V, kx)
directory = get_directory(sys_params, 'RS');
filename = sprintf('%s/rs_Ka_%d_V%d_kx%d.mat', directory, Ka, V, kx);
end

