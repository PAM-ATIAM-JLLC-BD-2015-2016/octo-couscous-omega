clear all, close all, clc;

[x,Fs] = audioread('ClocheA.wav');
K = 54; n = 512; N = 1535;

x = x(10000:10000+N-1);
[f,a,delta,phi] = F_esprit_pam(x,Fs,K,N,n,1);