function q_MHD_strong = get_heating_coefficient_MHD_strong(B_std, B_mean, plasma_density, l_prependicular)
    vacum_permeability = 4*pi()*1e-7; %N/A^2
    q_MHD_strong = 1/(sqrt(vacum_permeability^3*plasma_density))*(B_std)^3/l_prependicular;
end