function f = delete_rotate_const(data,angle)

%suppression de rotation de constellation
%QPSK ROTATION ANGLE 
Rotation_angle_degrees=angle;
Rotation_angle_radians= 2 *pi*Rotation_angle_degrees/360;



f= data*exp(-1i*Rotation_angle_radians);

end

