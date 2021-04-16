
function dataModulate= Modulation(inputdata)


% OFDM PARAMETERS Mode I

K = 1536; %number of sub-carriers data
OFDM_symbol_block = 76; %total number symbol of OFDM 
FFT_length = 2048;

T = 1/2048000; %elementary period in secondes
Tguard = 504* T; %Guard interval duration
Tu = 2048*T; %symbol duration without Tguard

IG_fraction = Tguard/Tu ; %fraction de IG
cp = IG_fraction * FFT_length ;  % cyclic  préfix
OFDM_length=2552; %FFT_length+cp
Tnull=2656; %Null_Symbol_Duration

%cp = fraction de IG * FFT_length = 504;
% sub carrier spacing : 1kHz

 %Procédure
%Get DQPSK symbols after interleaving
DataOFDM = reshape(inputdata,76,1536);

%Zero padding 

 m= FFT_length-K  ; % size of zeros to each dataEnd  block (512 zeros)
 
DataOFDM_after_zero_padding= [DataOFDM(:,769:1536)  zeros(OFDM_symbol_block,m) DataOFDM(:,1:768)];



%-----IFFT Block-----

 IFFT_function= ifft(DataOFDM_after_zero_padding,FFT_length,2); %Inverse discrete Fourier transform 
 
   

 
 %-----Cyclic Prefix-----
 
 Ajout_CP = [ IFFT_function IFFT_function(:,1:cp)];
    
    dataModulate = Ajout_CP;
 

 

end
%%%%%%%%%%%%%%%%%%%%%%%%%


