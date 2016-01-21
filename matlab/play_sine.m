function play_sine(freq_hz)

Fs = 44100;
t = [0:Fs]/Fs;
s = 0.8*sin(2*pi*freq_hz*t);

soundsc(s,Fs);
end