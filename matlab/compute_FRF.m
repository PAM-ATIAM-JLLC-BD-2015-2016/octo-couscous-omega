
%% Try to compute the FRF with a higher number of points than the software used.
%
%
function [Yn1,Yn2] = compute_FRF( measure_mat_filename, Fs, Nfft )
% This function extracts the measurements  from experiments data
% in a .mat file. It is then saved in the folder ./wav in an audio form

measure_name = measure_mat_filename(1:end-4);

if nargin<2
    Fs = 25600;
    Nfft = 2^18;
end

s       = load( measure_mat_filename, 'data_Temporel_fenetre_1' );
an1     = s.data_Temporel_fenetre_1(:,2);
force   = s.data_Temporel_fenetre_1(:,3);

s       = load( measure_mat_filename, 'data_Temporel_fenetre_2' );
an2     = s.data_Temporel_fenetre_2(:,2);

Yn1 = c_FRF(force, an1, Fs, Nfft);
Yn2 = c_FRF(force, an2, Fs, Nfft);

end
    
    
function Y = c_FRF( force_t, acceleration_t, Fs, Nfft )
    F = fft(force_t,Nfft);
    A = fft(acceleration_t,Nfft);
    Ytemp = A./(F+eps);
    
    f0 = 50;
    df = Fs/Nfft;
    i0 = floor(f0/df);
    freqs = [0:Nfft-1]*Fs/Nfft;
    
    % Integrating the acceleration
    Y = Ytemp./(i.*(freqs.'+eps));
    
    % Setting to zero the very low frequencies
    Y(1:i0) = Ytemp(1:i0)-(Ytemp(i0)-Y(i0+1));
    Y(end-i0+1:end) = flip(Ytemp(1:i0)-(Ytemp(i0)-Y(i0+1)));
    Y = Ytemp;
end




