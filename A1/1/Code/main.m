%%
% CS 736: Medical Image Processing
% Assignment 1
% Aditya Kumar Akash 120050046, Praveen Agrawal 12D020030
%%
% Question 1
% Part (a)
% The step size is kept as a parameter. This is to allow us to use the
% function with different values of step size without changing any code.
% For the interpolation function, we have selected cubic interpolation.The
% reason linear interpolation causes some softening of details and can 
% somewhat jagged. But cubic interpolation takes care of these.

% Part (b,c)
tic;
f = phantom(128);
t = [-90 : 5 : 90];

ds = 0.5;
rT1 = myRadonTrans(f, ds);
figure;
imagesc(rT1);
title(num2str(ds), 'FontWeight', 'bold');
save ('../Output Images/radonTransform_0.5stepSize', 'rT1');
rt0 = rT1(:, 1);
rt90 = rT1(:, 19);
figure;
plot(t, rt0);
title('Theta  = 0, stepSize = 0.5', 'FontWeight', 'bold');
xlabel('t Values');
ylabel('Radon Transform Values');
figure;
plot(t, rt90);
title('Theta  = 90, stepSize = 0.5', 'FontWeight', 'bold');
xlabel('t Values');
ylabel('Radon Transform Values');



ds = 1.0;
rT2 = myRadonTrans(f, ds);
figure;
imagesc(rT2);
title(num2str(ds), 'FontWeight', 'bold');
save ('../Output Images/radonTransform_1.0stepSize', 'rT2');
rt0 = rT2(:, 1);
rt90 = rT2(:, 19);
figure;
plot(t, rt0);
title('Theta  = 0, stepSize = 1.0', 'FontWeight', 'bold');
xlabel('t Values');
ylabel('Radon Transform Values');
figure;
plot(t, rt90);
title('Theta  = 90, stepSize = 1.0', 'FontWeight', 'bold');
xlabel('t Values');
ylabel('Radon Transform Values');



ds = 3.0;
rT3 = myRadonTrans(f, ds);
figure;
imagesc(rT3);
title(num2str(ds), 'FontWeight', 'bold');
save ('../Output Images/radonTransform_3.0stepSize', 'rT3');
rt0 = rT3(:, 1);
rt90 = rT3(:, 19);
figure;
plot(t, rt0);
title('Theta  = 0, stepSize = 3.0', 'FontWeight', 'bold');
xlabel('t Values');
ylabel('Radon Transform Values');
figure;
plot(t, rt90);
title('Theta  = 90, stepSize = 3.0', 'FontWeight', 'bold');
xlabel('t Values');
ylabel('Radon Transform Values');
toc;
