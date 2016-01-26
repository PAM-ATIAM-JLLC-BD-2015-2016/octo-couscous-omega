function [ mass_m ] = F_compute_mass_m( string_modes_number, ...
    body_modes_number, string_params, body_effective_masses_v )
%% Mass matrix, M, computation
% 

L = string_params.length;
rho = string_params.linear_mass;

M = rho*L; 

%% String block
mass_1_1_v = M/2 * ones(string_modes_number,1);
mass_1_1_m = diag(mass_1_1_v);

%% Coupled contributions block
mass_1_2_v = (-1).^(0:string_modes_number-1).' .* ...
    ((M/pi) ./ (1:string_modes_number).');
mass_1_2_m = repmat(mass_1_2_v, 1, body_modes_number);

%% Body block
mass_2_2_m = diag(body_effective_masses_v) + M/3;

%% Block-wise matrix definition
mass_m = [ mass_1_1_m, mass_1_2_m;
           mass_1_2_m.', mass_2_2_m ];

end