clear all;
x=randi([0,1],1,20);
y= reshape (x,4,5);
z=y';
E =z(:);
data=randi([0,1],1,12);
intrlvd = matintrlv(data,3,4);
