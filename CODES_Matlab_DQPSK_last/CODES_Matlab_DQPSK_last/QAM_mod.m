function  modSig= QAM_mod(data)
%%%Parameters
L=76; %number of data block
 K=1536; %data carriers
 M=4; %Ordre de modulation
n=2; %bit number
%data size for mode I
%
%
total_bit= K*L*n; 
 
%---------------------------------------------------------------------------------------
 %%
%%Block Partioner

 msgbits= data;
s= length (msgbits);
 
    
   %%%%% GET PADDING%%%%%%
  nb_zero=zeros(1, total_bit-s); %define number of zero
  data_padding= [msgbits nb_zero ];
 
 
data_padding_redim =reshape(data_padding,length (data_padding)/2,n);

%converion binaire en decimal
data_dec = bi2de (data_padding_redim ,'left-msb'); 


 %%QPSK Symbol Mapper
 
 SymboleMap=[2 3 0 1];


  %Mod DATA
 modSig = qammod(data_dec ,M,SymboleMap);
  modSig= modSig.';
end

