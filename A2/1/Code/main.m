%%CS 736: Assignment 2: Question 1 (Diffusion Tensor Magnetic Resonance Imaging)
g = [1,0; 0.866,0.5; 0,1; -0.5,0.866; -0.866,0.5];
S = [0.5045-0.0217i; 0.6874+0.0171i; 0.3632+0.1789i; 0.3483+0.1385i; 0.2606-0.0675i; 0.2407 + 0.1517i];
S0 = 1;
b0 = 0.1;
a = 0; b = 0; c = 0;
L = [a, 0;b, c];   %L=[a,0; b,c] a>0, c>0
result = [a;b;c];
gradient = [0;0;0]; %Initialization of gradient vector
lambda = 0.1; %Step size
for i = 1:1:6
    gradient(0) = gradient(0) + 2*(S(i)-S0*exp(-b0*g(i,:)*L*L'*g(i,:)'))*(-S0*exp(-b0*g(i,:)*L*L'*g(i,:)'))*(-b0*(2*g(i,1)^2*a + 2*g(i,1)*g(i,2)*b));
    gradient(1) = gradient(1) + 2*(S(i)-S0*exp(-b0*g(i,:)*L*L'*g(i,:)'))*(-S0*exp(-b0*g(i,:)*L*L'*g(i,:)'))*(-b0*(2*g(i,1)*g(i,2)*a + 2*g(i,2)^2*b));
    gradient(2) = gradient(2) + 2*(S(i)-S0*exp(-b0*g(i,:)*L*L'*g(i,:)'))*(-S0*exp(-b0*g(i,:)*L*L'*g(i,:)'))*(-b0*(2*g(i,2)^2*c));
end