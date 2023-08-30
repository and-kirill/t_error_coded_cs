function [p_m, p_f] = get_slot_performance(sys_params, Ka, K0, V, ebno_db)
% Load RAW data
file_list = get_file_list(sys_params, Ka, V);
n_exp = [file_list.results.stats.n_exp];
snr_range = file_list.results.snr_range(n_exp > 0);
p_m = [file_list.results.stats.p_m];
p_f = [file_list.results.stats.p_f];
p_f = p_f(K0, n_exp > 0) ./ n_exp(n_exp > 0);
p_m = p_m(K0, n_exp > 0) ./ n_exp(n_exp > 0);

snr_db = ebno_db + 10 * log10(sys_params.k / sys_params.n);

% Prepare data near requested point
snr_step = 2; % dB
filter = logical((snr_range > snr_db - snr_step) .* (snr_range < snr_db + snr_step));
p_m = p_m(filter);
p_f = p_f(filter);
snr_range = snr_range(filter);

% Fit
p_m = do_get_value(snr_range, p_m, snr_db);
p_f = do_get_value(snr_range, p_f, snr_db);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AUX %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function p_e = do_get_value(snr_range, p_e_series, snr_requested)
max_degree = 3;
p_e = fit_error_rate(snr_range, p_e_series, snr_requested, max_degree);
end