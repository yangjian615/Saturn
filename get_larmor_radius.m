function larmor_radius=get_larmor_radius(T, B_mean,mag_is_1_sheath_is_0)

    avagdro_number = 6.022140857e23;    
    k_B = 1.3806488e-23; %J/K
    Z = 1;
    e = 1.60217657e-19; %coulombs
    
    if mag_is_1_sheath_is_0
        water_molar_mass = 18.01528e-3; %kg/mol
        larmor_radius = sqrt(water_molar_mass/avagdro_number*k_B*T)/(Z*e*B_mean);
    else
        proton_molar_mass = .001;
        larmor_radius = sqrt(proton_molar_mass/avagdro_number*k_B*T)/(Z*e*B_mean);
    end
end