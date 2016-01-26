function test_F_compute_y_string()

str_note_name = 'E2';
string_modes_number = 60;
Nfft = 2^19;
Fs = 25600;
f_hz_v = Fs*linspace(0,1,Nfft); f_hz_v = f_hz_v(1:Nfft/2+1);
omega_rad_v = 2*pi*f_hz_v+eps;

[ string_params, ~ ] = ...
    F_string_parameters( str_note_name, string_modes_number );

res = F_compute_y_string( string_params, omega_rad_v );

%% Plotting
figure, plot( omega_rad_v, real(res) )
title('TEST REAL F compute Y string')
xlabel('\omega')
xlim([50 5000])
figure, plot( omega_rad_v, db(res) )
title('TEST DB F compute Y string')
xlabel('\omega')
xlim([50 5000])

%% Invert and listen
res = F_duplicate_with_hermitian_symmetry( res );

g = ifft( res );
g = g/max(abs(g));
soundsc( g, Fs );
audiowrite( 'test_F_compute_y_string.wav', g/max(abs(g)), Fs );

end