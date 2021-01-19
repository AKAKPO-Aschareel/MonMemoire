
function dataModulate = Modulation(inputdata)

%Initialisation des variables
%----------------------------------------------------------------------------------


% OFDM PARAMETERS Mode I
M_IFFT = 1536; %number of sub-carriers 

%symbol length TsymOFDM = Tguard + Tu =  0.246 + 1.0 = 1.246ms
%fraction de IG = 0.246/1.0
%cp = 246/1000 * Para.M_IFFT = +377.8560;
% sub carrier spacing : 1kHz

cp = 378;  % définition du préfixe cyclique

 %nbPilotes = 25; %nombre de paquets  pilotes
%nbitsPilotes = M_IFFT * nbPilotes * n ; %nombre total de bits des pilotes

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


