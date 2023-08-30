% Convert raw slot results to PUPE series
function [P_e, K0] = file2pupe(sys_params, results, t)

cache = load_cache(sys_params, results, t);

n_points = length(results.snr_range);
n_experiments = [results.stats.n_exp];

P_e = zeros(1, n_points);
K0 = zeros(1, n_points);

for i = 1:n_points
    if cache.n_experiments(i) ~= n_experiments(i)
        [P_e(i), K0(i)] = get_min_pupe(sys_params, results.stats(i), t);
    else
        P_e(i) = cache.P_e(i);
        K0(i) = cache.K0(i);
    end
end

if strcmp(sys_params.bound, 'linear') && sum(cache.n_experiments ~= n_experiments) > 0
    fprintf('Updated cache for Ka = %d, V = %d, t = %d\n', results.stats(1).Ka, results.stats(1).V, t);
    save_cache(sys_params, results, t, P_e, K0, n_experiments);
end

end


%%%%%%%%%%%%%%%%%%%%%%%% Cache for the linear bound %%%%%%%%%%%%%%%%%%%%%%%
function filename = get_cache_filename(sys_params, results, t)
assert(strcmp(sys_params.bound, 'linear'));

dir_suffix = sprintf('%s_%ld_cache', sys_params.bound, sys_params.max_paths);
source_dir = get_directory(sys_params, dir_suffix);

if ~isfolder(source_dir)
    mkdir(source_dir);
end

assert(length(unique([results.stats.Ka])) == 1);
assert(length(unique([results.stats.V])) == 1);
Ka = results.stats(1).Ka;
V = results.stats(1).V;

filename_template = '%s/pupe_Ka_%d_V%d_t%d.mat';
filename = sprintf(filename_template, source_dir, Ka, V, t);
end


function cache = load_cache(sys_params, results, t)
cache.n_experiments = nan(1, length(results.snr_range));

if ~strcmp(sys_params.bound, 'linear')
    % No need to load the cache
    return;
end
cache_file = get_cache_filename(sys_params, results, t);
if ~isfile(cache_file)
    return;
end
load(cache_file, 'cache');
end


function save_cache(sys_params, results, t, P_e, K0, n_experiments)
if ~strcmp(sys_params.bound, 'linear')
    % No need to save the cache
    return;
end

cache.n_experiments = n_experiments;
cache.P_e = P_e;
cache.K0 = K0;

cache_file = get_cache_filename(sys_params, results, t);
save(cache_file, 'cache');
end
