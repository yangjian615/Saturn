function q_KAW = get_heating_coefficient_KAW(B_std, Larmor_radius, plasma_density, l_perp)
    vacum_permeability = 4*pi()*1e-7; %N/A^2
    k_perp = 1/l_perp;
    q_KAW = (B_std)^3*Larmor_radius*k_perp^2/sqrt(vacum_permeability^3*plasma_density);

end