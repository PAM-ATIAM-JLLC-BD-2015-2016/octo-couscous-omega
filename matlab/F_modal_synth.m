function [ modal_synthesis_v ] = F_modal_synth( ...
    x_synthesis, initial_excitation_v, ...
    string_modes_number, body_modes_number, ...
    string_length, ...
    modes_m, complex_natural_frequencies_v, ...
    mass_m, ...
    duration_s, Fs_Hz )
%% Modal synthesis
% Synthesize sound based on a modal description of a system.

modes_number = string_modes_number + body_modes_number;

%% Compute modal contributions for each of the natural modes

% if false
% mode_projections_m = zeros(2*modes_number, modes_number);
% for i=1:modes_number
%     mode_v = [ zeros(i-1,1) ; 1; zeros(modes_number-i,1) ;
%         zeros(modes_number,1)];  % Double-length vector since the new
%         % basis in the first-order method has twice the amount of
%         % dimensions
%     % Matlab recommends left-division instead of using inv()
%     mode_projections_m(:,i) = modes_m \ mode_v;
% end
% 
% % imagesc(mode_projections_m); pause;
% 
% string_mode_projections_m = mode_projections_m(:,1:string_modes_number);
% body_mode_projections_m = mode_projections_m(:,string_modes_number+1:end);
% end
% 
% string_mode_projections_m = modes_m(:,1:string_modes_number);
% body_mode_projections_m = modes_m(:,string_modes_number+1:end);

% %% Modal coefficients
% % Alphas are the coefficents for the constraint mode induced by the
% % body's movement
% alphas_v = sum(body_mode_projections_m,2);
% 
% % Betas are the mode-per-mode contributions
% betas_v = alphas_v * x_synthesis/string_length + ...
%     string_mode_projections_m * ...
%     sin((1:string_modes_number).' * pi*x_synthesis/string_length);
% 
% modes_inv_m = inv(modes_m);
% V_right_inv = modes_inv_m(:,modes_number+1:end);
% 
% X_woodhouse = V_right_inv / mass_m;
% 
% gammas_v = sum(X_woodhouse(:,string_modes_number+1:end),2);
% 
% % duration_n = round(Fs_Hz*duration_s);
% dt = 1 / Fs_Hz;
% time_s_v = 0:dt:duration_s;
% sampled_damped_exponentials_m = exp( ...
%     complex_natural_frequencies_v * time_s_v);
% 
% % sampled_damped_exponentials_m = exp(-1i * (2*pi*(440-1i)*(1:2*modes_number).') * time_s_v);
% 
% modal_synthesis_v = (gammas_v .* betas_v).' * ...
%     sampled_damped_exponentials_m;

%% From reference [22], W. (A): D.E. Newland, Mechanical Vibration A. & C.
% Equations (8.109) sqq. in [22]

U_upper_m = modes_m(1:modes_number,:);

modes_inv_m = inv(modes_m);
U_right_inv_m = modes_inv_m(:,modes_number+1:end);

amplitude_modes_v = [ sin(...
        pi*x_synthesis*(1:string_modes_number) / ...
        string_length) , ... % String modes
    x_synthesis/string_length * ones(1,body_modes_number) % Body modes
    ];

% betas_v = alphas_v * x_synthesis/string_length + ...
%     string_mode_projections_m * ...
%     sin((1:string_modes_number).' * pi*x_synthesis/string_length);

% duration_n = round(Fs_Hz*duration_s);
dt = 1 / Fs_Hz;
time_s_v = 0:dt:duration_s;
duration_n = length(time_s_v);
sampled_damped_exponentials_m = exp( ...
    complex_natural_frequencies_v * time_s_v);

modal_synthesis_v = zeros(1,duration_n);

% Precompute part of the matrix product
left_row_v = amplitude_modes_v * U_upper_m;
right_column_v = (U_right_inv_m / mass_m) * initial_excitation_v;

% To avoid overflow's, compute by segments of segment_length_n samples
segment_duration_n = 10000;
segments_number = floor(duration_n/segment_duration_n);

column_renormalization_m = repmat(left_row_v.', 1, segment_duration_n);

    function [ ] = F_compute_add_segment_v(...
        start_segment_n, segment_duration_n, ...    
        renormalization_m)
    current_segment_v = (start_segment_n:...
        start_segment_n + segment_duration_n-1);
    exponentials_segment_m = sampled_damped_exponentials_m(:,...
        current_segment_v);
    
    modal_synthesis_segment_v = ...
        (renormalization_m .* exponentials_segment_m).' * ...
         right_column_v;
    modal_synthesis_v(current_segment_v) = modal_synthesis_segment_v.'; 
    end


for segment_n = 0:segments_number-2
    start_n = 1+segment_duration_n*segment_n;
    F_compute_add_segment_v(...
        start_n, segment_duration_n, ...    
        column_renormalization_m);
end

last_segment_start_n = 1+segment_duration_n*(segments_number-1);
last_segment_duration_n = mod(duration_n, segment_duration_n);
last_column_renormalization_m = repmat(left_row_v.', 1, ...
    last_segment_duration_n);
 F_compute_add_segment_v(last_segment_start_n, last_segment_duration_n, ...
     last_column_renormalization_m);

% parfor t_ind = 1:duration_n
%     % row * diagonal matric product amounts to a renormalization of each
%     % of the columns of the row, which in turn amounts to a simple
%     % dot product
%     current_exponentials_v = sampled_damped_exponentials_m(:,t_ind);
%     
%     current_displacement = (left_row_v .* current_exponentials_v.') * ... 
%         right_column_v;
%     
%     modal_synthesis_v(t_ind) = current_displacement;
% end

end