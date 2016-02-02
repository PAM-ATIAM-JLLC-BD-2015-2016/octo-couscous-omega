function [ initial_excitation_v ] = F_compute_initial_excitation_v( ...
    string_modes_number, string_params, body_modes_number, ...
    static_height_body, coupled_modes_m, type_s, ...
    plots )
%% Compute projections of the initial displacement over the system's mode
% Use numerical integration to compute the modal contributions

if nargin < 7
    plots = false;
if nargin < 6
    type_s = 'triangle';
end
end

modes_number = string_modes_number + body_modes_number;

L = string_params.length;
H_0 = string_params.initial_height;
x_excitation = string_params.x_excitation;
excitation_width = string_params.excitation_width;

x_excitation_min = x_excitation - excitation_width/2;
x_excitation_max = x_excitation + excitation_width/2;

L_right = L - x_excitation_max;

x_plots_v = (0:10000) * L / 10000;

initial_excitation_v = zeros(modes_number,1);

if strcmp(type_s, 'triangle')
   
   F_initial_displacement = @(x) (static_height_body * x / L + (...
       (x <= x_excitation_min ) * H_0 .* (x / x_excitation_min) + ...
       (x > x_excitation_min & x <= x_excitation_max) * H_0 + ...
       (x > x_excitation_max) * ...
        H_0 .* (L_right - (x-x_excitation_max))/L_right));

    if plots
       plot(x_plots_v, F_initial_displacement(x_plots_v));
       pause(0.5);
       disp('Now on to the modal shapes')
    end
end

for mode_n = 1:modes_number
    mode_shape_v = coupled_modes_m(1:string_modes_number,2*mode_n-1);
    F_modal_shape = @(x) (sum(diag(mode_shape_v) * ...
        sin((1:string_modes_number).'*x * pi/L),1));
    
    if strcmp(type_s, 'triangle')
        F_product = @(x) ...
            (F_initial_displacement(x) .* conj(F_modal_shape(x)));
        
        if plots
            plot(x_plots_v, abs(F_product(x_plots_v)));
            pause(1),
        end
        
        initial_excitation_v(mode_n) = integral(F_product, 0, L);
    elseif strcmp(type_s, 'dirac')
        initial_excitation_v(mode_n) = H_0 * F_modal_shape(x_excitation);
    else
        error('Unrecognized excitation type.');
    end
end

end