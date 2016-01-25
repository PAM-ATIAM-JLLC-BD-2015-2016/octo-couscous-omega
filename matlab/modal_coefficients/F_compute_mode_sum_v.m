function [ mode_sum_v ] = F_compute_mode_sum_v( ...
    string_modes_number, string_length, ...
    x_length, mode_shape_v)
%% Compute the shape of a string mode
% Input arguments:
%  * mode_shape_v, an array of length string_modes_number: the set of
%   string mode coefficients in the basis of the standard modes for a
%   string of length string_length.
%  * x_length, an int: the number of points to use for the rendering.

x_v = linspace(0, string_length, x_length);
mode_sum_v = sum(diag(mode_shape_v) * ...
    sin((1:string_modes_number).'*x_v * pi/string_length),1);

end
