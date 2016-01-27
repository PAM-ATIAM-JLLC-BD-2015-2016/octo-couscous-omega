
function F_make_all_FRF_synthesis_sounds(version_name_str)

Nfft = 2^19;
Fs = 25600;

folder_name = ['sounds/frf/' date() '_' version_name_str];
mkdir(folder_name);

for folder_index = 1:3
    switch folder_index
        case 1
            note_str = 'E2';
            instr_str = 'guitar';
            folder_str = 'matlab/measures/yamaha-c40_1/body-no_string_E2';        
        case 2
            note_str = 'E4';
            instr_str = 'guitar';
            folder_str = 'matlab/measures/yamaha-c40_1/body-no_string_E4';
        case 3
            note_str = 'E4';
            instr_str = 'ukulele';
            folder_str = 'matlab/measures/ukulele/body_no_string' ;
    end
    
    for measure_index = 1:5
        measure_str = [folder_str sprintf('/mesure_z%d.mat', measure_index)];
        audio_str = [folder_name ...
            sprintf('/sound_frf_%s_%s_z%d.wav', instr_str, note_str, measure_index)];
        
        sound_frf = F_FRF_synthesis( measure_str, note_str, 'point', 0);
        %figure, plot(sound_frf);
        %soundsc(sound_frf,Fs);

        %figure, plot([0:Nfft-1]*Fs/Nfft,db(fft(sound_frf,Nfft)));
        %xlim([0 5000])

        sound_frf = sound_frf/max(abs(sound_frf));
        audiowrite( audio_str, sound_frf, Fs);

    end
end

end
    
    