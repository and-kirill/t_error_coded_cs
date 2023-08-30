function ebno_db = find_ebno_db(sys_params, snr_range, pupe_range, n_errors)

ebno_db = inf;
if isempty(pupe_range) || min(pupe_range) > sys_params.p_e
    return;
end

% Perform fit of the PUPE as a function of the SNR
% Hardcoded hell begin
max_span   = 12;    % Select subcurve (+/- max_span points)
max_degree = 3;    % Degree of the polynomial fit;
fit_step   = 0.01; % dB
% Hardcoded hell end

id = find(pupe_range < sys_params.p_e, 1);

min_error_count = 100; % Set minimum for error count
idx_fit = intersect(1:length(snr_range), (id - max_span):(id + max_span));
idx_fit = intersect(idx_fit, find(n_errors > min_error_count));
[~, idx_unique] = unique(pupe_range);
idx_fit = intersect(idx_fit, idx_unique);

if isempty(idx_fit)
    return;
end

if length(idx_fit) == 1
    snr_final = snr_range(idx_fit);
elseif length(idx_fit) <= max_degree
    snr_final = interp1(pupe_range(idx_fit), snr_range(idx_fit), sys_params.p_e);
else
    snr_range = snr_range(idx_fit);
    pupe_range = pupe_range(idx_fit);
    fit_snr_range = min(snr_range):fit_step:max(snr_range);
    fit_pupe_range = fit_error_rate(snr_range, pupe_range, fit_snr_range, max_degree);
    fit_snr_range(fit_pupe_range > 2 * sys_params.p_e) = [];
    fit_pupe_range(fit_pupe_range > 2 * sys_params.p_e) = [];
    if length(fit_pupe_range) < 2 % At least two points required for interpolation
        return;
    end
    if min(fit_pupe_range) > sys_params.p_e
        return;
    end
    
    try
        snr_final = interp1(fit_pupe_range, fit_snr_range, sys_params.p_e);
    catch
        snr_final = fit_snr_range(find(fit_pupe_range < sys_params.p_e, 1));
    end
end
ebno_db = snr_final - 10 * log10(sys_params.k / sys_params.n);

end