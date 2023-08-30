filename = 'ach.mat';
if ~isfile(filename)
    Ka_range = 1:1000;
    data.Ka = Ka_range;
    data.ebno_db = repmat(-inf, 1, length(Ka_range));
    save(filename, 'data');
end
load(filename, 'data');
for i = 1:length(data.Ka)
    if ~isinf(data.ebno_db(i))
        continue;
    end
    Ka = data.Ka(i);
    ebno_db = get_ebno_db(Ka);
    fprintf('%d\t%+1.3e\n', Ka, ebno_db);
    data.ebno_db(i) = ebno_db;
    save(filename, 'data');
end


function ebno_db = get_ebno_db(Ka)
target_pupe =       0.05;
ebno_db_min =         -2;
ebno_db_max =         40;
ebno_db_tolerance = 1e-4;

pupe_func = @(x) get_pupe(x, Ka);
% fprintf('Bounding points errors: Left: %1.3e, right: %1.3e\n', ...
%     pupe_func(ebno_db_min), ...
%     pupe_func(ebno_db_max) ...
%     );

while(ebno_db_max - ebno_db_min > ebno_db_tolerance)    
    ebno_db_mid = (ebno_db_min + ebno_db_max) / 2;
    p_e_cur = pupe_func(ebno_db_mid);
    if p_e_cur > target_pupe
        ebno_db_min = ebno_db_mid;
    else
        ebno_db_max = ebno_db_mid;
    end
end
ebno_db = ebno_db_max;
end


function p_e = get_pupe(ebno_db, Ka)
ebno = 10^(ebno_db / 10);
% Extract code prameters
n = 30000;
k = 100;

power = ebno * 2 * k / n;
p_e = min(ach_mac_raw(k, n, power, Ka), 1);
end