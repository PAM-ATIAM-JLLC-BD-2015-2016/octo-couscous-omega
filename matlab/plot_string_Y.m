
Fs = 26800;
Nfft = 2^18;

df = Fs/Nfft;
f1 = 50;
f2 = 500;
f1_bin = floor(f1/df);
f2_bin = floor(f2/df);

%% Body
%
[Y11_b,~] = compute_FRF('body_no_string_E2\mesure_z1.mat',Fs,Nfft);
subplot 311
plot(db(abs(Y11_b)));

%% Body + string 
%
[Y11_t,~] = compute_FRF('total_E2\mesure_z1.mat',Fs,Nfft);
subplot 312
plot(db(abs(Y11_t)));

%% String
%
Y11_s = 1./(( (Y11_t+eps).^(-1) - (Y11_b+eps).^(-1) ) + eps );
subplot 313
plot(db(abs(Y11_t)));
