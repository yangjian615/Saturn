function n = get_density(latitude, H, L)   
    n_0 = 51880e6*(1./L)^4.1;
    n = n_0*exp(-L^2*(1-cos(pi()/180*latitude)^6)./(3*H^2));  
end