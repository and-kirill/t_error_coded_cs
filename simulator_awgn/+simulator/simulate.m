function [] = simulate(experiment_func, sim_params, output_filename, snr_range)
if nargin == 3
    snr_range = [sim_params.snr_db_min, sim_params.snr_db_max];
end
% Shuffle random number generator
rng shuffle;

if ~isfile(output_filename)
    results = generate_empty_output(sim_params);
else
    load(output_filename, 'results');
end

if sim_params.is_parallel
    p = gcp('nocreate');
    if isempty(p)
        parpool(sim_params.n_workers);
    end
end

for i = 1:length(results.snr_range)
    % Loop over snr
    snr_db = results.snr_range(i);
    if snr_db < min(snr_range) || snr_db > max(snr_range)
        fprintf('Custom SNR range, skip the SNR %2.2f\n', snr_db);
        continue;
    elseif snr_db > sim_params.snr_db_max
        continue;
    end
    print_simulator_info(sim_params, snr_db, results.stats(i));
    % Run simulations
    n_batches = 0;
    while ~sim_params.channel_stats.stop(results.stats(i), sim_params)
        tic;
        batch_stats = simulate_single_batch(snr_db, experiment_func, sim_params);
        dt = toc;
        results.stats(i) = sim_params.channel_stats.merge([results.stats(i), batch_stats]);
        n_batches = n_batches + 1;
        save_results(results, i, sim_params, output_filename);
        print_simulator_info(sim_params, snr_db, results.stats(i), dt);
    end
    if mod(i, 10) == 0
        fprintf('Output filename: %s\n', output_filename);
    end
    if sim_params.channel_stats.error_prob(results.stats(i)) < sim_params.min_error_prob
        break;
    end
end
fprintf('Simulation complete.\n');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AUX %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function results = generate_empty_output(sim_params)
snr_range = sim_params.snr_db_min:sim_params.snr_db_step:sim_params.snr_db_max;
results.snr_range = snr_range;
results.stats = repmat(sim_params.channel_stats.empty(), size(snr_range));
end


function chs = simulate_single_batch(snr_db, experiment_func, sim_params)
sigma_noise = awgn_channel.snr_to_sigma(snr_db);

batch_stats = repmat(sim_params.channel_stats.empty(), 1, sim_params.batch_size);
if sim_params.is_parallel
    parfor i = 1:sim_params.batch_size
        batch_stats(i) =  experiment_func(sigma_noise);
    end
else
    for i = 1:sim_params.batch_size
        batch_stats(i) =  experiment_func(sigma_noise);
    end
end

chs = sim_params.channel_stats.merge(batch_stats);
end


function save_results(results, index, sim_params, output_filename)
persistent last_save_time;
if isempty(last_save_time)
    last_save_time = datetime();
end
min_save_period = 30; % Seconds
current_time = datetime();
stop_cond = sim_params.channel_stats.stop(results.stats(index), sim_params);
if seconds(current_time - last_save_time) < min_save_period && ~stop_cond
    return;
end
last_save_time = current_time;
save(output_filename, 'results');
end


function print_simulator_info(sim_params, snr_db, chs, dt)
persistent last_output_length;
if isempty(last_output_length)
    last_output_length = 0;
end
n_errors = sim_params.channel_stats.error_count(chs);

if nargin == 4
    timing_substring = sprintf(', %2.3f s/batch.', dt);
else
    timing_substring = '.';
    last_output_length = 0;
end

% Reset previous output
if last_output_length > 0
    fprintf(repmat('\b', 1, last_output_length));
end

last_output_length = fprintf('SNR: %2.2f dB, %s %d/%d Errors%s', ...
    snr_db, ...
    sim_params.channel_stats.print(chs), ...
    n_errors, sim_params.max_errors, ...
    timing_substring ...
    );
if sim_params.channel_stats.stop(chs, sim_params)
    fprintf('\n');
    last_output_length = 0;
end

end
