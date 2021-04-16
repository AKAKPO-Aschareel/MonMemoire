function DataOut= Estimation_egalisation(DataIn)


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
       
      
      
NFFT      = 2048; %ascha=2048   
TU    =1000;         
Ro = dabP(:,1);
k=1/sqrt(sum(Ro.^2));    % Energy normalization

Ro=Ro.*k;                
Tau = dabP(:,2);
Phi = dabP(:,3);


    % Initialize data
numSymb = 76;     % Number of symbols

freqIndx = 1:NFFT;
  freqIndx = freqIndx - (NFFT/2) - 1; %centralisation de fréquences
  carSpacing = 1/TU; %espace interporteuse
  freqIndx = 2 * pi * freqIndx * carSpacing; %orthogonalité
  
  % Computes h_f  
  hEstCh = zeros(1,NFFT);
  for k=1:length(Tau)
    hEstCh(1,:) = hEstCh(1,:) + Ro(k) * exp(1i*( Phi(k) - freqIndx*Tau(k)*1e-6));
  end
      
hEst =repmat(hEstCh,[numSymb 1]);
      
% Equalizer

DataOut= DataIn./hEst; %Do the equalisation here so the plot looks nice.
    

end

