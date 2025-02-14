%% Test script checking the modal synthesis functions

clear all
project_path = genpath('../');
addpath(project_path);

plots = false;

%% String and body parameters definition
close all

string_name = 'E4';

string_modes_number = 40;
% Only consider low-frequency body modes, since the high modal-density
% in the higher frequency makes the use of ESPRIT very unstable,
% Up to 1500Hz there are about 15 body modes
body_modes_number = 15;
modes_number = body_modes_number + string_modes_number;

% String parameters loading and computation
[ string_params ] = F_compute_full_string_parameters( ...
    string_name, string_modes_number );
string_q_factors_v = (1 ./ string_params.loss_factors_v).';

% 3500, value given by Woodhouse A, constant Q-factor model for the string
% string_q_factors_v = ones(string_modes_number,1) * 3500;

% Effective stiffnesses/masses and Q-factors computation (via measures)
Fs_Hz = 25600;

measure_filename = ['body-no_string_', string_name, ...
    '/mesure_z3.mat'];
measure_struct = load(measure_filename, 'data_Temporel_1', ...
    'data_FRF_1');
body_impulse_response_v = measure_struct.data_Temporel_1;
body_impulse_response_v = body_impulse_response_v(:,2).';

Y_body_v = measure_struct.data_FRF_1;

% Extract uncoupled natural frequencies and dampings using ESPRIT on the
% body's impulse response.
% Trim the attack transient to avoid listening to the hammer's sound
% and only keep a sample of the whole response to reduce the size
esprit_start_s = 0.025;
esprit_start_n = floor(esprit_start_s * Fs_Hz);
esprit_length_n = 0.4 * Fs_Hz;
esprit_impulse_extract_v = body_impulse_response_v( ...
        esprit_start_n:esprit_start_n+esprit_length_n-1).';

% Search for a lot of modes, then only keep the |body_modes_number| modes
% with greatest amplitude
esprit_search_number = min(body_modes_number * 10, 512);  % Limit size
esprit_full_space_dim = 4 * esprit_search_number;
only_damped_exponentials_b = true;

[ body_dampings_v, body_natural_frequencies_reduced_v ] = ...
    F_esprit(esprit_impulse_extract_v, esprit_full_space_dim, ...
        esprit_search_number, only_damped_exponentials_b);

% Only keep body modes above 90Hz and below 1500Hz
% (The first mode is none to be above 100Hz and Woodhouse notices that
% above 1500Hz, the modes have a dense statistical distribution,
% thus making the modal analysis very unstable).
body_min_frequency_reduced = 80 / Fs_Hz; % 90 / Fs_Hz;
body_max_frequency_reduced = 1000 / Fs_Hz; % 1500 / Fs_Hz;
body_dampings_v = body_dampings_v(...
        body_natural_frequencies_reduced_v > body_min_frequency_reduced & ...
        body_natural_frequencies_reduced_v < body_max_frequency_reduced);
body_natural_frequencies_reduced_v = ...
    body_natural_frequencies_reduced_v(...
        body_natural_frequencies_reduced_v > body_min_frequency_reduced & ...
        body_natural_frequencies_reduced_v < body_max_frequency_reduced);
body_modes_number = min(body_modes_number, length(body_dampings_v));
modes_number = body_modes_number + string_modes_number;

[body_amplitudes_v, ~] = F_least_squares(esprit_impulse_extract_v, ...
    body_dampings_v, body_natural_frequencies_reduced_v);

% [ body_natural_frequencies_reduced_v, body_amplitudes_v, ...
%     body_dampings_v, ~ ] = F_esprit_bis(esprit_impulse_extract_v, ...
%         esprit_search_number, esprit_length_n, esprit_full_space_dim);

[~, max_amp_modes_v] = sort(body_amplitudes_v);
max_amp_modes_v = max_amp_modes_v(1:body_modes_number);

body_natural_frequencies_reduced_v = body_natural_frequencies_reduced_v(...
    max_amp_modes_v);
