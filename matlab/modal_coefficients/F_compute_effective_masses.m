function [ effective_masses_v ] = F_compute_effective_masses( ...
    body_length_1, body_length_2, body_thickness, body_surface_density, ...
    bridge_pos_1, bridge_pos_2, ...
    body_elastic_constants_v, ...
    body_natural_frequencies_v)
%% Effective masses computation for modal modeling
% Approximates the body as a rectangular plate, for which there is
% a simple, closed-form, analytic formula, following equation
% (7) from Woodhouse: On the "bridge hill" of the violin.
% These are the un-coupled effective masses for the detected modes.
%
% For the positioning on the body, direction 2 is the strings'
% direction whilst direction 1 is orthogonal to that, and
% position (0,0) is taken to be the bottom-left corner.
%
% Input arguments:
%  * body_length_1, body_length_2, doubles: the dimensions of the body,
%   approximated as rectangular plate.
%  * bridge_pos_1, bridge_pos_2, doubles: the position of the bridge on
%   the body plate, i.e. the string fixation position.
%  * body_elastic_constants_v, an array of doubles: the constants D_1, ...,
%   D4 used in Woodhouse's article On the "bridge hill" of the violin.
%  * body_natural_frequencies_v, an array of doubles: the measured
%   pulsations of the body modes, modal fitting is then applied.

body_modes_number = length(body_natural_frequencies_v);

% Vector [1 1 ... k k ... body_modes_number body_modes_number ], where
% each value is repeated body_modes_number times.
n_values_v = mod(...
    (body_modes_number:body_modes_number*(body_modes_number+1)-1), ...
    body_modes_number);

m_values_v = repmat((1:body_modes_number), 1, body_modes_number);

theoretical_natural_frequencies_v = ...
    body_thickness^2/body_surface_density * (...
        body_elastic_constants_v(1) * (n_values_v * pi / body_length_1)^4 + ...
        body_elastic_constants_v(3) * (m_values_v * pi / body_length_2)^4 + ...
        2*sqrt(body_elastic_constants_v(1)*body_elastic_constants_v(3)) * ...
            (n_values_v * pi / body_length_1)^2 .* ...
            (m_values_v * pi / body_length_2)^2 ...
    );

%% Modal fitting
% Fit measured frequencies with the theoretical ones to extract the
% significant modes.
mode_indexes_m = zeros(body_modes_number,2);
for frequency_ind = 1:length(body_natural_frequencies_v)
    natural_frequency = real(body_natural_frequencies_v(frequency_ind));
    [~,indexes_combined] = min(abs(natural_frequency^2 - ...
        theoretical_natural_frequencies_v));
    modulus = mod(indexes_combined, body_modes_number);
    mode_indexes_m(frequency_ind,:) = [modulus, ...
        indexes_combined-body_modes_number*modulus];
end

%% Mass-normalized modal shapes at the bridge
modal_shapes_v = 2/sqrt(body_length_1*body_length_2* ... 
    body_thickness*body_surface_density) * ...
    sin(mode_indexes_m(:,1) * pi * bridge_pos_1 / body_length_1) .* ...
    sin(mode_indexes_m(:,2) * pi * bridge_pos_2 / body_length_2);

%% Effective masses definition
effective_masses_v = 1 / modal_shapes_v^2;

end
