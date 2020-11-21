clear all;
x=randi([0,1],1,20);
y= reshape (x,4,5);
z=y';
E =z(:);

intrlvd = matintrlv(x,5,4);
m=intrlvd(:);
