function test_F_compute_z_string()

str_note_name = 'E2';
string_modes_number = 100;
Nfft = 2^19;
Fs = 25600;
f_hz_v = Fs*linspace(0,1,Nfft); f_hz_v = f_hz_v(1:Nfft/2+1);
omega_rad_v = 2*pi*f_hz_v+eps;

x_excitation = 0.17;

[ string_params ] = ...
    F_FRF_compute_full_string_parameters(str_note_name, string_modes_number, x_excitation );

res = F_compute_z_string( string_params, omega_rad_v );

%% Plotting
figure, plot( omega_rad_v/(2*pi), real(res) )
title('TEST REAL F compute Z string')
xlabel('\omega')
xlim([50 10000])
figure, plot( omega_rad_v/(2*pi), db(res) )
title('TEST DB F compute Z string')
xlabel('\omega')
xlim([50 10000])

%% Invert and listen
res = F_duplicate_with_hermitian_symmetry( res );

g = ifft( res );
%soundsc( g, Fs );
%audiowrite( 'test_F_compute_z_string.wav', g, Fs );

end