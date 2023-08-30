function do_simulate_cs(sys_params, Ka_series)
for i = 1:length(Ka_series)
    Ka = Ka_series(i);
    % Propagate optimimum parapeters from the previous point
    if i > 1
        DK = Ka - Ka_series(i - 1);
        propagate_optimal_params(sys_params, Ka_series(i - 1), DK);
    end
    % Propagate optimimum parapeters from the next point
    %if i < length(Ka_series)
    %    DK = Ka - Ka_series(i + 1);
    %    propagate_optimal_params(sys_params, Ka_series(i + 1), DK);
    %end
    simulate_Ka(sys_params, Ka);
end
end
