
function H_string = F_compute_h_string( string_params, string_modes_number, omega_rad_v )

x = string_params.x_excitation;
n = 1:string_modes_number;
c = string_params.celerity;
L = string_params.string_length;
B = string_params.string_bending_stiffness;
T = string_params.string_tension;
eta_v = string_params.string_dampings;

% Introduction de d?viations par rapport au mod?le id?al 
temp1_v = n.' * pi * c/L ...
    .* ( 1 + B*(n.').^2 ) .* ( 1 + 1i*eta_v.'/2 );

% Equation (31) de Woodhouse (a)
eta_m   = repmat(string_params.string_dampings.', 1, length(omega_rad_v));
Wn_m    = repmat(temp1_v, 1, length(omega_rad_v));
W_m     = repmat(omega_rad_v, string_modes_number, 1);
power_m = repmat((-1).^n.', 1, length(omega_rad_v));

temp = power_m ./ ( W_m - Wn_m );

H_string = x/L + (c/L)*sin(omega_rad_v*x/c) .* sum(temp);

end