body_dampings_v = body_dampings_v(max_amp_modes_v);

% Convert to the physical parameters needed
body_natural_frequencies_Hz_v = Fs_Hz * body_natural_frequencies_reduced_v;
body_dampings_v = abs(body_dampings_v);

Y_body_v = Y_body_v/max(abs(Y_body_v));

[ body_effective_masses_v ] = F_compute_body_effective_masses_v( ...
    Y_body_v, Fs_Hz, body_natural_frequencies_Hz_v, body_dampings_v);

body_effective_stiffnesses_v = ...
    body_effective_masses_v .* (2*pi * body_natural_frequencies_Hz_v).^2;

% cf. formula (6.13) Arthur Paté's PhD
body_q_factors_v = body_natural_frequencies_Hz_v/Fs_Hz ./ ...
    (eps + 2*body_dampings_v);

%% System matrices computation
[ mass_m ] = F_compute_mass_m( ...
    string_modes_number, body_modes_number, string_params, ...
    body_effective_masses_v );

[ stiffness_m ] = F_compute_stiffness_m( ...
    string_modes_number, string_params, body_effective_stiffnesses_v );

[ dissipation_m ] = F_compute_dissipation_m( ...
    string_modes_number, string_params, string_q_factors_v, ...
    body_effective_stiffnesses_v, body_effective_masses_v, ...
    body_q_factors_v);

%%
if plots
    imagesc(mass_m); pause;
    imagesc(stiffness_m); pause;
    imagesc(dissipation_m); pause;
end

%% Example values from Newland89, chapter 8, pp 234-235

if false
    string_modes_number = 1;
    body_modes_number = 1;

    I_1 = 3;
    I_2 = 1.5;
    I_3 = 4.5;
    k = 200;
    c = 135/8;

    mass_m = [I_1, 0; 0, I_2];
    dissipation_m = [0, (I_1/I_3)*c; 0, (1+I_2/I_3)*c];
    stiffness_m = [k, -k; -k, k];
end

%% Modes computation
[ coupled_modes_m, coupled_complex_natural_frequencies_v ] = ...
    F_compute_coupled_modes_m( dissipation_m, mass_m, stiffness_m);

% coupled_modes_m = diag([ones(1, string_modes_number), ...
%     (zeros(1, body_modes_number) + eps), ones(1, string_modes_number), ...
%     (zeros(1, body_modes_number) + eps) ]) * coupled_modes_m;

%% Mass-normalize the modes
for mode_n = 1:length(coupled_modes_m)
    mode_time_v = coupled_modes_m(1:end/2, mode_n);
    mode_norm = mode_time_v' * mass_m * mode_time_v;
    coupled_modes_m(:,mode_n) = coupled_modes_m(:,mode_n) / mode_norm;
end

%% Mode shapes plot
plots = false;
if plots
    x_length = 10000;
    mode_sums_m = zeros(x_length,modes_number);
    acc_v = zeros(1,x_length);
    for i=string_modes_number+1:modes_number
        mode_shape_v = coupled_modes_m(1:string_modes_number,i);
        [ mode_sum_v, x_v ] = F_compute_mode_sum_v(...
            string_modes_number, string_params.length, ...
            x_length, mode_shape_v);
        subplot(2,1,1)
        plot(x_v, abs(mode_sum_v));
        mode_sums_m(:,i) = mode_sum_v;
        acc_v = acc_v + mode_sum_v;
        subplot(2,1,2)
        plot(x_v, abs(acc_v));
        pause(0.2);
    end
end
plots = false;
%% Initial condition definition
% Either use the defaults, following the values used during the experiments
% or a modelled finger excitation

plot_excitation_b = false;
excitation_type = 'triangle';

static_height_body = 1e-4;  % 1e-5;  % Fixed by hand...
initial_height = 0.01;

string_params_copy = string_params;

string_params_copy.initial_height = initial_height;

