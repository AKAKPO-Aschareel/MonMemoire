function  modSig= DQPSKMOD(data)

%%%Parameters
L=76; %number of data block
 K=1536; %data carriers

%data size for mode I
% total_bit=fic_bit + msc_bit 
%
%
n=2; %bit number
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
 %%pi/4 DQPSK Symbol Mapper

 %Create a DQPSK modulator
 dqpskmod = comm.DQPSKModulator(pi/4,'BitInput',false);
 
 %Mod DATA
 modSig = dqpskmod(data_dec);
  modSig= modSig.';
end


