function [ effective_masses_v ] = F_compute_effective_masses_v( ...
    body_complex_natural_frequencies_v, body_admittance_v, Fs_Hz)
%% Body modes effective masses computation
% Using formula (4.2) from Arthur Paté's PhD thesis.

% How to go from the complex natural frequencies to daming and pulsation?
% Just real() and imag() or something more?

body_pulsations_v = real(body_complex_natural_frequencies_v);
body_dampings_v = imag(body_complex_natural_frequencies_v);

effective_masses_v = 1 / (...
    2*abs(body_admittance_v()));


end

