clc;
close all;
clear all;

%[signal,Fs] = audioread('test_A3.wav');
%signal = signal(2000:end);

[signal,Fs,string_frequency,string_damping_coeffs_v] = theoretical_string('E2');

transient_time = 0.2;              %2OOms
transient_n = transient_time*Fs;
signal = signal(transient_n:transient_n+500);
Nfft = 2^(nextpow2(length(signal))+3);
incert = 5;

number_modes = 10; %signal is supposed quasi-harmonic
freq_estimate = F_harm_freq(signal,number_modes,Fs,Nfft); %estimation of harmonic frequencies

%B = zeros(number_modes,filter_order+1);
y = zeros(number_modes,length(signal));

fft_signal = abs(fft(signal,Nfft));
fft_signal = fft_signal/max(fft_signal);
% f = Fs*linspace(0,1,Nfft);

%% decimation

dec_bandpass = freq_estimate(1)/2; %bandpass of the filtered signal
%f = Fs*linspace(0,1,length(y));
decimation_freq = 8*dec_bandpass;
decimation_factor = round(Fs/decimation_freq); %decimation factor
decimation_freq = Fs/decimation_factor; %exact decimation frequency

%% filtering of each harmonics and ESPRIT method
for i=1%:number_modes 
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
    
    freq_coord = [0 nu_c1 nu_b1 nu_b2 nu_c2 1];
    B = generateBandPassFilter(nu_b1, nu_c1, nu_b2, nu_c2, Fs);
    

    
    [h,w] = freqz(B,1,Nfft/2);
    B = B/max(abs(h)); 
    h = h./max(h);
    figure;
    plot(w/pi,abs(h));
    hold on
    plot(w/pi,fft_signal(1:Nfft/2))
    xlim([0 0.5])
    pause;
    close all

    y(i,:) = filter(B,1,signal); %filtering of the signal
    %y(i,:) = y(i,:).*exp(2*1i*pi*freq_estimate(i)*(1:length(signal))/Fs); %frequency shift to 0 Hz
    y_new(i,:) = y(i,:);%y(:,1:decimation_factor:end);


    %% ESPRIT
    K = 1; n = length(y_new(1,:));
    [delta_esprit(i), f_esprit(i)] = TP_esprit(y_new(i,:),n,K);
end

% f_new = decimation_freq*linspace(0,1,length(y_new));


