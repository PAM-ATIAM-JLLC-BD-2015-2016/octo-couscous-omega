function [ H_string, Z_string ] = ...
    F_string_frfs_2( string_modes_number, Nfft, str_note_name, DEBUG_MODE )
% Computes the frf necessary for the frequency domain synthesis
% 
% INPUTS
%   str_note_name : 'E2', 'A2', 'D3', 'G3', 'B3', or 'E4'
%   DEBUG_MODE : a boolean activating the display of plots
%
% OUTPUTS
%   H_string : displacement transfer function between an excitation point
%       and the end of the string
%   Z_string : acoustic impedance at the end of the string

%% Initilization
Fs = 25600;
f_hz_v = Fs*linspace(0,1,Nfft); f_hz_v = f_hz_v(1:Nfft/2+1);
omega_rad_v = 2*pi*f_hz_v+eps;

%% String parameters, frequencies, damping coefficients
[ string_params, ~ ] = F_string_parameters( string_modes_number, str_note_name );


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

%% Transfer function displacement/displacement

power_v = (-1).^[1:string_modes_number].';
power_m = repmat(power_v,1,length(omega_rad_v));
sin_v   = sin([1:string_modes_number].'*pi*x_excitation/string_length);
sin_m   = repmat(sin_v,1,length(omega_rad_v));

TMP = power_m.*(2.*omega_m.*sin_m)./...
       (omega_m.^2 - 1i*omega_m.*string_frequency_m.*string_damping_coeffs_m - string_frequency_m.^2);

H_string = x_excitation/string_length + (celerity/string_length)*sum(TMP);

if DEBUG_MODE
    disp('*** DEBUG_MODE ***');
    disp('* H_string');
    figure, plot(f_hz_v,db(H_string)), title('DEBUG : H_{string}')
end

end
