function chs_out = merge(chs_list)
settings_fields = {'Ka', 'V'};
for i = 1:length(settings_fields)
    field_name = settings_fields{i};
    for j = 2:length(chs_list)
        if ~isstruct(chs_list(1).(field_name))
            assert(sum(chs_list(j).(field_name) == chs_list(1).(field_name)) == length(chs_list(1).(field_name)));
        end
        chs_out.(field_name) = chs_list(1).(field_name);
    end
end

data_fields = {'PUPE', 'n_CRC', 'n_exp'};

for i = 1:length(data_fields)
    field_name = data_fields{i};
    
    field_sum = sum([chs_list.(field_name)], 2);
    chs_out.(field_name) = field_sum;
end
end
