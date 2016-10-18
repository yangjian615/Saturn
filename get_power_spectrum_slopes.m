function [coeff_MHD, coeff_KAW, f_MHD, f_KAW, power_spectrum_MHD, power_spectrum_KAW] = get_power_spectrum_slopes(f, power_spectrum, gyration_frequency)
     
        f_MHD = f(f < gyration_frequency/1.5 & f > 3E-3 & f < 1E-1);
        power_spectrum_MHD = power_spectrum(f < gyration_frequency/1.5 & f > 3E-3 & f < 1E-1);
        
        f_KAW = f(f > gyration_frequency*1.5 & f < 1E-1 & f > 3E-3);
        power_spectrum_KAW = power_spectrum(f > gyration_frequency*1.5 & f < 1E-1 & f > 3E-3);  
        
        length_f_MHD = length(f_MHD);
        length_f_KAW = length(f_KAW);
        
        
        if  length_f_MHD > 5 & length_f_KAW > 5
            coeff_MHD = coeffvalues(fit(log(f_MHD.'), log(power_spectrum_MHD.'), 'poly1'));
            coeff_KAW = coeffvalues(fit(log(f_KAW.'), log(power_spectrum_KAW.'), 'poly1')); 
%             coeff_MHD = coeffvalues(fit(f1_slope.', power_spectrum_1_slope.', 'power1')); 
%             coeff_KAW = coeffvalues(fit(f2_slope.', power_spectrum_2_slope.', 'power1'));
        elseif length_f_MHD < 5 & length_f_KAW > 5
            coeff_MHD = [0, 0];
            f_MHD = [];
            power_spectrum_MHD = [];
            coeff_KAW = coeffvalues(fit(log(f_KAW.'), log(power_spectrum_KAW.'), 'poly1'));  
%             coeff_KAW = coeffvalues(fit(f2_slope.', power_spectrum_2_slope.', 'power1'));
        elseif length(f_KAW) < 5 & length_f_MHD > 5
            coeff_MHD = coeffvalues(fit(log(f_MHD.'), log(power_spectrum_MHD.'), 'poly1'));
%             coeff_MHD = coeffvalues(fit(f1_slope.', power_spectrum_1_slope.', 'power1')); 
            coeff_KAW = [0, 0];
            f_KAW = [];
            power_spectrum_KAW = [];
        else
            coeff_MHD = [0, 0];
            f_MHD = [];
            power_spectrum_MHD = [];
            coeff_KAW = [0, 0];
            f_KAW = [];
            power_spectrum_KAW = 0;
        end
 
end