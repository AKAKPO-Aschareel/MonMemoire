function  dataDemod_OFDM = Demodulation(dataModulate, pilotes )


% OFDM PARAMETERS Mode I

%K = 1536; %number of sub-carriers

OFDM_symbol_data_block= 75; %symbols without pilots
FFT_length = 2048;
sym_pilots_block= 3; %number of pilots symbols block


%Others variables
Choix =1;

%Get pilots data
pilote_txsig =pilotes; 


%%PROCEDURE


% Remove prefix cyclic
Suppr_CP = dataModulate(1:FFT_length,:);

%-----FFT-----
 FFT_function = fft(Suppr_CP ,FFT_length); % discrete Fourier transform 
 
 %Zero padding remove and reorder
 
 data_after_remove_zeros= [ FFT_function(1281:FFT_length,:) ;  FFT_function(1:768,:)];

 
 %pilots recovery
 pilote_rxsig_recup (:,1:sym_pilots_block) = data_after_remove_zeros(:,1:sym_pilots_block );
 
 %data recovery
 data_recup(:,1: OFDM_symbol_data_block) = data_after_remove_zeros (:, sym_pilots_block+1:end);


 
%estimation et egalisation

 % Estimation de canal
  EQUALIZATION_Type = 'Zero-Forcing'; %choix de la technique d'égalisation 
  
  %Egalisation de canal
  
  if (Choix == 1)
      if strcmp (EQUALIZATION_Type,'Zero-Forcing')==1
          
          %methode du zero forcing
          
          
          %Reponse  fréquentielle du canal 
        channel = sum( ((pilote_rxsig_recup)./( pilote_txsig)),2)/sym_pilots_block ;
        
        %Egaliseur 
        channel_inv= 1./channel;
          
          %egalisation des symboles recus
         u= 1: OFDM_symbol_data_block; 
          sym_recu(:,u) = diag(channel_inv)*data_recup(:,u);
      end    
          
  else
     sym_recu = data_recup; %pas d'egalisation
  end

 %} 
%--------------------------------------------


 dataDemod_OFDM  = sym_recu;
 
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%

% DEMODULATION








