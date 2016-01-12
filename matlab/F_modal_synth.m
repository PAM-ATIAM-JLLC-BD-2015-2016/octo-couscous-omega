function [ modal_synthesis_v ] = F_modal_synth( ...
    x_synthesis, ...
    string_modes_number, body_modes_number, ...
    string_length, ...
    modes_m, complex_natural_frequencies_v, ...
    duration_s, Fs_Hz )
%% Modal synthesis
% Synthesize sound based on a modal description of a system.

modes_number = string_modes_number + body_modes_number;

%% Compute modal contributions for each of the natural modes
mode_projections_m = zeros(2*modes_number, modes_number);
for i=1:modes_number
    mode_v = [ zeros(i-1,1) ; 1; zeros(modes_number-i,1) ;
        zeros(modes_number,1)];  % Double-length vector since the new
        % basis in the first-order method has twice the amount of
        % dimensions
    % Matlab recommends division instead of using inv()
    mode_projections_m(:,i) = modes_m \ mode_v * modes_m;  % BAD dimensions
end

string_mode_projections_m = mode_projections_m(:,1:string_modes_number);
body_mode_projections_m = mode_projections_m(:,string_modes_number+1:end);

alphas_v = sum(body_mode_projections_m,2);
betas_v = alphas_v * x_synthesis/string_length + ...
    string_mode_projections_m * ...
    sin((1:string_modes_number)*pi*x_synthesis/string_length);

modes_inv_m = inv(modes_m);
V_right_inv = modes_inv_m(:,modes_number+1:end);

X_woodhouse = V_right_inv/mass_m;

gammas_v = sum(X_woodhouse(:,string_modes_number+1:end),2);

duration_n = round(Fs_Hz*duration_s); 
time_v = 0:duration_n-1;
modal_synthesis_v = sum(gammas_v .* betas_v .* ...
    exp(complex_natural_frequencies_v * time_v), 1);

end

