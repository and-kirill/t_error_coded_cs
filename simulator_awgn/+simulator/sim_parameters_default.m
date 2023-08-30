function sim_parameters = sim_parameters_default()
% Create default simulation prameters . Use this function as a reference

% Simulation stop criterion
sim_parameters.max_errors      =   100; % Maximum error count
sim_parameters.max_experiments =  1e10; % Maximum number of experiments  
sim_parameters.min_error_prob   = 1e-4; % Minimum error probability

% Define the SNR range for the simulations
sim_parameters.snr_db_min      =   -10;
sim_parameters.snr_db_max      =    10;
sim_parameters.snr_db_step     =   0.1;

% Parallel setup
sim_parameters.is_parallel     =  true;
sim_parameters.n_workers       =     6;
sim_parameters.batch_size      =  1000; % Batch size for parallel pool

% Channel statistics processing functions (all members below are mandatory)
sim_parameters.channel_stats.empty       = @channel_stats.empty;
sim_parameters.channel_stats.merge       = @channel_stats.merge;
sim_parameters.channel_stats.print       = @channel_stats.print;
sim_parameters.channel_stats.error_count = @channel_stats.error_count;
sim_parameters.channel_stats.error_prob  = @channel_stats.error_prob;
sim_parameters.channel_stats.stop        = @channel_stats.stop;
end
