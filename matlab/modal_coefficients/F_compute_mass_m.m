function [ mass_m ] = F_compute_mass_m( ...
    string_modes_number, body_modes_number, ...
    string_length, string_linear_mass, ...
    effective_masses_v )
%% Mass matrix, M, computation
% 

string_mass = string_linear_mass*string_length; 

%% String block
mass_1_1_v = string_mass/2 * ones(string_modes_number,1);
mass_1_1_m = diag(mass_1_1_v);

%% Coupled contributions block
mass_1_2_v = (-1).^(0:string_modes_number-1) .* ...
    ((string_mass/pi) ./ (1:string_modes_number));
mass_1_2_m = repmat(mass_1_2_v.', 1, body_modes_number);

%% Body block
mass_2_2_m = diag(effective_masses_v) + ...
    ones(body_modes_number) * string_mass/3;

%% Block-wise matrix definition
mass_m = [ mass_1_1_m, mass_1_2_m;
           mass_1_2_m.', mass_2_2_m ];

end