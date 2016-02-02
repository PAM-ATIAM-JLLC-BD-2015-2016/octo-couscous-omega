
function Z_string = F_compute_z_string( string_params, omega_rad_v )

string_modes_number = length( string_params.loss_factors_v );

T       = string_params.tension;
L       = string_params.length;
W_m     = repmat(omega_rad_v, string_modes_number, 1);

Wn_v    = string_params.natural_frequencies_rad_v;
etan_v  = string_params.loss_factors_v;

Wn_m    = repmat(Wn_v.', 1, length(omega_rad_v));
etan_m  = repmat(etan_v.', 1, length(omega_rad_v));

temp1   = 1./ ( W_m - Wn_m.*(1+1i*etan_m/2));
temp2   = 1./ ( W_m + Wn_m.*(1-1i*etan_m/2));

Z_string = -1i*T/L * ( 1./omega_rad_v + sum(temp1+temp2) );

end