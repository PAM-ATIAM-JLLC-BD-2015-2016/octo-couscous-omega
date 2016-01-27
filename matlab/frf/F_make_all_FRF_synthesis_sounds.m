
function F_make_all_FRF_synthesis_sounds(version_name_str)

Nfft = 2^19;
Fs = 25600;
notes_str_arr = ['E2'; 'A2'; 'D3'; 'G3'; 'B3'; 'E4'];

folder_name = ['sounds/frf/' date() '_' version_name_str];
mkdir(folder_name);

for folder_index = 1:3
    switch folder_index
        case 1
            instr_str = 'guitar';
            folder_str = 'matlab/measures/yamaha-c40_1/body-no_string_E2';      
            notes_to_test = [1:3];
        case 2
            instr_str = 'guitar';
            folder_str = 'matlab/measures/yamaha-c40_1/body-no_string_E4';
            notes_to_test = [4:6];
        case 3
            instr_str = 'ukulele';
            folder_str = 'matlab/measures/ukulele/body_no_string' ;
            notes_to_test = [1:6];
    end
    
    for measure_index = 1:5
        for note_index = notes_to_test
            note_str = notes_str_arr( note_index, : );
            
            measure_str = [folder_str sprintf('/mesure_z%d.mat', measure_index)];
            audio_str = [folder_name ...
                sprintf('/sound_frf_%s_%s_z%d.wav', note_str,instr_str, measure_index)];

            sound_frf = F_FRF_synthesis( measure_str, note_str, 'point', 0);

            sound_frf = sound_frf/max(abs(sound_frf));
            audiowrite( audio_str, sound_frf, Fs);
        end
    end
end

end
    
    