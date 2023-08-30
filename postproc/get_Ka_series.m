function Ka_series = get_Ka_series(sys_params)
ks = sys_params.ks;
N_rx = sys_params.N_rx;

if strcmp(sys_params.bound, 'capacity') || strcmp(sys_params.bound, 'converse')
    Ka_series = 10:10:650;
    return;
end

if sys_params.fading
    if ks == 10
        if N_rx == 1
            Ka_series = [10:10:200, 205:5:240, 242:2:280];
        elseif N_rx == 8
            Ka_series = [10:10:370, 375:5:440];
        else
            error('Please specify the active users count range for %d antennas', N_rx);
        end
    elseif ks == 15
        if N_rx == 1
            Ka_series = 10:10:550;
        elseif N_rx == 8
            Ka_series = [10, 50:50:500, 520:20:1100];
        else
            error('Please specify the active users count range for %d antennas', N_rx);
        end
    else
        error('Error: %d bits/slot not specified\n', ks);
    end
else
    assert(N_rx == 1, 'Single antenna only for the AWGN');
    if ks == 10
        Ka_series = [10:10:180, 182:2:214];
    elseif ks == 15
        Ka_series = [10:20:200, 210:10:280, 285:5:430];
    end
end
end
