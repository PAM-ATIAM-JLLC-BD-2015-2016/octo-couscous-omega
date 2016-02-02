function [ measure_filename_s ] = F_select_measure( guitar_measure_s )

measure_folder_prefix = '../../measures/yamaha-c40_1/body-no_string_';

selected_measure_number = sscanf(guitar_measure_s, 'Guitar %d');

if selected_measure_number <= 5
    string_name = 'E2';
else
    string_name = 'E4';
end
    
% The filenames of the guitar measures are indexed between 1 and 5
measure_index = mod(selected_measure_number-1, 5) + 1;

measure_filename_s = [measure_folder_prefix, string_name, '/mesure_z', ...
    int2str(measure_index), '.mat' ];
end