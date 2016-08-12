function n = get_density(latitude, H, L)
        water_molar_mass = 18.01528e-3; %kg/mol
        avagdro_number = 6.022140857e23;
        n_0 = 51880e6*(1./L)^4.1;
        n = n_0*exp(-L^2*(1-cos(pi()/180*latitude)^6)./(3*H^2))*water_molar_mass/avagdro_number;
end