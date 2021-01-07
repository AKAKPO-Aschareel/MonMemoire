function [y] = DQPSK_Mod(data)

M = 4;

phaserot = pi/4; % phase rotation of the DPSK modulation.

%Generate a sequence of 4-ary random symbols.
data = randi([0 M-1],20,1);
dataIn=data;
%Apply DQPSK modulation to the input symbols.

txSig = dpskmod(dataIn,M,phaserot);
y.txSig= txSig;

figure(1);
hold on;
plot(real(txSig),imag(txSig),'*');
title('Constellation emise')

%Specify a constellation diagram object to display a signal trajectory diagram and without displaying the corresponding reference constellation. Display the trajectory.

%cd = comm.ConstellationDiagram('ShowTrajectory',true,'ShowReferenceConstellation',false);
%cd(txSig)

dataOut = dpskdemod(txSig,M,phaserot);
y.rxsig= dataOut;
y.errs = symerr(dataIn,dataOut);

end



