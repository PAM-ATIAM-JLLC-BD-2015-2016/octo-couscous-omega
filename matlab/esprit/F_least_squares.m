function [ amplitudes_v, phases_v ] = F_least_squares( x_v, ...
    dampings_v, reduced_frequencies_v )
%% Compute amplitudes and phases of signal for the ESPRIT method
% Based on a least squares computation (orthogonal projection
% on the signal space)
%
% Input arguments:
%  * x_v, an array: the signal to analyze
%  * delta_v, an array: the estimated dampings for the signal
%  * f_v, an array: the estimated frequencies for the signal

N = length(x_v);

%% Vandermonde matrix V of the poles
% The pointwise logarithm of this matrix is simply computed via
% an array product

complex_exponents_v = dampings_v + 1i*2*pi*reduced_frequencies_v;
V_ln_m = (0:N-1).' * complex_exponents_v.';

V_m = exp(V_ln_m);

alpha_v = pinv(V_m) * x_v;  % Projection on the signal space

amplitudes_v = abs(alpha_v);
phases_v = angle(alpha_v);

end
