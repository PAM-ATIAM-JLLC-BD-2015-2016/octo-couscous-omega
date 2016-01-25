
Fs = 26800;
Nfft = 2^18;

df = Fs/Nfft;
f1 = 50;
f2 = 5000;
f1_bin = floor(f1/df);
f2_bin = floor(f2/df);
f = [0:Nfft-1]*Fs/Nfft;

figure_fullscreen
%% Body
%
[Y11_b,~] = F_compute_FRF('measures/yamaha-c40_1/body-no_string_E2/mesure_z1.mat',Fs,Nfft);
subplot 311
plot(f,db(abs(Y11_b))); 
title('Y11 body')
xlim([f1 f2])

%% Body + string 
%
[Y11_t,~] = F_compute_FRF('measures/yamaha-c40_1/total_E2/mesure_z1.mat',Fs,Nfft);
subplot 312
plot(f,db(abs(Y11_t)));
title('Y11 total')
xlim([f1 f2])

%% String
%
Y11_s = 1./(( (Y11_t+eps).^(-1) - (Y11_b+eps).^(-1) ) + eps );
%Y11_s(1:f1_bin) = -eps;
subplot 313
plot(f,db(abs(Y11_s)));
title('Y11 string')
xlim([f1 f2])

%% Listen to the response of the strings
%
Y_s = Y11_s(1:Nfft/2+1);
%Y_s(f2_bin:end) = 0;
Y_s = [Y_s;flip(conj(Y_s(2:end-1)))];
Y_s(Nfft/2+1) = abs(Y_s(Nfft/2+1) );
a = ifft(Y_s);
soundsc(a,Fs);
pause(6);
figure, plot(a);

%% Ajust positive values of real(Y11_s)
for k = 1:length(Y11_s)
    if real(Y11_s(k)) > 0
        Y11_s(k) = -( real(Y11_s(k)) ) + i*imag(Y11_s(k));
    end
end

figure 
plot(f,db(abs(Y11_s)));
title('Y11 string')
xlim([f1 f2])

Y_s = Y11_s(1:Nfft/2+1);
%Y_s(f2_bin:end) = 0;
Y_s = [Y_s;flip(conj(Y_s(2:end-1)))];
Y_s(Nfft/2+1) = abs(Y_s(Nfft/2+1) );
a = ifft(Y_s);
soundsc(a(1:floor(length(a)*0.4)),Fs);
figure, plot(a);



