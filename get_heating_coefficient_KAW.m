function q_KAW = get_heating_coefficient_KAW(B_std, Larmor_radius, plasma_density, v_phi, v_r, tau,mag_is_1_sheath_is_0)
    vacum_permeability = 4*pi()*1e-7; %N/A^2
    if mag_is_1_sheath_is_0
        q_KAW = (B_std)^3*Larmor_radius/(sqrt(vacum_permeability^3*plasma_density)*v_phi^2*tau^2);
    else
        v_rel = sqrt(v_phi^2+v_r^2);
        q_KAW = (B_std)^3*Larmor_radius/(sqrt(vacum_permeability^3*plasma_density)*v_rel^2*tau^2);
    end
end