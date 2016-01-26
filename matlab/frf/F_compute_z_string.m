
function Z_string = F_compute_z_string( string_params, string_modes_number, omega_rad_v )

T       = string_params.string_tension;
L       = string_params.string_length;
eta_m   = repmat(string_params.string_dampings.', 1, length(omega_rad_v));
Wj_m    = repmat(string_params.string_frequencies.', 1, length(omega_rad_v));
W_m     = repmat(omega_rad_v, string_modes_number, 1);

temp1    = 1./ ( W_m - Wj_m.*(1+1i*eta_m/2));
temp2    = 1./ ( W_m + Wj_m.*(1-1i*eta_m/2));
Z_string = -1i*T/L * ( 1./omega_rad_v + sum(temp1+temp2) );

end