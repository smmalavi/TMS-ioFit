function y=mep_gen(x)

    theta_true =[   -6.2   -4    0.55    7.2282];
    noise_y=.5*rand(1,length(x))

    y=theta_true(1)+(theta_true(2)-theta_true(1))./(1+10.^((theta_true(3)-x)*theta_true(4)))+noise_y;

end