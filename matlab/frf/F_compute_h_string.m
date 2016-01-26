
function H_string = F_compute_h_string( string_params, omega_rad_v )

string_modes_number = length( string_params.loss_factors_v );

mode_n_v = 1:string_modes_number;
x = string_params.x_excitation;
c = string_params.celerity;
L = string_params.length;
B = string_params.bending_stiffness;
T = string_params.tension;

% Equation (31) de Woodhouse (a)

%Wn_v    = string_params.string_frequencies_v.';
etan_v  = string_params.loss_factors_v.';


% Introduction de d?viations par rapport au mod?le id?al 
Wn_v = mode_n_v.' * pi * c/L ...
    .* ( 1 + B*(mode_n_v.').^2 ) .* ( 1 + 1i*etan_v/2 );

Wn_m    = repmat(Wn_v, 1, length(omega_rad_v));
etan_m  = repmat(etan_v.', 1, length(omega_rad_v));

W_m     = repmat(omega_rad_v, string_modes_number, 1);
power_m = repmat((-1).^mode_n_v.', 1, length(omega_rad_v));

mode_n_m = repmat(mode_n_v.', 1, length(omega_rad_v));

temp = sum( power_m ./ ( W_m - Wn_m ) );
%temp = sum( power_m ./ ( W_m - mode_n_m*pi*c/L) );

H_string = x/L + (c/L)*sin(omega_rad_v*x/c) .* temp;



end