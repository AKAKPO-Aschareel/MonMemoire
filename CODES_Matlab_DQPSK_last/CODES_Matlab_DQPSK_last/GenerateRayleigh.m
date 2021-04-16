function C = GenerateRayleigh(PowerDelayProfile)
% Generates one Rayleigh channel realization.
%
% function [ C ] = GenerateRayleighChannelReal(PowerDelayProfile, Para)
% function [ C ] = GenerateRayleighChannelReal(PowerDelayProfile, Para, DopplerSpectrum, nFrameSamples)
%
% The function works for SISO and MIMO, time-variant and time-invariant systems.
%
% Input arguments:
%
%   PowerDelayProfile: defines the power delay profile of the channel.
%   Choices are enumerated below and include ITU and 3GPP standard models.
%   'OneTap' is a simple one-tap channel.
%
%   Para: structure containing the modulation parameters.
%
%   DopplerSpectrum: optional parameters that defines the Doppler spectrum
%   of each channel tap. If not defined or 'time_invariant', channel is
%   considered time-invariant. Other options are 'Jakes' and 'Flat'.
%
%   nFrameSamples: number of samples of the frame, needs to be defined if
%   DopplerSpectrum is set to 'Jakes' or 'Flat'.
%
% Outputs arguments:
%
%   C: channel impulse response. Size: multidimensional array [Para.N_R, 
%   Para.N_T, L] if time-invariant and [Para.N_R, Para.N_T, L, nFrameSamples]
%   if time-variant.
%
%   Psi: delay-Doppler spreading function. Size: [] if time-invariant and
%   [Para.N_R, Para.N_T, L, 2*L_nu+1] if time-variant.
%


% This file is part of WaveComBox: www.wavecombox.com and is distributed under
% the terms of the MIT license. See accompanying LICENSE file.
% Original author: François Rottenberg, May 3, 2018.
% Contributors:
% Change log:

