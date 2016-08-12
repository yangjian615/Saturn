function [gyration_frequency] = get_gyration_frequency(magnetometer_data_to_analyze,mag_is_1_sheath_is_0)
%     
% %     calculating curves for Kolmogorov and one over power laws
%     x_fit_plot = [1E-6:1E-6:1];
%     exponent_Kolmogorov = -5/3;
%     exponent_over_one = -1;
%     fit_Kolmogorob = x_fit_plot.^exponent_Kolmogorov;
% 
% 
%     calculating and plotting gyration frequency
    charge = 1.602E-19;
    avagdro_number = 6.022e23;

    if mag_is_1_sheath_is_0
        water_molar_mass = 18.01528/1000;
        gyration_frequency = charge*mean(magnetometer_data_to_analyze)/(water_molar_mass/avagdro_number);
    else
        proton_molar_mass = 1/1000;
        gyration_frequency = charge*mean(magnetometer_data_to_analyze)/(proton_molar_mass/avagdro_number);
    end
%     gyration_frequency_plot = [1e-10:1e5:1e10];
%     gyration_frequency_plot_x(1:length(gyration_frequency_plot)) = gyration_frequency;
%     plot(gyration_frequency_plot_x, gyration_frequency_plot, 'b') 
% 
%     legend('power spectrum', 'Kolmogorov spectrum exponent -5/3', 'exponent -1', 'gyration frequency')
end