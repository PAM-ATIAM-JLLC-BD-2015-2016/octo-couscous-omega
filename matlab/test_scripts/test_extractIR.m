
clear all, close all, clc;

Fs = 25600;
%measure_name = 'body_z.mat';
measure_name = 'parfait_45.mat';

extract_IR2WAV( measure_name, Fs*0.5 );
