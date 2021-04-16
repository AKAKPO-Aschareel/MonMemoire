function qpsk_rot = rotate_const(data,angle)


%QPSK ROTATION ANGLE 
Rotation_angle_degrees=angle;
Rotation_angle_radians= 2 *pi*Rotation_angle_degrees/360;

qpsk_rot=data*exp(1i*Rotation_angle_radians);


end

