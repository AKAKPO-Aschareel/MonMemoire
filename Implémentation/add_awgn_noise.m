function [dataout, n] = add_awgn_noise(data,SNRdB,l)

%function to adds awgn noise to signal 
%n= noise vector
L=1; %oversampling ratio

Snr= 10^(SNRdB/10); %Snr to linear scale

TYPE= 'AWGN'; %channel type

switch TYPE
    case 'AWGN'
        
%procédure

%data= reshape (data.',1,size

% signal power generation
P= L*sum(sum(abs(data).^2))/length(data);

% noise  spectral density

No= P/Snr;

%computer noise 
n = sqrt(No/2)*(randn(size(data))+1i*randn(size(data)));


%noisy signal
dataout= data +n; %received signal

    otherwise
        error ('Unknown noise type %s', Type);
        
end
end

