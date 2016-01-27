function [f_extract,delta_extract] = F_extract(signal,Fs,number_modes,Nfft)

%% pre-processing

% [signal,Fs] = audioread('A3_piano.wav');
% signal = signal(2000:20000);

% Nfft = 2^(nextpow2(length(signal))+2);
incert = 10;

% number_modes = 10; %selection of a number of modes
freq_estimate = F_harm_freq(signal,number_modes,Fs,Nfft); %estimation of harmonic frequencies

% fft_signal = abs(fft(signal,Nfft));
% fft_signal = fft_signal/max(fft_signal);
%B = zeros(number_modes,filter_order+1);

%% space allocation

y = zeros(number_modes,length(signal));
delta_esprit = zeros(1,number_modes);
f_esprit = zeros(1,number_modes);

%% decimation parameters

dec_bandpass = freq_estimate(1)/2; %bandpass of the filtered signal
decimation_freq = 10*dec_bandpass;
decimation_factor = round(Fs/decimation_freq); %decimation factor
decimation_freq = Fs/decimation_factor; %exact decimation frequency
y_dec = zeros(number_modes,length(1:decimation_factor:length(signal)));
%% filtering of each harmonics and ESPRIT method

for i=1:number_modes
    
    if i==1
        nu_c1 =  freq_estimate(1)/2;
    else
        nu_c1 = (freq_estimate(i)+freq_estimate(i-1))/2;
    end
    
    nu_b1 = freq_estimate(i)-incert;
    nu_b2 = freq_estimate(i)+incert;
    
    if i==number_modes
        nu_c2 = freq_estimate(i)+(freq_estimate(i)-nu_c1);
    else
        nu_c2 = (freq_estimate(i)+freq_estimate(i+1))/2;
    end
    
    %freq_coord = [0 nu_c1 nu_b1 nu_b2 nu_c2 1]; %filter parameters
    B = generateBandPassFilter(nu_b1, nu_c1, nu_b2, nu_c2, Fs); %bandpass filter design
    
    % normalization of the filter
    
    [h,~] = freqz(B,1,Nfft/2);
    B = B/max(abs(h));
    
%     h = h./max(h);
%     figure;
%     plot(w/pi,abs(h));
%     hold on
%     plot(w/pi,fft_signal(1:Nfft/2))
%     xlim([0 0.5])
%     pause;
%     close all

    y(i,:) = filter(B,1,signal); %signal filtering
    y(i,:) = y(i,:) - mean(y(i,:));
    y(i,:) = y(i,:).*exp(-2*1i*pi*freq_estimate(i)*(1:length(signal))/Fs); %frequency shift to 0 Hz
    
    y_dec(i,:) = y(i,1:decimation_factor:end);


    %% ESPRIT
    K = 2; n = 256;
    [delta_esprit_temp, f_esprit_temp] = F_esprit(y_dec(i,:),n,K);
    [~,pos] = min(abs(f_esprit_temp));
    delta_esprit(i) = delta_esprit_temp(pos);
    f_esprit(i) = f_esprit_temp(pos);
end

f_extract = f_esprit*decimation_freq + freq_estimate;
delta_extract = delta_esprit*decimation_freq;

%% re-synthesis

% reconst_delta = [delta_esprit delta_esprit];
% f_esprit = f_esprit*Fs/decimation_freq + freq_estimate/Fs;
% reconst_f = [-f_esprit f_esprit];
% [amp,phase] = F_least_squares(signal,reconst_delta,reconst_f);
% NbN = 64000;      %arbitrary length of the re-synthesized signal
% s_syn = real(F_synthesis(NbN,reconst_delta.',reconst_f.',amp,phase.'));
% % f_new = decimation_freq*linspace(0,1,length(y_new));

end

function harm_freq = F_harm_freq(signal,number_harm,Fs,Nfft)

fft_signal = fft(signal, Nfft);
harm_freq = zeros(1,number_harm); %array of precise harmonic frequencies

search_interv = 5; %size of the interval in which each freq will be purchased [Hz]

for i=1:number_harm
    
    if i==1
        middle_freq = F_fond_freq(fft_signal,Nfft,Fs,50,1000);
    elseif i==2
        middle_freq = 2*harm_freq(1);
    else
        middle_freq = harm_freq(i-1)+(harm_freq(i-1) - harm_freq(i-2));
    end
    
    N_min = ceil(Nfft* (middle_freq - search_interv)/Fs); %beginning of the search interval
    N_max = floor(Nfft * (middle_freq + search_interv)/Fs); %end of the search interval
    [~,pos] = max(abs(fft_signal(N_min:N_max)));
    harm_freq(i) = (pos + N_min) * Fs/ Nfft;
    
end

end

function f0 = F_fond_freq(fft_signal,Nfft,Fs,f_min,f_max)
abs_fft_sig = abs(fft_signal);
H = 10; %number of specter foldings
R_max = floor((Nfft-1)/(2*H));
%% spectral product
P = ones(R_max,1);
for l=1:R_max
    for k=1:H
        P(l)=P(l)*abs_fft_sig(k*l);
    end
end

%% fundamental frequency search
N_min = ceil(Nfft*f_min/Fs);
N_max = floor(Nfft * f_max/Fs);
[~,pos] = max(P(N_min:N_max));
f0 = (pos + N_min) * Fs/ Nfft; %fundamental frequency
end

function BPFilter = generateBandPassFilter(Fpass1, Fstop1, Fpass2, Fstop2, Fs)

rp = 3;           % Passband ripple
rs = 60;          % Second Stopband Attenuation
%dens   = 20;        % Density Factor

% Calculate the order from the parameters using firpmord.
[N, Fo, Ao, W] = firpmord([Fstop1 Fpass1 Fpass2 Fstop2]/(Fs/2), [0 1 0], [10^(-rs/20) (10^(rp/20)-1)/(10^(rp/20)+1)  10^(-rs/20)]);

% Calculate the coefficients using the FIRPM function.
BPFilter  = firpm(N, Fo, Ao, W);
end