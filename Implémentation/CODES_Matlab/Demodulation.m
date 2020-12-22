
function dataDemod_OFDM = Demodulation(OFDM_Parameters,dataModulate)

%Initialize variables;


% OFDM PARAMETERS Mode I

M_IFFT = OFDM_Parameters.M_IFFT; %number of sub-carriers 

%nbPilotes=OFDM_Parameters.nbPilotes; %nombre de paquets  pilotes
%dataPilotes = OFDM_Parameters.nbitsPilotes ; %nombre total de bits des pilotes


%Others variables
%Choix =1;





%%PROCEDURE


% Remove prefix cyclic


Suppr_CP = dataModulate(1:M_IFFT,:);

%-----FFT-----
 FFT_function = fft(Suppr_CP ,M_IFFT); % discrete Fourier transform 

%{ 
 %pilots recovery
 pilote_recup (:,1:nbPilotes) = FFT_function(:,1:nbPilotes );
 
 %data recovery
 data_recup(:,1:dataOfdm) = FFT_function (:, nbPilotes+1:end);


 
%estimation et egalisation

 % Estimation de canal
  EQUALIZATION_Type = 'Zero-Forcing'; %choix de la technique d'égalisation 
  
  %Egalisation de canal
  
  if (Choix == 1)
      if strcmp (EQUALIZATION_Type,'Zero-Forcing')==1 %methode du zero forcing
          pilote_OFDM = modPilote();
        channel = sum( ((pilote_recup)./( pilote_OFDM)),2)/nbPilotes ;
         channel_inv= 1./channel;
          
          %egalisation des symboles recus
         u= 1: dataOfdm; 
          sym_recu(:,u) = diag(channel_inv)*data_recup(:,u);
      end    
          
  else
     sym_recu = data_recup; %pas d'egalisation
  end

  
%--------------------------------------------
%}
 dataDemod_OFDM  = FFT_function;
 
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%

% DEMODULATION








