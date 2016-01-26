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
[ string_params ] = F_compute_full_string_parameters( str_note_name, string_modes_number );


%% String Impedance Z for Nmodes
Z_string = F_compute_z_string( string_params, omega_rad_v );

if DEBUG_MODE
    disp('*** DEBUG_MODE ***');
    disp('* Z_string');
    figure, plot(f_hz_v,db(Z_string)), title('DEBUG : Z_{string}')
end

%% Transfer function displacement/displacement

H_string = F_compute_h_string( string_params, omega_rad_v );

if DEBUG_MODE
    disp('*** DEBUG_MODE ***');
    disp('* H_string');
    figure, plot(f_hz_v,db(H_string)), title('DEBUG : H_{string}')
end

Z_string = Z_string(:);
H_string = H_string(:);

end
