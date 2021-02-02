clear all;
clc;
close all;
fs = 3.84e6;                                     % Hz
pathDelays = [0 200 800 1200 2300 3700]*1e-9;    % sec
avgPathGains = [0 -0.9 -4.9 -8 -7.8 -23.9];      % dB
fD = 50;                                         % Hz

rchan = comm.RayleighChannel('SampleRate',fs, ...
    'PathDelays',pathDelays, ...
    'AveragePathGains',avgPathGains, ...
    'MaximumDopplerShift',fD, ...
    'Visualization','Impulse and frequency responses');
x = randi([0 1],1000,1);
y = rchan(x);