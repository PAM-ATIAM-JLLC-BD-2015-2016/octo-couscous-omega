function [ string_natural_frequencies_rad_v ] = ...
    F_compute_string_natural_frequencies_rad_v( string_params, ...
    string_modes_number )
%% String natural frequencies computation via theoretical model

mode_n_v = 1:string_modes_number;
c = string_params.celerity;
L = string_params.length;
B = string_params.bending_stiffness;
T = string_params.tension;

% Equation 30 from Woodhouse (a)
string_natural_frequencies_rad_v = (mode_n_v * pi * c/(L)) .* ...
    ( 1 + (B/(2*T)) .* (mode_n_v*pi/L).^2 );
end