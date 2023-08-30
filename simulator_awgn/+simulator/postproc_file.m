function postproc_file(filename_in, filename_out, var_name, color)
if nargin == 3
    color = 'r';
end
load(filename_in, 'results');
N = [results.stats.n_exp];
errors_sum = sum([results.stats.(var_name)], 1);
errors = errors_sum ./ N;

var_series = errors(N > 0);
snr_series = results.snr_range(N > 0);
fer_smooth = do_smooth(snr_series, var_series);
% fer_series = 10.^smooth(log10(fer_series));
fid = fopen(filename_out, 'w');
fprintf(fid, 'ESNO FER\n');
for i = 1:length(var_series)
    fprintf(fid, '%2.2f %1.4e\n', snr_series(i), fer_smooth(i));
end
fclose(fid);

% Print gathered statistics
fprintf('Max relative fit error: %1.3e\nError statistics:\n', ...
    max(abs(fer_smooth - var_series) ./ var_series) ...
    );
errors_sum = errors_sum(N > 0)';
for i = 1:10
    target_fer_prv = 10^(-i + 1);
    target_fer_cur = 10^(-i);
    error_sum_at = errors_sum((fer_smooth <= target_fer_prv) & (fer_smooth > target_fer_cur));
    n_errors_at = min(error_sum_at);
    if length(error_sum_at) > 2
        fprintf('  FER %1.3e %d\n', target_fer_cur, n_errors_at);
    end
    
end
semilogy(snr_series, var_series, 'k.-', 'DisplayName', [var_name, ' raw']);
hold on;
semilogy(snr_series, fer_smooth, color, 'DisplayName', [var_name, ' fit']);
grid on;
end

function fer_hat = do_smooth(snr_series, fer_series)
max_order = 6;
smooth_bw = 6;
fer_log = log10(fer_series);
snr_span = max(snr_series) - min(snr_series);
snr_series_normalized = (snr_series - min(snr_series)) / snr_span;
P = polyfit(snr_series_normalized, fer_log, max_order);
fer_log_fit = polyval(P, snr_series_normalized);
log_diff = fer_log - fer_log_fit;
fer_log_hat = fer_log_fit + smooth(log_diff, smooth_bw)';
fer_hat = 10.^fer_log_hat;
fer_hat(fer_hat > 1) = 1;
end
