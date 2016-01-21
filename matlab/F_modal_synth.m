function [ modal_synthesis_v ] = F_modal_synth( ...
    x_synthesis, initial_excitation_v, ...
    string_modes_number, body_modes_number, ...
    string_length, ...
    modes_m, complex_natural_frequencies_v, ...
    mass_m, ...
    duration_s, Fs_Hz )
%% Modal synthesis
% Synthesize sound based on a modal description of a system.

modes_number = string_modes_number + body_modes_number;

%% Compute modal contributions for each of the natural modes

if false
mode_projections_m = zeros(2*modes_number, modes_number);
for i=1:modes_number
    mode_v = [ zeros(i-1,1) ; 1; zeros(modes_number-i,1) ;
        zeros(modes_number,1)];  % Double-length vector since the new
        % basis in the first-order method has twice the amount of
        % dimensions
    % Matlab recommends left-division instead of using inv()
    mode_projections_m(:,i) = modes_m \ mode_v;
end

% imagesc(mode_projections_m); pause;

string_mode_projections_m = mode_projections_m(:,1:string_modes_number);
body_mode_projections_m = mode_projections_m(:,string_modes_number+1:end);
end

string_mode_projections_m = modes_m(:,1:string_modes_number);
body_mode_projections_m = modes_m(:,string_modes_number+1:end);

%% Modal coefficients
% Alphas are the coefficents for the constraint mode induced by the
% body's movement
alphas_v = sum(body_mode_projections_m,2);

% Betas are the mode-per-mode contributions
betas_v = alphas_v * x_synthesis/string_length + ...
    string_mode_projections_m * ...
    sin((1:string_modes_number).' * pi*x_synthesis/string_length);

modes_inv_m = inv(modes_m);
V_right_inv = modes_inv_m(:,modes_number+1:end);

X_woodhouse = V_right_inv / mass_m;

gammas_v = sum(X_woodhouse(:,string_modes_number+1:end),2);

% duration_n = round(Fs_Hz*duration_s);
dt = 1 / Fs_Hz;
time_s_v = 0:dt:duration_s;
sampled_damped_exponentials_m = exp( ...
    complex_natural_frequencies_v * time_s_v);

% sampled_damped_exponentials_m = exp(-1i * (2*pi*(440-1i)*(1:2*modes_number).') * time_s_v);

modal_synthesis_v = (gammas_v .* betas_v).' * ...
    sampled_damped_exponentials_m;

%% From reference [22], W. (A): D.E. Newland, Mechanical Vibration A. & C.
% Equations (8.109) sqq. in [22]

U_upper_m = modes_m(1:modes_number,:);
U_right_inv_m = V_right_inv;

amplitude_modes_v = [ sin(...
        pi*x_synthesis*(1:string_modes_number) / ...
        string_length) , ... % String modes
    x_synthesis/string_length * ones(1,body_modes_number) % Body modes
    ];

betas_v = alphas_v * x_synthesis/string_length + ...
    string_mode_projections_m * ...
    sin((1:string_modes_number).' * pi*x_synthesis/string_length);


for t_ind = 1:length(time_s_v)
    modal_contributions_v = (U_upper_m * ...
        diag(sampled_damped_exponentials_m(:,t_ind)) * ...
        U_right_inv_m / mass_m) * initial_excitation_v;
    
    modal_synthesis_v(t_ind) = amplitude_modes_v * modal_contributions_v;
end

end