function f0 = F_fond_freq(signal,Nfft,Fs,f_min,f_max)

%[signal,Fs] = audioread('measures\wav\test_A3.wav');
%signal = signal(2000:end);

%Nfft = 2^nextpow2(length(signal));
fft_sig = abs(fft(signal,Nfft));

%f_min = 50;
%f_max = 900;

H = 3; %number of specter foldings
R_max = floor((Nfft-1)/(2*H));
 
    
%% spectral product
P = ones(R_max,1);
for i=1:R_max
    for k=1:H
        P(i)=P(i)*fft_sig(k*i);
    end
end
 
%% fundamental frequency search
N_min = ceil(Nfft*f_min/Fs);
N_max = floor(Nfft * f_max/Fs);
[~,pos] = max(P(N_min:N_max));

f0 = (pos + N_min) * Fs/ Nfft; %fundamental frequency

end
