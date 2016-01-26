function symmetrical_fft_v = F_duplicate_with_hermitian_symmetry( half_fft_v );
% Creates a symmetric FFT from the half fft given as input.
% Hermitian symmetry will be respected.
temp =  half_fft_v;
temp(1) = real(temp(1));
temp(end) = real(temp(end));

symmetrical_fft_v = [temp;flip(conj(temp(2:end-1)))];