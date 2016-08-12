function [q_KAW_PS, q_KAW] = get_heating_coefficient_KAW_PS(B_total_std, power_spectrum, f, larmor_radius, density, k_prependicular)
    vacum_permeability = 4*pi()*1e-7; %N/A^2                                      
    
    del_B_3 = (power_spectrum.*f).^(3/2);

    q_KAW_PS = del_B_3*larmor_radius/(sqrt(vacum_permeability^3*density)).*k_prependicular.^2;
    
    q_KAW = mean(q_KAW_PS);
    
end