finger_pluck_b = true;
if finger_pluck_b
    excitation_width = 0.01;  % 1cm wide finger
    
    delta_excitation = 0.113;
    x_excitation = string_params.length-delta_excitation;
    x_listening  = string_params.length*(1-0.001);  % *(1 - *2/7);

    string_params_copy.excitation_width = excitation_width;
    string_params_copy.finger_pluck_bx_listening = x_listening;
    string_params_copy.x_excitation = x_excitation;
end

antinode_b = false;
if antinode_b
    excitation_type = 'dirac';
    excitation_width = 0.01;  % 1cm wide finger
   
    x_excitation  = string_params.length*(1 - 1/2);
    x_listening  = string_params.length; % *(1 - 1.3/6.9);

    string_params_copy.excitation_width = excitation_width;
    string_params_copy.x_listening = x_listening;
    string_params_copy.x_excitation = x_excitation;
end
    
initial_excitation_v = F_compute_initial_excitation_v( ...
    string_modes_number, string_params_copy, body_modes_number, ...
    static_height_body, coupled_modes_m, excitation_type, ...
    plot_excitation_b );

% initial_excitation_norm = initial_excitation_v' * mass_m * initial_excitation_v;
% initial_excitation_v = initial_excitation_v / initial_excitation_norm;

if plot_excitation_b
    stem(abs(initial_excitation_v))
end
    
%% Resynthesis
duration_s = 10;
Fs_Hz = 25600;

[ modal_synthesis_v ] = F_modal_synth( duration_s, Fs_Hz, ...
    string_modes_number, body_modes_number, initial_excitation_v, ...
    string_params_copy, coupled_modes_m, ...
    coupled_complex_natural_frequencies_v, mass_m );

%% Derivate to yield speed instead of position
% It is mostly speed that is heard when listening in close field to the
% coupled system, rather than displacement
d = fdesign.differentiator;
Hd = design(d,'equiripple');

speed_synthesis_v = filter(Hd, modal_synthesis_v);

%% Plot synthesized sound

plot_final_b = true;
if plot_final_b
    close all;
%     modal_synthesis_v = modal_synthesis_v(80:end);

    plotted_v = modal_synthesis_v;
    plotted_v = speed_synthesis_v;
    plot_Fs_Hz = Fs_Hz;

%     plotted_v = plotted_v/max(abs(plotted_v));  % Normalize plotted sample

    figure
    subplot(1,2,1)
    dt_s = 1/plot_Fs_Hz;
    time_s_v = (0:length(plotted_v)-1) * dt_s;
    plot(time_s_v, plotted_v);
    xlabel('Time (s)');
    ylabel('Normalized amplitude');
    title('Time-domain signal');

    subplot(1,2,2)
    N_fft = 2^19;
    sample_duration_n = 1 * plot_Fs_Hz;
    sample_start_n = 0.1 * plot_Fs_Hz;
    sample_v = plotted_v(sample_start_n:sample_start_n+sample_duration_n);
    plotted_fft_v = fft(sample_v, N_fft);
    dF_Hz = Fs_Hz/N_fft;
    fft_freqs_Hz_v = (0:N_fft-1)*dF_Hz;
    f_max_plot_Hz = 6000;
    f_max_plot_n = floor(f_max_plot_Hz / dF_Hz);
    plot(fft_freqs_Hz_v(1:f_max_plot_n), ...
        db(plotted_fft_v(1:f_max_plot_n)));
    xlabel('Frequency (Hz)');
    ylabel('Amplitude (dB)');
    title('Spectrum');
end
    
%% Save results (Normalized)

if finger_pluck_b
    file_path = '../sounds/synthesis/modal/finger_excitation/guitar-';
else
    file_path = '../sounds/synthesis/modal/experiment_like/guitar-';
end

filename = [file_path, string_name, '-', ...
    int2str(string_modes_number), '_string_modes-', ...
    int2str(body_modes_number), '_body_modes.wav' ];
audiowrite(filename, ...
    real(modal_synthesis_v)/max(abs(real(modal_synthesis_v))), Fs_Hz);
