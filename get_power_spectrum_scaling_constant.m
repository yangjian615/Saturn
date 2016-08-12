function [power_spectrum_scaling_constant] = get_power_spectrum_scaling_constant(B_total_std, power_spectrum, f)
    P_f_integral = trapz(f, power_spectrum);
    power_spectrum_scaling_constant = B_total_std^2/(P_f_integral);
end