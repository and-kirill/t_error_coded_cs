function chs_out = merge(chs_list)
all_fields = fieldnames(chs_list);
chs_out = struct();
for i = 1:length(all_fields)
    field_name = all_fields{i};
    field_sum = sum([chs_list.(field_name)], 2);
    chs_out.(field_name) = field_sum;
end
end
