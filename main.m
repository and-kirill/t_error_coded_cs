% Highest priority
simulate_cs_rcb (15, 1);
simulate_cs_linear(15, 1, 2^10);
simulate_cs_capacity();
simulate_cs_converse();
list_dependency;

simulate_cs_rs;

simulate_cs_rcb (15, 1, true); % AWGN
simulate_cs_rcb (10, 1);

% Lower priority
simulate_cs_rcb (10, 1, true); % AWGN
simulate_cs_rcb (10, 8);
simulate_cs_rcb (15, 8);
