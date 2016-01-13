function [ modes_m, complex_natural_frequencies_v ] = ...
    F_compute_modes_m( dissipation_m, mass_m, stiffness_m ) %, ...
%     varargin )
%% Coupled modes computation, possible using two different methods
% Combine the physical matrices describing the system to compute the
% vibration modes and frequencies.
%
% Input arguments:
%  * dissipation_m, a matrix: the coupled system's dissipation matrix C
%  * mass_m, a matrix: the coupled system's mass matrix M
%  * stiffness_m, a matrix: the coupled system's stiffness matrix K

%% Arguments parsing
p = inputParser;
% 
% defaultMode = 'ODE';
% validModes = {'ODE', 'first-order'};
% checkMode = @(type_s) any(validatestring(computation_mode_s, validModes));

addRequired(p, 'dissipation_m', @isnumeric);
addRequired(p, 'mass_m', @isnumeric);
addRequired(p, 'stiffness_m', @isnumeric);
% addParameter(p, 'computation_mode_s', defaultType, checkMode);

parse(p, dissipation_m, mass_m, stiffness_m); %, varargin{:});

% if strcmp(computations_mode_s, 'ODE')
% %% Undamped modes computation via physical differential equation
% syms q(t);
% Dq = diff(q);
% D2q = diff(q, 2);
% system_eqn = ( mass_m*D2q + dissipation_m*Dq + stiffness_m*q == 0);
% dsolve(system_eqn);

% else
%% Damped modes computation via first-order reformulation of the system
modes_number = length(mass_m);
inv_mass_m = inv(mass_m);
combined_system_m = [ zeros(modes_number), eye(modes_number);
    -inv_mass_m*dissipation_m, -inv_mass_m*stiffness_m];
[ modes_m, complex_natural_frequencies_m ] = ...
    eig(combined_system_m);
complex_natural_frequencies_v = diag(complex_natural_frequencies_m);

end