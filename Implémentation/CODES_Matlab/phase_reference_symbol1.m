function Phase_Reference = phase_reference_symbol1()

%Program to generate the Phase Reference Symbol for mode I
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%k', i and n parameters obtained from the different tables in the standard
% First af all generate the k', i and n arrays is needed

for k = 1: 1536
    switch k
        case 1
       
            k_bis=1;
            i=0;
            n=1;
        case 33
            k_bis=33;
            i=1;
            n=2;
        case 65
            k_bis=65;
            i=2;
            n=0;

        case 97
            k_bis=97;
            i=3;
            n=1;
        case 129
            k_bis=129;
            i=0;
            n=3;
        case 161
            k_bis=161;
            i=1;
            n=2;
        case 193
            k_bis=193;
            i=2;
            n=2;
        case 225
            k_bis=225;
            i=3;
            n=3;
        case 257
            k_bis=257;
            i=0;
            n=2;
        case 289
            k_bis=289;
            i=1;
            n=1;
        case 321
            k_bis=321;
            i=2;
            n=2;
        case 353
            k_bis=353;
            i=3;
            n=3;
        case 385
            k_bis=385;
            i=0;
            n=1;
        case 417
            k_bis=417;
            i=1;
            n=2;
        case 449
            k_bis=449;
            i=2;
            n=3;
        case 481
            k_bis=481;
            i=3;
            n=3;
        case 513
            k_bis=513;
            i=0;
            n=2;
        case 545
            k_bis=545;
            i=1;
            n=2;
        case 577
            k_bis=577;
            i=2;
            n=2;
        case 609
            k_bis=609;
            i=3;
            n=1;
        case 641
            k_bis=641;
            i=0;
            n=1;
        case 673
            k_bis=673;
            i=1;
            n=3;
        case 705
            k_bis=705;
            i=2;
            n=1;
        case 737
            k_bis=737;
            i=3;
            n=2;
        case 769
            k_bis=769;
            i=0;
            n=3;
        case 801
            k_bis=801;
            i=3;
            n=1;
        case 833
            k_bis=833;
            i=2;
            n=1;
        case 865
            k_bis=865;
            i=1;
            n=1;
        case 897
            k_bis=897;
            i=0;
            n=2;
        case 929
            k_bis=929;
            i=3;
            n=2;
        case 961
            k_bis=961;
            i=2;
            n=1;
        case 993
            k_bis=993;
            i=1;
            n=0;
        case 1025
            k_bis=1025;
            i=0;
            n=2;
        case 1057
            k_bis=1057;
            i=3;
            n=2;
        case 1089
            k_bis=1089;
            i=2;
            n=3;
        case 1121
            k_bis=1121;
            i=1;
            n=3;
        case 1153
            k_bis=1153;
            i=0;
            n=0;
        case 1185
            k_bis=1185;
            i=3;
            n=2;
        case 1217
            k_bis=1217;
            i=2;
            n=1;
        case 1249
            k_bis=1249;
            i=1;
            n=3;
         case 1281
            k_bis=1281;
            i=0;
            n=3;
         case 1313
            k_bis=1313;
            i=3;
            n=3;
         case 1345
            k_bis=1345;
            i=2;
            n=3;
         case 1377
            k_bis=1377;
            i=1;
            n=0;
         case 1409
            k_bis=1409;
            i=0;
            n=3;
         case 1441
            k_bis=1441;
            i=3;
            n=0;
         case 1473
            k_bis=1473;
            i=2;
            n=1;
          case 1505
            k_bis=1505;
            i=1;
            n=1;
    end
        
  
% Get the phase reference symbol

% Calculate phi(k) phase 
h=parameter_h(); % "h" parameter

phi(k)=(pi/2)*(h(i+1,k-k_bis+1)+n);
z(k)=exp(1i*phi(k));

if abs(real(z(k)))<1
  Phase_Reference(k)=1i*imag(z(k));
  
else
    Phase_Reference(k)=real(z(k));
end
    

 


end


end

