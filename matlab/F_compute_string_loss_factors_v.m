function [ string_loss_factors_v ] = F_compute_string_loss_factors_v( ...
    string_params, string_modes_number )
%% String loss_factors $\eta$ computation via theoretical model

% Parameters extraction
n = 1:string_modes_number;
L = string_params.string_length;
B = string_params.string_bending_stiffness;
T = string_params.string_tension; 
etaA = string_params.etaA;
etaB = string_params.etaB;
etaF = string_params.etaF;
w = string_params.string_frequencies;

% Equation (8) from Woodhouse (b)
string_loss_factors_v = ( T*(etaF+(etaA./w)) + B*etaB*(n*pi/L).^2 )...
    ./( T + B*(n*pi/L).^2 );
end