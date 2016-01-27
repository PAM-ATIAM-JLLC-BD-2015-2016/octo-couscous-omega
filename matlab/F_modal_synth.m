function [ modal_synthesis_v ] = F_modal_synth( duration_s, Fs_Hz, ...
    string_modes_number, body_modes_number, ...
    initial_excitation_v, string_params, coupled_modes_m, ...
    coupled_complex_natural_frequencies_v, mass_m )
%% Modal synthesis
% Synthesize sound based on a modal description of a system.

L = string_params.length;
x_listening = string_params.x_listening;

modes_number = string_modes_number + body_modes_number;

%% From reference [22], W. (A): D.E. Newland, Mechanical Vibration A. & C.
% Equations (8.109) sqq. in [22]

U_upper_m = coupled_modes_m(1:modes_number,:);

modes_inv_m = inv(coupled_modes_m);
U_right_inv_m = modes_inv_m(:,modes_number+1:end);

amplitude_modes_v = [ sin(...
        pi*x_listening*(1:string_modes_number) / L) , ... % String modes
    x_listening/L * ones(1,body_modes_number) % Body modes
    ];

%% Initialize damped exponentials
dt = 1 / Fs_Hz;
time_s_v = 0:dt:duration_s;
duration_n = length(time_s_v);
sampled_damped_exponentials_m = exp( ...
    coupled_complex_natural_frequencies_v * time_s_v);

%% Synthesize by projecting the modes
modal_synthesis_v = zeros(1,duration_n);

% Precompute part of the matrix product
left_row_v = amplitude_modes_v * U_upper_m;
right_column_v = (U_right_inv_m / mass_m) * initial_excitation_v;

% To avoid overflows, compute by segments of segment_length_n samples
segment_duration_n = 5000;
segments_number = floor(duration_n/segment_duration_n);

column_renormalization_m = repmat(left_row_v.', 1, segment_duration_n);

    function [ ] = F_compute_add_segment_v(start_segment_n, ...
            segment_duration_n, renormalization_m)
        current_segment_v = (start_segment_n:...
            start_segment_n + segment_duration_n-1);
        exponentials_segment_m = sampled_damped_exponentials_m(:,...
            current_segment_v);
        
        modal_synthesis_segment_v = ...
            (renormalization_m .* exponentials_segment_m).' * ...
            right_column_v;
        modal_synthesis_v(current_segment_v) = modal_synthesis_segment_v.'; 
    end


for segment_n = 0:segments_number-2
    start_n = 1+segment_duration_n*segment_n;
    F_compute_add_segment_v(...
        start_n, segment_duration_n, ...    
        column_renormalization_m);
end

last_segment_start_n = 1+segment_duration_n*(segments_number-1);
last_segment_duration_n = mod(duration_n, segment_duration_n);
last_column_renormalization_m = repmat(left_row_v.', 1, ...
    last_segment_duration_n);
 F_compute_add_segment_v(last_segment_start_n, last_segment_duration_n, ...
     last_column_renormalization_m);

modal_synthesis_v = real(modal_synthesis_v);
 
end