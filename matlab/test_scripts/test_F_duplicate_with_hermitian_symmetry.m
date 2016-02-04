function test_F_duplicate_with_hermitian_symmetry()

Nfft = 2^18;
Fs = 25600;
f0 = 440;
i0 = floor(f0*Nfft/Fs);
f = [0:Nfft-1]*Fs/Nfft;

half_fft = zeros(1,Nfft/2+1)+eps;

%% Adding the note the fft
Nw = 256;
half_fft(i0-Nw/2:i0+Nw/2-1) = hanning(Nw);

figure, plot( f(1:Nfft/2+1), half_fft )

res = F_duplicate_with_hermitian_symmetry( half_fft );

figure, plot( f, real(res) );
title('TEST REAL symmetrical FFT')
xlabel('f (Hz)');
figure, plot( f, db(res) );
title('TEST DB symmetrical FFT')
xlabel('f (Hz)');

%% Invert and listen

g = ifft( res );
%soundsc( g, Fs );
%audiowrite( 'test_F_duplicate_with_hermitian_symmetry.wav', g, Fs );

figure, plot(g);
g = [g(floor(0.8*length(g)):end),g(1:floor(0.8*length(g)))];
%soundsc( g, Fs );

end