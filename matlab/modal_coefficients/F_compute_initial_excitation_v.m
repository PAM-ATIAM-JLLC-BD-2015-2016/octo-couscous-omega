function [ initial_excitation_v ] = F_compute_initial_excitation_v( ...
    string_modes_number, string_params, body_modes_number, ...
    static_height_body, coupled_modes_m )
%% Compute projections of the initial displacement over the system's mode
% Use numerical integration to compute the modal contributions

modes_number = string_modes_number + body_modes_number;

L = string_params.length;
H_0 = string_params.initial_height;
x_excitation = string_params.x_excitation;
excitation_width = string_params.excitation_width;

excitation_min = x_excitation - excitation_width/2;
excitation_max = x_excitation + excitation_width/2;

F_initial_displacement = @(x) (static_height_body * x / L + ...
        (x <= excitation_min ) * H_0 .* (x / x_excitation) + ...
        (x > excitation_min & x <= excitation_max) * H_0 + ...
        (x > excitation_max) * H_0 .* (L - x)/(L));

initial_excitation_v = zeros(modes_number,1);

for mode_n = 1:modes_number
    mode_shape_v =  coupled_modes_m(1:string_modes_number,mode_n);
    F_modal_shape = @(x) (sum(diag(mode_shape_v) * ...
        sin((1:string_modes_number).'*x * pi/L),1));
    
    initial_excitation_v(mode_n) = integral(...
        @(x) (F_initial_displacement(x) .* conj(F_modal_shape(x))), 0, L);
end

end