
function Z_string = F_compute_z_string( string_params, string_modes_number, omega_rad_v )

eta_m   = repmat(string_params.string_dampings.', 1, length(omega_rad_v));
Wj_m    = repmat(string_params.string_frequencies.', 1, length(omega_rad_v));
W_m     = repmat(omega_rad_v, string_modes_number, 1);

temp    = (2*W_m - 1i*Wj_m.*eta_m) ./ (W_m.^2 - 1i*W_m.*Wj_m.*eta_m - (Wj_m.^2).*()

%% String Impedance Z for Nmodes
TMP = zeros(string_modes_number,length(f_hz_v));

string_damping_coeffs_m = repmat(string_damping_coeffs_v.', 1, length(omega_rad_v));
string_frequency_m = repmat(string_frequency.', 1, length(omega_rad_v));
omega_m = repmat(omega_rad_v, string_modes_number, 1);

TMP = (2*omega_m - 1i*string_frequency_m.*string_damping_coeffs_m)./...
      (omega_m.^2 - 1i*omega_m.*string_frequency_m.*string_damping_coeffs_m...
      - (string_frequency_m.^2).*(1-(string_damping_coeffs_m.^2)/4));
Z_string = -(1i*string_tension/string_length)*((1./(omega_rad_v+eps)) + sum(TMP));  % String impedance equation (29)

if DEBUG_MODE
    disp('*** DEBUG_MODE ***');
    disp('* Z_string');
    figure, plot(f_hz_v,db(Z_string)), title('DEBUG : Z_{string}')
end