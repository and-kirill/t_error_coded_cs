function sys_params = sys_params_default(ks, N_rx, use_awgn)
% Construct system parameters
% Note that the system performance depends on both list size and the slot
% count. These variables are not stored in the system parameters because
% they are adjustable

if nargin == 2
    use_awgn = false;
end

sys_params.n = 30000;            % The number of channel uses per frame
sys_params.k = 100;              % The number of information bits per frame
sys_params.ks = ks;              % The number of information bits per slot
sys_params.t_max = 5;            % Maximum t parameter for outer code
sys_params.N_rx = N_rx;          % The number of receive antennas ( > 1 only for fading channel)
sys_params.fading = ~use_awgn;   % True: Rayleig, False: AWGN

if sys_params.fading
    sys_params.p_e = 0.1;        % Target PUPE
else
    sys_params.p_e = 0.05;       % Target PUPE
end

sys_params.K0_scale = 2;         % Max list size is K0_scale * Ka

if sys_params.fading
    sys_params.far_rate = 0.01;  % FAR should be less than far_rate * FER
else
    sys_params.far_rate = 1;     % FAR should be less than far_rate * FER
end

% Define the SNR and Eb/N0 simulation/search range for postprocessing
if sys_params.N_rx == 1
    if sys_params.ks == 15 || ~sys_params.fading
        sys_params.snr_db_min = -25;
    else
        sys_params.snr_db_min = -17;
    end
    sys_params.snr_db_max =  18;
elseif sys_params.N_rx == 8
    sys_params.snr_db_min = -30;
    sys_params.snr_db_max =  8;
else
    error('Please specify the SNR range for %d antennas', N_rx);
end

snr2ebno = - 10 * log10(sys_params.k / sys_params.n);

sys_params.ebno_db_min = sys_params.snr_db_min + snr2ebno;
sys_params.ebno_db_max = sys_params.snr_db_max + snr2ebno;

% Bound type. Supported types are:
% - rcb:  random coding bound for the outer code (default)
% - conv: bound for the convolutional outer code
sys_params.bound = 'rcb';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Bits per slot: %d\n', sys_params.ks);
if sys_params.fading
    fprintf('Channel model: RAYLEIGH\n');
else
    fprintf('Channel model: AWGN\n');
end
fprintf('Receiver antenna count: %d\n', sys_params.N_rx);
fprintf('Simulation SNR   range: [%1.3f; %1.3f]\n', sys_params.snr_db_min, sys_params.snr_db_max);
fprintf('Evaluation Eb/N0 range: [%1.3f; %1.3f]\n', sys_params.ebno_db_min, sys_params.ebno_db_max);
if ~sys_params.fading && sys_params.N_rx > 1
    error('Fading is not applicable to the AWGN channel model.');
end

max_slots = 150;
sys_params.cnk = generate_nchoosek(max_slots, sys_params.t_max);
end


function X = generate_nchoosek(max_slots, t_max)
% Generate cache for nchoosek function for linear bound faster evaluation
X = zeros(max_slots + 1, t_max + 1);
for n = 0:100
    for k = 0:min(n, t_max)
        X(n + 1, k + 1) = nchoosek(n, k);
    end
end
end
