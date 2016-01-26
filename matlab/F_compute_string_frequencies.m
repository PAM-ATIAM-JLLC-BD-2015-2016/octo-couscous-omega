function string_frequencies_v = F_compute_string_frequencies( ...
    string_params, string_modes_number )
%% String natural frequencies computation via theoretical model

n = 1:string_modes_number;
c = string_params.celerity;
L = string_params.string_length;
B = string_params.string_bending_stiffness;
T = string_params.string_tension;

% Equation 30 from Woodhouse (a)
string_frequencies_v = n * pi * c/L ...
    .* ( 1 + (B/(2*T)) .* (n*pi/L).^2 );

end