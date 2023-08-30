function s = print(chs)
experiment_count_str = 'n_exp';
assert(isfield(chs, experiment_count_str), 'Missing experiment count field.');
n_experiments = chs.(experiment_count_str);
all_fields = fieldnames(chs);
s = sprintf('#%1.3e, ', n_experiments);
for i = 1:length(all_fields)
    field_name = all_fields{i};
    if strcmp(field_name, experiment_count_str)
        continue;
    end
    if n_experiments > 0
        val = sum(chs.(field_name)) / n_experiments;
    else
        val = 0;
    end
    s = [s, sprintf('%s: %1.3e. ', field_name_str(field_name), val)];
end
end


function s = field_name_str(field_name)
if strcmp(field_name, 'in_ber')
    s = 'IN BER';
elseif strcmp(field_name, 'in_ser')
    s = 'IN SER';
elseif strcmp(field_name, 'out_ber')
    s = 'OUT BER';
elseif strcmp(field_name, 'out_fer')
    s = 'FER';
else
    error('Unknown field type: %s', field_name);
end
end