switch PowerDelayProfile
    case 'OneTap'
        % ***************************** One tap
        delays=0;
        powers=0;
    % ITU channel models
    case 'ITU_PedA'
        % ***************************** Pedestrian A
        delays=1e-9*[0 110 190 410];
        powers=[0 -9.7 -19.2 -22.8];
    case 'ITU_PedB'
        % ***************************** Pedestrian B
        delays=1e-9*[0 200 800 1200 2300 3700];
        powers=[0 -0.9 -4.9 -8 -7.8 -23.9];
    case 'ITU_EPedA'
        % ***************************** Extended Pedestrian A (EPA)
        delays=1e-9*[0 30 70 90 110 190 410];
        powers=[0 -1 -2 -3 -8 -17.2 -20.8];
    case 'ITU_VehB'
        % ***************************** Vehicular B  (speed 60 km/h)
        delays=1e-9*[0 300 8900 12900 17100 20000];
        powers=[-2.5 0 -12.8 -10 -25.2 -16];
    case 'ITU_VehA'
        % ***************************** Vehicular A  (speed 60 km/h)
        delays=1e-9*[0 300 700 1100 1700 2500];
        powers=[0 -1 -9 -10 -15 -20];
    case 'ITU_EVehA'
        % ***************************** Extended Vehicular A  (EVA)
        delays=1e-9*[0 30 150 310 370 710 1090 1730 2510];
        powers=[0 -1.5 -1.4 -3.6 -0.6 -9.1 -7 -12 -16.9];
    case 'ITU_TUA'
        %****************************** model TU 50 model A
        delays=1e-6*[0 0.217 0.512 0.514 0.517 0.674 0.882 1.230 1.287 1.311 1.349 1.533 1.535 1.622 1.818 1.836 1.884 1.943 2.048 2.140] ;
        powers=[ -5.7 -7.6 -10.1 -10.2 -10.2 -11.5 -13.4 -16.3 -16.9 -17.1 -17.4 -19.0 -19.0 -19.8 -21.5 -21.6 -22.1 -22.6 -23.5 -24.3];
    case 'ITU_ETU'
        %****************************** model Extended typical urban model (ETU)
        delays=1e-9*[0 50 120 200 230 500 1600 2300 5000];
        powers=[-1 -1 -1 0 0 0 -3 -5 -7];
    case 'IC_Hyperlan2'
        % ***************************** indoor channel Hyperlan 2
        delays=1e-9*[0 10 20 30 40 50 60 70 80 90 110 140 170 200 240 290 340 390];
        powers=[0 -0.9 -1.7 -2.6 -3.5 -4.3 -5.2 -6.1 -6.9 -7.8 -4.7 -7.3 -9.9 -12.5 -13.7 -18.0 -22.4 -26.7];
        
        % 3GPP TR 25.943 channel models
    case '3GPP_TU'
        % 3GPP-TU % typical urban
        powers = [-5.7 -7.6 -10.1 -10.2 -10.2 -11.5 -13.4 -16.3 -16.9 -17.1 -17.4 -19.0 -19.0 -19.8 -21.5 -21.6 -22.1 -22.6 -23.5 -24.3];
        delays = [0 217 512 514 517 674 882 1230 1287 1311 1349 1533 1535 1622 1818 1836 1884 1943 2048 2140]*1e-9;
        stem(delays,powers)
    case '3GPP_RA'
        %'3GPP-RA' % rural area
        powers = [-5.2 -6.4 -8.4 -9.3 -10 -13.1 -15.3 -18.5 -20.4 -22.4];
        delays = [0 42 101 129 149 245 312 410 469 528]*1e-9;
        stem(delays,powers)
    case '3GPP_HT'
        %'3GPP-HT' % hilly terrain
        powers = [-3.6 -8.9 -10.2 -11.5 -11.8 -12.7 -13 -16.2 -17.3 -17.7 -17.6 -22.7 -24.1 -25.8 -25.8 -26.2 -29 -29.9 -30 -30.7];
        delays = [0 356 441 528 546 609 625 842 916 941 15000 16172 16492 16876 16882 16978 17615 17827 17849 18016]*1e-9;
    
    case 'DVB_T'
    dabP = [ 0.057662 1.003019 4.855121
          0.176809 5.422091 3.419109
          0.407163 0.518650 5.864470
          0.303585 2.751772 2.215894
          0.258782 0.602895 3.758058
          0.061831 1.016585 5.430202
          0.150340 0.143556 3.952093
          0.051534 0.153832 1.093586
          0.185074 3.324866 5.775198
          0.400967 1.935570 0.154459
          0.295723 0.429948 5.928383
          0.350825 3.228872 3.053023
          0.262909 0.848831 0.628578
          0.225894 0.073883 2.128544
          0.170996 0.203952 1.099463
          0.149723 0.194207 3.462951
          0.240140 0.924450 3.664773
          0.116587 1.381320 2.833799
          0.221155 0.640512 3.334290
          0.259730 1.368671 0.393889];
      
      Ro = dabP(:,1);
      k=1/sqrt(sum(Ro.^2));    % Energy normalization

      powers=Ro.*k;                
      delays = dabP(:,2)*1e-6;
%       Phi = dabP(:,3);

    otherwise
        error('"PowerDelayProfile" not defined')
        
end

SF = 2.048;  % Sampling frequency MHz
Ts = 1/SF;
Ts = Ts * 1e-6;
delays=round(delays/Ts)+1;
nbtaps=length(powers);
L=max(delays);
p_b=zeros(1,L);
variances=10.^(powers/10);
variances=variances/sum(variances);
for i=1:nbtaps
    p_b(delays(i))=p_b(delays(i))+ variances(i);
end

        C=zeros(1,L);
                for b=1:L
                    C(b)=sqrt(p_b(b)/2)*(randn+1j*randn);
                end
