function [y] = SSsigmoidFunc(x,theta,noise_vec)

%y=theta(1)+(theta(2)-theta(1))./(1+theta(3)*x.^-theta(4))+sigma_y*randn(1,length(x));
y=theta(1)+(theta(2)-theta(1))./(1+10.^((theta(3)-x).*theta(4)))+noise_vec;

%y=real(y);

