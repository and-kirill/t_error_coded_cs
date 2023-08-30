function stop_condition = stop(chs, sim_params)
% Stop by the maximum error count
stop_condition = chs.n_exp >= sim_params.max_experiments;
% Stop by the maximum experiments count
n_errors = sim_params.channel_stats.error_count(chs);
stop_condition = stop_condition || n_errors >= sim_params.max_errors;
end
