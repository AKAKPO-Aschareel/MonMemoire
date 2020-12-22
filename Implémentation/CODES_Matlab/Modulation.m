
function dataModulate = Modulation(OFDM_Parameters,inputdata)

%Initialisation des variables
%----------------------------------------------------------------------------------


% OFDM PARAMETERS Mode I
M_IFFT = OFDM_Parameters.M_IFFT ; %number of sub-carriers 

cp = OFDM_Parameters.cp;  % définition du préfixe cyclique

 
%---------------------------------------------------------------------------------------
 

modDataQpsk = inputdata;


%{
% Pilots symbols
 pilote_OFDM = modPilote();

dataEnd= [pilote_OFDM modData]; %concatenation pilotes+data
%}

 dataEnd= modDataQpsk; 
 
 
%-----IFFT-----
 IFFT_function= ifft(dataEnd,M_IFFT); %Inverse discrete Fourier transform 
 
 %%%% Préfix cyclic
    Ajout_CP = [ IFFT_function; IFFT_function(1:cp,:)];
    
    dataModulate = Ajout_CP;
 
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


