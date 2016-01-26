function BPFilter = generateBandPassFilter(Fpass1, Fstop1, Fpass2, Fstop2, Fs)

rp = 3;           % Passband ripple
rs = 40;          % Second Stopband Attenuation
%dens   = 20;        % Density Factor

% Calculate the order from the parameters using firpmord.
[N, Fo, Ao, W] = firpmord([Fstop1 Fpass1 Fpass2 Fstop2]/(Fs/2), [0 1 0], [10^(-rs/20) (10^(rp/20)-1)/(10^(rp/20)+1)  10^(-rs/20)]);

% Calculate the coefficients using the FIRPM function.
BPFilter  = firpm(N, Fo, Ao, W);
