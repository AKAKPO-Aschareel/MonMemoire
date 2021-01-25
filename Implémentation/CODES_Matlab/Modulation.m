
function  dataModulate = Modulation(inputdata)


% OFDM PARAMETERS Mode I

M_IFFT = 1536; %number of sub-carriers
OFDM_symbol_block = 76; %total number symbol of OFDM 
FFT_length = 2048;
T = 1/2048000; %elementary period in secondes
Tguard = 504* T; %Guard interval duration
Tu = 2048*T; %symbol duration without Tguard

IG_fraction = Tguard/Tu ; %fraction de IG
cp = IG_fraction * FFT_length ;  % cyclic  préfix



%cp = fraction de IG * FFT_length = 504;
% sub carrier spacing : 1kHz
%Max RF frequency 375 Mhz


 

DQPSK_data = inputdata;
 
%Add phase reference symbol at the beginning to achieve the total number
%symbol of OFDM 

initial_phase_reference = phase_reference_symbol1()  ;
initial_phase_reference_sym=initial_phase_reference';
 
Data= [initial_phase_reference_sym DQPSK_data ];

%Zero padding and Rearrangement data in the zero padding

 m= FFT_length-M_IFFT  ; %add zero to each dqpsk symbols block (512 zeros)
 
DataOFDM_after_zero_padding= [Data(769:1536,:) ; zeros(m,OFDM_symbol_block);Data(1:768,:)];



%-----IFFT-----
 IFFT_function= ifft(DataOFDM_after_zero_padding,FFT_length); %Inverse discrete Fourier transform 
 
 %%%% Préfix cyclic
 
 Ajout_CP = [ IFFT_function; IFFT_function(1:cp,:)];
    
    dataModulate = Ajout_CP;
 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



end
%%%%%%%%%%%%%%%%%%%%%%%%%


