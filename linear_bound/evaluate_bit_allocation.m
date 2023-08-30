function [P_f, P_series] = evaluate_bit_allocation(b, Ka, Q, P_series)
V = length(b); % The number of slots
B = cumsum(b); % Cumulative number of information bits
M = 2.^B;      % Cumulative codebook size

% Update only the last slot, because the greedy bit allocation algorithm
% performs above
P_series(V) = get_P(V - 1, Ka, M);
P_f = sum(Q(V, 1:V) .* P_series(1:V)) * (M(V));
end


function P = get_P(si, Ka, M)
% si  -- slot index, running from 0 to the slot count
% V   -- total slot count
% Ka  -- the number of active users
% M   -- cumulative codebook size
if si == 0
    P = (1 - 1 / M(1))^Ka;
else
    P = (1 - 1 / M(si + 1))^Ka - (1 - 1 / M(si))^Ka;
    % Check precision violation:
    if P == 0
        P = exp(-Ka/M(si + 1)) -  exp(-Ka/M(si));
    end
    if P == 0
        P = -Ka / M(si + 1) + Ka / M(si);
    end
end
end


% A function running full  set of slots is commented below:

% function P_f = evaluate_bit_allocation(b, Ka, Q)
% V = length(b); % The number of slots
% B = cumsum(b); % Cumulative number of information bits
% M = 2.^B;      % Cumulative codebook size
%
% % Calculate P for each slot index
% P = zeros(1, V);
% for j = 0:(V - 1)
%     P(j + 1) = get_P(j, Ka, M);
% end
% P_f = sum(Q(V, 1:V) .* P) * (M(V));
% end
