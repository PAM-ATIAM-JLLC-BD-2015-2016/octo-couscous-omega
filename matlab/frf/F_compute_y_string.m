function Y_string = F_compute_y_string( string_params, omega_rad_v )

Z_string = F_compute_z_string( string_params, omega_rad_v );

Y_string = 1./(Z_string);

end