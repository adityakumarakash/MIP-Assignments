%%CS 736: Assignment 2: Question 1 (Diffusion Tensor Magnetic Resonance Imaging)
g = [1,0; 0.866,0.5; 0.5, 0.866; 0,1; -0.5,0.866; -0.866,0.5];
S = [0.5045-0.0217i; 0.6874+0.0171i; 0.3632+0.1789i; 0.3483+0.1385i; 0.2606-0.0675i; 0.2407 + 0.1517i];
S0 = 1;
b0 = 0.1;
a = 1; b = 1; c = 1;
L = [a, 0;b, c];   %L=[a,0; b,c] a>0, c>0
gradient = [0;0;0]; %Initialization of gradient vector
lambda = 0.1; %Step size
while(lambda~= 0)
    resultOld = [a;b;c];
    fOld = 0;
    for i = 1:1:size(g,1)
        gradient(1) = gradient(1) + 2*(S(i)-S0*exp(-b0*g(i,:)*(L*L')*g(i,:)'))*(-S0*exp(-b0*g(i,:)*(L*L')*g(i,:)'))*(-b0*(2*g(i,1)^2*a + 2*g(i,1)*g(i,2)*b));
        gradient(2) = gradient(2) + 2*(S(i)-S0*exp(-b0*g(i,:)*(L*L')*g(i,:)'))*(-S0*exp(-b0*g(i,:)*(L*L')*g(i,:)'))*(-b0*(2*g(i,1)*g(i,2)*a + 2*g(i,2)^2*b));
        gradient(3) = gradient(3) + 2*(S(i)-S0*exp(-b0*g(i,:)*(L*L')*g(i,:)'))*(-S0*exp(-b0*g(i,:)*(L*L')*g(i,:)'))*(-b0*(2*g(i,2)^2*c));
        fOld = fOld + (S(i)-S0*exp(-b0*g(i,:)*(L*L')*g(i,:)'))^2;
    end
    resultNew = resultOld - lambda * abs(gradient);  % Gradient Descent
    a = resultNew(1);
    b = resultNew(2);
    c = resultNew(3);
    L = [a, 0;b, c];   %new L
    fNew = 0;
    for i = 1:1:size(g,1)
        fNew = fNew + (S(i)-S0*exp(-b0*g(i,:)*(L*L')*g(i,:)'))^2;
    end
    if(abs(fNew)<abs(fOld)) %Improved solution
        lambda = lambda*1.1; % Increase step size by 10%
    else
        lambda = 0.5*lambda;
    end
end
D = L*L';
