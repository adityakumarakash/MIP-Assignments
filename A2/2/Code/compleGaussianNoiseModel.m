function [ p ] = compleGaussianNoiseModel(x, mew)
%  probability density function for joint normal 
%  x is of the form a + ib, where a,b are reals
%  sigma is ignored as it would be absorbed in alpha while manually tuning

z = x-mew;
p = exp(-(z'*z)/2.0)/pi;

end

