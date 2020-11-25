function prbs_seq = dab_scramble_prbsseq( K_RS )

%procédure

%Initialize variables

K_RS=36; % length of data input
srBin= [1 1 1 1 1 1 1 1 1]; %shift register content
prbsBin = zeros (1, K_RS); %initialize output

%Generates prbs sequences
 for i = 1: K_RS
     fedBackBit = xor(srBin(5), srBin(9)); % XOR bits 5 and 9
    prbsBin(i) = fedBackBit;  % Output
    srBin = [fedBackBit, srBin(1:8)];
 end
prbs_seq = prbsBin;