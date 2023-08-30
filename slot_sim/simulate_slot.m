function files_updated = simulate_slot(sys_params, Ka, slot_range, t, snr_range)

sim_params = simulator.sim_parameters_default();

sim_params.snr_db_min = sys_params.snr_db_min;
sim_params.snr_db_max = sys_params.snr_db_max;

if sys_params.fading
    sim_params.min_error_prob =  5e-2;
else
    sim_params.min_error_prob =  2e-2;
end

sim_params.max_experiments    =   1e5;
if sys_params.fading
    sim_params.snr_db_step    =  0.25;
else
    sim_params.snr_db_step    = 0.125;
end
sim_params.batch_size         =   240;
sim_params.n_workers          =     8;

if strcmp(sys_params.bound, 'linear') && t >= 1
    sim_params.max_errors  = 200;
end

sim_params.channel_stats.merge = @(x) mac_stats.merge(x);
sim_params.channel_stats.print = @(x) mac_stats.print(x, sys_params, t);
sim_params.channel_stats.stop  = @mac_stats.stop;
sim_params.channel_stats.error_count = @(x) mac_stats.error_count(x, sys_params, t);
sim_params.channel_stats.error_prob = @(x) mac_stats.error_prob(x, sys_params, t);

if nargin == 4
    snr_range = [sys_params.snr_db_min, sys_params.snr_db_max];
end

files_updated = false; % Check whether any files updated
for V = slot_range
    sim_params.channel_stats.empty = @(x) mac_stats.empty(sys_params, Ka, V);
    output_file = get_output_file(sys_params, Ka, V);
    if isfile(output_file)
        load(output_file, 'results');
        % TODO: backward compatibility, remove in the future!
        if isfield(results.stats, 'sp')
            warning('SP field found... Deleting\n');
            results.stats = rmfield(results.stats, 'sp');
            save(output_file, 'results');
        end
    end

    experiment_func = @(x) slot_single_run(x, Ka, V, sys_params);
    fprintf('Simulate slot Ka = %d, V = %d\n', Ka, V);
    fprintf('Output file: %s\n', output_file);

    if isfile(output_file)
        check_precision(output_file, sim_params);
    end

    time_start = now;
    simulator.simulate(experiment_func, sim_params, output_file, snr_range);
    dir_data = dir(output_file);
    assert(~isempty(dir_data));
    if time_start < dir_data.datenum
        fprintf('File updated, time differene: %1.3e\n', dir_data.datenum - time_start);
        files_updated = true;
    end
end
end


function check_precision(output_file, sim_params)
load(output_file, 'results');
snr_step = results.snr_range(2) - results.snr_range(1);
step_ratio = round(snr_step / sim_params.snr_db_step);
if step_ratio <= 1
    return;
end
assert(snr_step / sim_params.snr_db_step == step_ratio);
fprintf('Precision change required!\n');

new_snr_range = sim_params.snr_db_min:sim_params.snr_db_step:sim_params.snr_db_max;
n_points = length(new_snr_range);
assert(length(intersect(results.snr_range, new_snr_range)) == length(results.snr_range));

stats_old = results.stats;
results.stats = repmat(sim_params.channel_stats.empty(), 1, n_points);
results.stats(1:step_ratio:end) = stats_old;
results.snr_range = new_snr_range;

save(output_file, 'results');
end
