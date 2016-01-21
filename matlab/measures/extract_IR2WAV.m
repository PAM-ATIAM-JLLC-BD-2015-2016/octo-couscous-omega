function extract_IR2WAV( measure_mat_filename, Fs )
% This function extracts the measurements  from experiments data
% in a .mat file. It is then saved in the folder ./wav in an audio form

measure_name = measure_mat_filename(1:end-4);

if nargin<2
    Fs = 25600;
end

s = load( measure_mat_filename, 'data' );

if isempty(fieldnames(s))
    s   = load( measure_mat_filename, 'data_Temporel_1' );
    s1  = s.data_Temporel_1/(max(abs(s.data_Temporel_1(:,2))));
    
    s   = load( measure_mat_filename, 'data_Temporel_fenetre_1' );
    s1w = s.data_Temporel_fenetre_1/(max(abs(s.data_Temporel_fenetre_1(:,2))));
    
    s   = load( measure_mat_filename, 'data_Temporel_2' );
    s2  = s.data_Temporel_2/(max(abs(s.data_Temporel_2(:,2))));
    
    s   = load( measure_mat_filename, 'data_Temporel_fenetre_2' );
    s2w = s.data_Temporel_fenetre_2/(max(abs(s.data_Temporel_fenetre_2(:,2))));
    
    audiowrite(['./wav/' measure_name '_temporel_1.wav'],s1,Fs);
    audiowrite(['./wav/' measure_name '_temporel_2.wav'],s2,Fs);
    audiowrite(['./wav/' measure_name '_temporel_fenetre_1.wav'],s1w,Fs);
    audiowrite(['./wav/' measure_name '_temporel_fenetre_2.wav'],s2w,Fs);
   
else
    x = s.data.X / (max(abs(s.data.X))+eps);
    y = s.data.Y / (max(abs(s.data.Y))+eps);
    z = s.data.Z / (max(abs(s.data.Z))+eps);
    audiowrite(['./wav/' measure_name '_x.wav'],x,Fs);
    audiowrite(['./wav/' measure_name '_y.wav'],y,Fs);
    audiowrite(['./wav/' measure_name '_z.wav'],z,Fs);
end
    
    


