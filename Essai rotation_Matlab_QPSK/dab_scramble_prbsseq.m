%% pseudo random binary sequence used to scramble the "DataIn" %%

function prbs_seq = dab_scramble_prbsseq( binary_length )

%procédure

%Initialize variables

srBin= [1 1 1 1 1 1 1 1 1]; %shift register content
prbsBin = zeros (1, binary_length); %initialize output

%Generates prbs sequences
 for i = 1: binary_length
     fedBackBit = xor(srBin(5), srBin(9)); % XOR bits 5 and 9
    prbsBin(i) = fedBackBit;  % Output
    srBin = [fedBackBit, srBin(1:8)];
 end
prbs_seq = prbsBin;