function [q_MHD_strong_PS, q_MHD_strong] = get_heating_coefficient_MHD_strong_PS(B_total_std, B_total_mean, power_spectrum, f, density, l_perp, v_phi_rel, k_perp)
    vacum_permeability = 4*pi()*1e-7; %N/A^2
   
%     k_prependicular = 2*pi()*f/v_phi_rel;
    
%     k_prependicular_MHD./k_prependicular
    
%     l_prependicular_scaling_constant = l_prependicular*k_prependicular(1)/(2*pi());
%     
%     l_prependicular_calc = l_prependicular_scaling_constant*2*pi()./k_prependicular;

%     k_perp_scaling_const = 2*pi/(l_perp*k_perp(1));
%     k_perp_calc = k_perp_scaling_const*k_perp;

    del_B_3 = (power_spectrum.*f).^(3/2);
    
%     q_MHD_strong_PS = 1/sqrt(density*vacum_permeability^3)*del_B_3.*k_perp_calc; 
    q_MHD_strong_PS = 1/sqrt(density*vacum_permeability^3)*del_B_3.*k_perp; 
    q_MHD_strong = mean(q_MHD_strong_PS);  
end