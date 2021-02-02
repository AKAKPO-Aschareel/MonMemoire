
function  dataModulate = Modulation(inputdata, pilote_OFDM)


% OFDM PARAMETERS Mode I

K = 1536; %number of sub-carriers
OFDM_symbol_block = 78; %total number symbol of OFDM 
FFT_length = 2048;
T = 1/2048000; %elementary period in secondes
Tguard = 504* T; %Guard interval duration
Tu = 2048*T; %symbol duration without Tguard

IG_fraction = Tguard/Tu ; %fraction de IG
cp = IG_fraction * FFT_length ;  % cyclic  préfix



%cp = fraction de IG * FFT_length = 504;
% sub carrier spacing : 1kHz
%Max RF frequency 375 Mhz


 
%Get DQPSK symbols 
DataOFDM = inputdata;

%Get pilots symbols 
 pilote_data = pilote_OFDM;

%Insert pilots symbols
DataEnd = [pilote_data DataOFDM];

%Zero padding and Rearrangement data in the zero padding

 m= FFT_length-K  ; % size of zeros to each dataEnd  block (512 zeros)
 
DataOFDM_after_zero_padding= [DataEnd(769:1536,:) ; zeros(m,OFDM_symbol_block);DataEnd(1:768,:)];



%-----IFFT Block-----
 IFFT_function= ifft(DataOFDM_after_zero_padding,FFT_length); %Inverse discrete Fourier transform 
 
 %-----Cyclic Prefix-----
 
 Ajout_CP = [ IFFT_function; IFFT_function(1:cp,:)];
    
    dataModulate = Ajout_CP;
 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



end
%%%%%%%%%%%%%%%%%%%%%%%%%


