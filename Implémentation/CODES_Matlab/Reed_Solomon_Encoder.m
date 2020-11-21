function codedRS = Reed_Solomon_Encoder(data,n,k)
%UNTITLED9 Summary of this function goes here

%------------------------------------------------------------------------------------------------------
%initialize variables

k= 239; %Longueur du message  (bytes)
n=255; %longueur du mot de code (bytes)
m= 8; % nombre de bits par symbole
Nw=2; % nombre de paquets de longeur k

%----------------------------------------------------------------------------------------------------

%Generate Message
%------------------------------------------------
data=randi ([0,1],1,3824); % generate msgBits= Nw*K*m
data=bi2de( reshape (data,478,m),'left-msb');% convert binary message to decimal integer (478= Nw*k)
%----------------------------------------------------------------------------------------------------


%Encoder RS
%-------------------------------------------------------------------------------------
Message= gf(data,m); %creates a Galois field array from the data
Message=reshape(Message,Nw,k);
codeRS = rsenc(Message,n,k);
codeRS= reshape(codeRS,Nw,n);












end

