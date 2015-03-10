function testCartesian2CylindricalTransform
import drakeFunction.*
import drakeFunction.frame.*
import drakeFunction.geometry.*

% First test the identity transform, the cylinder is coaxial with the world
% z axis
T1 = eye(4);
fcn1 = Cartesian2CylindricalTransform(T1);
x_cartesian = [1;1;1;0;0;0];
[x_cylinder,dd] = fcn1.eval(x_cartesian);
[~,df] = geval(@(x) fcn1.eval(x),x_cartesian,struct('grad_method','numerical'));
valuecheck(df,dd,1e-3);
valuecheck(x_cylinder(1:3),[sqrt(2);pi/4;1]);
valuecheck(x_cylinder(4:6),[0;0;-pi/4]);
fcn2 = Cylindrical2CartesianTransform(T1);
[pos,dd2] = fcn2.eval(x_cylinder);
valuecheck(x_cartesian,pos,1e-5);
[~,df2] = geval(@(x) fcn2.eval(x),x_cylinder,struct('grad_method','numerical'));
valuecheck(dd2,df2,1e-3);
valuecheck(dd2*dd,eye(6),1e-3);

% Now test random transform for the cylinder
T2 = [rpy2rotmat(randn(3,1)) randn(3,1);0 0 0 1];
fcn3 = Cartesian2CylindricalTransform(T2);
x_cartesian = randn(6,1);
[x_cylinder,dd] = fcn3.eval(x_cartesian);
[~,df] = geval(@(x) fcn3.eval(x),x_cartesian,struct('grad_method','numerical'));
valuecheck(dd,df,1e-3);
fcn4 = Cylindrical2CartesianTransform(T2);
[pos,dd2] = fcn4.eval(x_cylinder);
valuecheck(x_cartesian,pos,1e-5);
[~,df2] = geval(@(x) fcn4.eval(x),x_cylinder,struct('grad_method','numerical'));
valuecheck(dd2,df2,1e-3);
valuecheck(dd2*dd,eye(6),1e-3);
end