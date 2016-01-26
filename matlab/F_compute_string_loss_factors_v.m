function [ string_loss_factors_v ] = F_compute_string_loss_factors_v( ...
    string_params, string_modes_number )
%% String loss_factors $\eta$ computation via theoretical model
% Loss factors are the inverses of the Q-factors

% Parameters extraction
n = 1:string_modes_number;
L = string_params.string_length;
B = string_params.string_bending_stiffness;
T = string_params.string_tension; 
etaA = string_params.etaA;
etaB = string_params.etaB;
etaF = string_params.etaF;

w_v = F_compute_string_frequencies_v( string_params, string_modes_number);

% Equation (8) from Woodhouse (b)
string_loss_factors_v = ( T*(etaF+(etaA./w_v)) + B*etaB*(n*pi/L).^2 )...
    ./( T + B*(n*pi/L).^2 );
end
