% %Rayleigh Channel Profiles  DAB
%  
% % switch pdp
% %         case 'DAB typical rural (non-hilly) area (RA-6)'
% %         powers=[0 -4 -8 -12 -16 - 20];
% %         delays1 =[0.0 0.1 0.2 0.3 0.4 0.5];
% %         delays=delays1.*10^-6;
% %         
%         %case 'DAB  typical urban (non-hilly) area (TU-6)'
%         powers=[-3 0 -2 -6 -8 -10];
%         delays1 =[0.0 0.2 0.5 1.6 2.3 5.0];
%         delays=delays1.*10^-6;
% %         otherwise
% %             error('Wrong PowerDelayProfile type')
% % end
%  Bandwidth= 1.5; %MHz
%   elementary_period = 1/2048000; %s
%   Carrier_spacing= 1; %Khz
%   Taille_FFT=2048;
%   
%   %%
%   % Paramètres Rayleigh
% sampleRate500kHz = 500e3;    % Sample rate of 500K Hz
% sampleRate20kHz  = 20e3;     % Sample rate of 20K Hz
% maxDopplerShift  = 0;      % Maximum Doppler shift of diffuse components (Hz)
% delayVector = (0:5:15)*1e-6; % Discrete delays of four-path channel (s)
% gainVector  = [0 -3 -6 -9];  % Average path gains (dB)
% rayChan = comm.RayleighChannel( ...
%     'SampleRate',          sampleRate500kHz, ...
%     'PathDelays',          delayVector, ...
%     'AveragePathGains',    gainVector, ...
%     'MaximumDopplerShift', maxDopplerShift, ...
%     'RandomStream',        'mt19937ar with seed', ...
%     'Seed',                10, ...
%     'PathGainsOutputPort', true);

clear;
close all;
% fs = 3.84e6;                                     % Hz
% pathDelays = [0 200 800 1200 2300 3700]*1e-9;    % sec
% avgPathGains = [0 -0.9 -4.9 -8 -7.8 -23.9];      % dB
% fD = 50;    
% 
% rchan = comm.RayleighChannel('SampleRate',fs, ...
%     'PathDelays',pathDelays, ...
%     'AveragePathGains',avgPathGains, ...
%     'MaximumDopplerShift',fD);
% 
% x = randi([0 1],1000,1);
% y = rchan(x);
b=2+2i;
A=10+1i;
x = A\b ; %computed differently than x = inv(A)*b and is recommen

y = inv(A)*b;