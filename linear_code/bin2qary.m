function cwd_qary = bin2qary(cwd, log2Q)
[Ka, N] = size(cwd);
V = N / log2Q;
assert(round(V) == V, 'Slot count must be an integer number');
cwd_qary = zeros(V, Ka);

for slot_id = 1:V
    bit_idx = (1:log2Q) + log2Q * (slot_id - 1);
    for user_id = 1:Ka
        cwd_qary(slot_id, user_id) = bi2de(cwd(user_id, bit_idx)) + 1;
    end
end
end