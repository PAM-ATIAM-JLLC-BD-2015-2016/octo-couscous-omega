function [ modes_m, complex_natural_frequencies_v ] = ...
    F_compute_modes_m( dissipation_m, mass_m, stiffness_m, ...
    varargin )
%% Coupled modes computation
% Combine the physical matrices describing the system to compute the
% vibration modes and frequencies.
%
% Input arguments:
%  * dissipation_m, a matrix: the coupled system's dissipation matrix C
%  * mass_m, a matrix: the coupled system's mass matrix M
%  * stiffness_m, a matrix: the coupled system's stiffness matrix K

%% Arguments parsing
p = inputParser;

addRequired(p, 'dissipation_m', @isnumeric);
addRequired(p, 'mass_m', @isnumeric);
addRequired(p, 'stiffness_m', @isnumeric);

parse(p, dissipation_m, mass_m, stiffness_m, varargin{:});

%% Damped modes computation via first-order reformulation of the system
modes_number = length(mass_m);
inv_mass_m = inv(mass_m);
combined_system_m = [ zeros(modes_number), eye(modes_number);
    -inv_mass_m*stiffness_m, -inv_mass_m*dissipation_m];
[ modes_m, complex_natural_frequencies_m ] = ...
    eig(combined_system_m);
complex_natural_frequencies_v = diag(complex_natural_frequencies_m);

end