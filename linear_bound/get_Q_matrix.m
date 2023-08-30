function Q = get_Q_matrix(sys_params, Ka, V, t, p_m, p_f)
Q = zeros(V, V);
for v = 1:V
    for si = 1:v
        Q(v, si) = get_Q(si - 1, v, t, p_m, p_f, sys_params, Ka);
    end
end
end


function Q = get_Q(si, V, t, p_m, p_f, sys_params, Ka)
% si  -- slot index, running from 0 to the slot count
% V   -- total slot count
% t   -- the number of errors for the outer code to correct
% p_m -- inner code missed detection probability
% p_f -- inner code false detection probability
Q = 0;
QI = 2^sys_params.ks; % Inner codebook size (Q slot)
p1 = min(1, p_m * Ka / QI + ( 1 - 1 / QI) * (1 - p_f));
p2 = min(1, (1 - p_m) * Ka / QI + ( 1 - 1 / QI) * p_f);

for i = 0:min(t, si)
    temp = sys_params.cnk(si + 1, i + 1) * (p_m)^i * (1 - p_m)^(si - i);
    for j = 0:min(t - i, V - si)
        % Use cache for nchoosek function (original nchoosek() takes a
        % significant percentage in the resulting profile
        Q = Q + ...
            temp * sys_params.cnk(V - si + 1, j + 1) ...
            * p1^j * p2^(V - si - j);
    end
end
end