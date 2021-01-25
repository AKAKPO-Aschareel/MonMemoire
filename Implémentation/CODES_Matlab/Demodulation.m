
function  dataDemod_OFDM = Demodulation(dataModulate )

%Initialize variables;


% OFDM PARAMETERS Mode I

M_IFFT = 1536; %number of sub-carriers
dataOfdm = 75; % nombres de paquets OFDM


 %nbPilotes = 10; %nombre de paquets  pilotes
%nbitsPilotes = M_IFFT * nbPilotes * n ; %nombre total de bits des pilotes


%Others variables
%Choix =1;


%pilote_txsig =pilotes; 


%%PROCEDURE


% Remove prefix cyclic
Suppr_CP = dataModulate(1:M_IFFT,:);

%-----FFT-----
 FFT_function = fft(Suppr_CP ,M_IFFT); % discrete Fourier transform 

 %{
 %pilots recovery
 pilote_rxsig_recup (:,1:nbPilotes) = FFT_function(:,1:nbPilotes );
 
 %data recovery
 data_recup(:,1:dataOfdm) = FFT_function (:, nbPilotes+1:end);


 
%estimation et egalisation

 % Estimation de canal
  EQUALIZATION_Type = 'Zero-Forcing'; %choix de la technique d'égalisation 
  
  %Egalisation de canal
  
  if (Choix == 1)
      if strcmp (EQUALIZATION_Type,'Zero-Forcing')==1
          
          %methode du zero forcing
          
          
          %Reponse  fréquentielle du canal 
        channel = sum( ((pilote_rxsig_recup)./( pilote_txsig)),2)/nbPilotes ;
        
        %Egaliseur 
        channel_inv= 1./channel;
          
          %egalisation des symboles recus
         u= 1: dataOfdm; 
          sym_recu(:,u) = diag(channel_inv)*data_recup(:,u);
      end    
          
  else
     sym_recu = data_recup; %pas d'egalisation
  end

 %} 
%--------------------------------------------

 dataDemod_OFDM  = FFT_function;
 %dataDemod_OFDM  = sym_recu;
 
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%

% DEMODULATION








