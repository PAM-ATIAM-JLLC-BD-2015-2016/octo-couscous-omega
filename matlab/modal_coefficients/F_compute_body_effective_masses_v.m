function [ body_effective_masses_v ] = F_compute_body_effective_masses_v( ...
    body_admittance_v, Fs_Hz, ...
    body_natural_frequencies_Hz_v, body_dampings_v)
%% Body modes effective masses computation
% Using formula (4.2) from Arthur Paté's PhD thesis.

dF_admittance_Hz = (Fs_Hz/2) / length(body_admittance_v);

% Indexes of the body's modes wrt to the admittance's resolution, >= 1
body_natural_frequencies_n_admittance_v = ...
    max(1, round(body_natural_frequencies_Hz_v/dF_admittance_Hz));

body_admittance_modes_v = body_admittance_v(...
        body_natural_frequencies_n_admittance_v);

body_effective_masses_v = ones(length(body_natural_frequencies_Hz_v),1) ./ (eps +...
    2*abs(body_admittance_modes_v) .* ...
    (2*pi * body_natural_frequencies_Hz_v) .* body_dampings_v);

end

