function a_dec=ReedSolomon_gf2dec(a,tabb)

a_dec(1:length(a))=0;
nzg = find(a~=0);
a_dec(nzg)=tabb(log(a(nzg))+1);
end

