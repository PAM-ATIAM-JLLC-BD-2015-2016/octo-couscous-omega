function [ dampings_v, reduced_frequencies_v ] = F_esprit( x_v, ...
    full_space_dim, signal_space_dim, only_real_damped_b )
%% Compute frequencies and dampings for the ESPRIT method

if nargin < 4
    only_real_damped_b = false;
end

W_m = F_sig_space( x_v, full_space_dim, signal_space_dim );

W_down_m = W_m(1:end-1,:);
W_up_m = W_m(2:end,:);

% pinv(W) is the pseudo-inverse of W
Phi_m = pinv(W_down_m) * W_up_m;

poles_v = eig(Phi_m);

reduced_frequencies_v = (1/(2*pi)) * angle(poles_v);
dampings_v = log(eps+abs(poles_v));

if only_real_damped_b
    reduced_frequencies_v = reduced_frequencies_v(dampings_v<0);
    dampings_v = dampings_v(dampings_v<0);
    
    dampings_v = dampings_v(reduced_frequencies_v>0);
    reduced_frequencies_v = reduced_frequencies_v(...
        reduced_frequencies_v>0);
end
