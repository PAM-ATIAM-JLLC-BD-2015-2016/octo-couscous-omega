function [ string_loss_factors_v ] = F_compute_string_loss_factors_v( ...
    string_params, string_modes_number )
%% String loss_factors $\eta$ computation via theoretical model
% Loss factors are the inverses of the Q-factors

% Parameters extraction
modes_n_v = 1:string_modes_number;
L = string_params.length;
B = string_params.bending_stiffness;
T = string_params.tension; 
etaA = string_params.etaA;
etaB = string_params.etaB;
etaF = string_params.etaF;

w_v = string_params.natural_frequencies_rad_v;

% Equation (8) from Woodhouse (b)
string_loss_factors_v = ( T*(etaF+(etaA./w_v)) + B*etaB*(modes_n_v*pi/L).^2 )...
    ./( T + B*(modes_n_v*pi/L).^2 );
end
