function modSig = QAM_16_mod(data)
%%%Parameters
L=76; %number of data block
 K=1536; %data carriers
 M=16; %Ordre de modulation
n=4; %bit number

total_bit= K*L*n; 
 
%---------------------------------------------------------------------------------------
 %%
%%Block Partioner

 msgbits= data;
s= length (msgbits);
 
    
   %%%%% GET PADDING%%%%%%
  nb_zero=zeros(1, total_bit-s); %define number of zero
  data_padding= [msgbits nb_zero ];
 
 
data_padding_redim =reshape(data_padding,length (data_padding)/4,n);

%converion binaire en decimal
data_dec = bi2de (data_padding_redim ,'left-msb'); 


 %%QPSK Symbol Mapper
 
 SymboleMap=[8 9 13 12 10 11 15 14 2 3 7 6 0 1 5 4];


  %Mod DATA
 modSig = qammod(data_dec ,M,SymboleMap);
  modSig= modSig.';
end

