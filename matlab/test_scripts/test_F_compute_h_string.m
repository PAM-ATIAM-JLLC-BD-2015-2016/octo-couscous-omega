function test_F_compute_h_string()

str_note_name = 'E2';
string_modes_number = 40;
Nfft = 2^19;
Fs = 25600;
f_hz_v = Fs*linspace(0,1,Nfft); f_hz_v = f_hz_v(1:Nfft/2+1); 
omega_rad_v = 2*pi*f_hz_v+eps;

[ string_params ] = ...
    F_FRF_compute_full_string_parameters( str_note_name, string_modes_number );

H = F_compute_h_string( string_params, omega_rad_v );

%% Plotting
figure, plot( omega_rad_v/(2*pi), real(H) )
title('TEST REAL F compute H string')
xlabel('\omega')
%xlim([50 5000])
figure, plot( omega_rad_v/(2*pi), db(H) )
title('TEST DB F compute H string')
xlabel('\omega')
%xlim([50 5000])

%% Invert and listen
res = F_duplicate_with_hermitian_symmetry( H );

g = ifft( res );
g = g/max(abs(g));

figure, plot(f_hz_v, db(H)), title('TEST ifft(H)')

%soundsc( g, Fs );
%audiowrite( 'test_F_compute_h_string2.wav', g, Fs );

end