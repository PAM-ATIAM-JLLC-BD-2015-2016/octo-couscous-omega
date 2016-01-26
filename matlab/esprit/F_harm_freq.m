function harm_freq = F_harm_freq(signal,number_harm,Fs,Nfft)

fft_signal = fft(signal, Nfft);

harm_freq = zeros(1,number_harm); %array of precise harmonic frequencies
%harm_freq(1) = F_fond_freq(fft_signal,Nfft,Fs,50,1000);

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

