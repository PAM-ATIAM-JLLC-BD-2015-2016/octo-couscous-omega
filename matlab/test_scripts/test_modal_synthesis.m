%% Test script with arbitrary values to check the modal synthesis functions

% clear all
project_path = genpath('../');
addpath(project_path);

plots = false;

%%

string_modes_number = 10;
body_modes_number = 40;
modes_number = body_modes_number + string_modes_number;

[~, ~, string_params] = F_string_model( string_modes_number );

% Efective stiffnesses/masses and Q-factors computation (via measures)

Fs_Hz = 25600;
Y_body_v = load('body_z.mat', 'data_FRF_1');
Y_body_v = Y_body_v.data_FRF_1;
% body_temporal_data = load('parfait_90.mat', 'data');
% body_temporal_data = body_temporal_data.data;
body_impulse_response_v = load('body-no_string_E2/mesure_z1.mat', ...
    'data_Temporel_1');
body_impulse_response_v = body_impulse_response_v.data_Temporel_1;
body_impulse_response_v = body_impulse_response_v(:,2).';

% Extract uncoupled natural frequencies and dampings using ESPRIT on the
% body's impulse response.
% Trim the attack transient to avoid listening to the hammer's sound
% and only keep a sample of the whole response to reduce the size
esprit_start_s = 1.1;
esprit_start_n = floor(esprit_start_s * Fs_Hz);
esprit_length_n = 0.2 * Fs_Hz;
esprit_impulse_extract_v = body_impulse_response_v( ...
        esprit_start_n:esprit_start_n+esprit_length_n-1);

% Search for a lot of modes, then only keep the |body_modes_number| modes
% with greatest amplitude
esprit_search_number = body_modes_number * 10;
[body_natural_frequencies_reduced_v, body_amplitudes_v, ...
        body_dampings_v, ~] = ...
    F_esprit(esprit_impulse_extract_v.', Fs_Hz, esprit_search_number, ...
        esprit_length_n, 2*esprit_search_number);

[~, max_amp_modes_v] = sort(body_amplitudes_v);
max_amp_modes_v = max_amp_modes_v(1:body_modes_number);

body_natural_frequencies_reduced_v = body_natural_frequencies_reduced_v(...
    max_amp_modes_v);
body_dampings_v = body_dampings_v(max_amp_modes_v);

% Convert to the physical parameters needed
body_natural_frequencies_Hz_v = Fs_Hz * body_natural_frequencies_reduced_v;
body_dampings_v = abs(body_dampings_v);

[ effective_masses_v ] = F_compute_effective_masses_v( ...
    Y_body_v/max(abs(Y_body_v)), Fs_Hz, ...
    body_natural_frequencies_Hz_v, body_dampings_v);
effective_stiffnesses_v = ...
    effective_masses_v .* body_natural_frequencies_Hz_v.^2;
% cf. formula (6.13) Arthur Paté's PhD
body_q_factors_v = ( 2*pi* body_natural_frequencies_Hz_v ./ ...
    (eps + 2*body_dampings_v));
% body_q_factors_v = ( 1 ./ (eps + 2*body_dampings_v));

% Temporary arbitrary values
% effective_masses_v = linspace(1, 40, body_modes_number).' * 10^-2;
% effective_stiffnesses_v = effective_masses_v .* ...
%     (linspace(1, 5, body_modes_number).').^2;
% body_q_factors_v = linspace(1, 10, body_modes_number).' * 10;

% 3500, value given by Woodhouse A, constant Q-factor model for the string
string_q_factors_v = ones(string_modes_number,1) * 3500;

%%
% TODO : replace with ESPRIT frequency extraction for _isolated_ string
% and body + effective_masses computation for the body modes.

%% System matrices computation
[ mass_m ] = F_compute_mass_m( ...
    string_modes_number, body_modes_number, ...
    string_params.string_length, string_params.string_linear_mass, ...
    effective_masses_v );

[ stiffness_m ] = F_compute_stiffness_m( ...
    string_modes_number, body_modes_number, ...
    string_params.string_bending_stiffness, ...
    string_params.string_length, string_params.string_tension, ...
    effective_stiffnesses_v );

[ dissipation_m ] = F_compute_dissipation_m( ...
    string_modes_number, ...
    string_params.string_linear_mass, string_params.string_tension, ...
    effective_stiffnesses_v, effective_masses_v, ...
    body_q_factors_v, string_q_factors_v );

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
[ modes_m, complex_natural_frequencies_v ] = ...
    F_compute_modes_m( dissipation_m, mass_m, stiffness_m);

%% Mode shapes plot
% plots = true;
if plots
    x_length = 10000;
    mode_sums_m = zeros(x_length,modes_number);
    acc_v = zeros(1,x_length);
    for i=1:modes_number
        mode_shape_v = modes_m(1:string_modes_number,i);
        mode_sum_v = F_compute_mode_sum_v(...
            string_modes_number, string_params.string_length, ...
            x_length, mode_shape_v);
        plot(mode_sum_v);
        mode_sums_m(:,i) = mode_sum_v;
        acc_v = acc_v + mode_sum_v;
        pause(0.02);
    end
    plot(acc_v);
end

%% Initial condition definition

% initial_excitation_v = [1, 1, zeros(1, string_modes_number-2), ...
%     1, 1, zeros(1,body_modes_number-2)].';
% initial_excitation_v = [linspace(1,1000,string_modes_number).' / 1000 ;
%     ones(body_modes_number,1) * 0.2];

static_height_body = 0;
excitation_width = 0.01; % 0.01;  % 1cm wide finger
initial_height = 0.01; % string_params.initial_height

initial_excitation_v = F_compute_initial_excitation_v( ...
    string_modes_number, body_modes_number, ...
    string_params.string_length, string_params.x_excitation, ...
    excitation_width, ...
    static_height_body, initial_height, ...    
    modes_m );

%% Resynthesis
duration_s = 30;
Fs_Hz = 22050;

[ modal_synthesis_v ] = F_modal_synth( ...
    string_params.x_listening, initial_excitation_v,   ...
    string_modes_number, body_modes_number, ...
    string_params.string_length/10, ...
    modes_m, complex_natural_frequencies_v, ...
    mass_m, ...
    duration_s, Fs_Hz );

%% Derivate to yield speed instead of position
duration_n = length(modal_synthesis_v);
time_v = linspace(0, duration_s, duration_n);
dt_v = diff(time_v);
d_modal_synthesis_v = diff(modal_synthesis_v);
speed_synthesis_v = d_modal_synthesis_v ./ dt_v;

%%
figure
subplot(1,2,1)
dt_s = length(modal_synthesis_v) / duration_s;
time_s_v = (0:length(modal_synthesis_v)-1) * dt_s;
plot(time_s_v, real(modal_synthesis_v)/max(abs(real(modal_synthesis_v))));

subplot(1,2,2)
N_fft = 2^12;
modal_synthesis_fft_v = fft(modal_synthesis_v(200:N_fft/4), N_fft);
dF_Hz = Fs_Hz/N_fft;
fft_freqs_Hz_v = (0:N_fft-1)*dF_Hz;
plot(fft_freqs_Hz_v(1:end/2), ...
    db(modal_synthesis_fft_v(1:end/2)/max(abs(modal_synthesis_fft_v(1:end/2)))));