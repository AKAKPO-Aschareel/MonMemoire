function codedRS = Reed_Solomon_Encoder(data,n,k)

%------------------------------------------------------------------------------------------------------
%initialize variables

k= 239; %Longueur d'un paquet de message  (bytes)
n=255; %longueur du mot de code (bytes)
m= 8; % nombre de bits par symboles(bytes)
Nw=2; % nombre de paquets de longueur k

%----------------------------------------------------------------------------------------------------

%Generate Message
%------------------------------------------------
data=randi ([0,1],1,Nw*k*m); % generate msgBits
data=bi2de( reshape (data,Nw*k,m),'left-msb');% convert binary message to decimal integer 
%----------------------------------------------------------------------------------------------------


%Encoder RS
%-------------------------------------------------------------------------------------
Message= gf(data,m); %creates a Galois field array from the data
Message=reshape(Message,Nw,k);
codeRS = rsenc(Message,n,k);
codeRS= reshape(codeRS,Nw,n);












end

