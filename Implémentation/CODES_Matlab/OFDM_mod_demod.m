function [outputArg1,outputArg2] = OFDM_mod_demod(inputArg1,inputArg2)


data= [1 0 0 0 1 1 0 1 0 0 1 1 0 0 0 1];


 modData = QPSK_mod_demod(data);

end

