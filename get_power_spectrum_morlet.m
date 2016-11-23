function [f, power_spectrum] = get_power_spectrum_morlet(B_fluctuation_perp, B_total_std, delta_t)
% 	N = length(B_fluctuation_perp);
% 	lag = floor(N*600/3600);
%             
%     B_r = B_fluctuation_perp(1,:).';
%     B_theta = B_fluctuation_perp(2,:).';
%     B_phi = B_fluctuation_perp(2,:).';
%             
%     B_r_ma = tsmovavg(B_r, 's', lag, 1);
%     B_theta_ma = tsmovavg(B_theta, 's', lag, 1);
%     B_phi_ma = tsmovavg(B_phi, 's', lag, 1);
%     B_tot_ma = tsmovavg(mag_data_to_analyze(18,:).', 's', lag, 1);
            
%             mag_fft_analysis_r = ((B_r(lag:N) - B_r_ma(lag:N)).*blackman(N-lag+1)).';
%             mag_fft_analysis_theta = ((B_theta(lag:N) - B_theta_ma(lag:N)).*blackman(N-lag+1)).';
%             mag_fft_analysis_phy = ((B_phy(lag:N) - B_phy_ma(lag:N)).*blackman(N-lag+1)).';
%             mag_fft_analysis_tot = ((mag_data_to_analyze(18,lag:N).' - B_tot_ma(lag:N)).*blackman(N-lag+1)).';
%             
%             mag_fft_analysis_r = ((B_r(lag:N) - B_r_ma(lag:N))).';
%             mag_fft_analysis_theta = ((B_theta(lag:N) - B_theta_ma(lag:N))).';
%             mag_fft_analysis_phi = ((B_phi(lag:N) - B_phi_ma(lag:N))).';
%             mag_fft_analysis_tot = ((mag_data_to_analyze(18,lag:N).' - B_tot_ma(lag:N))).';            
            
%             mag_fft_analysis_r = ((B_r - mean(B_r)).*blackman(N)).';
%             mag_fft_analysis_r = mag_fft_analysis_r - mean(mag_fft_analysis_r);
%             
%             mag_fft_analysis_theta = ((B_theta - mean(B_theta)).*blackman(N)).';
%             mag_fft_analysis_theta = mag_fft_analysis_theta - mean(mag_fft_analysis_theta);
%             
%             mag_fft_analysis_phy = ((B_phy - mean(B_phy)).*blackman(N)).';
%             mag_fft_analysis_phy = mag_fft_analysis_phy - mean(mag_fft_analysis_phy);
%             
%             mag_fft_analysis_tot = ((mag_data_to_analyze(18,:).' - mean(mag_data_to_analyze(18,:))).*blackman(N)).'; 
%             mag_fft_analysis_tot = mag_fft_analysis_tot - mean(mag_fft_analysis_tot);
% 
% 	mag_fft_analysis_r = ((B_r - mean(B_r))).';
% 	mag_fft_analysis_theta = ((B_theta - mean(B_theta))).';
% 	mag_fft_analysis_phi = ((B_phy - mean(B_phy))).';
% 	mag_fft_analysis_tot = ((B_tot - mean(B_tot.'))).'; 
    
%     mag_fft_analysis_r = ((B_fluctuation_perp(1,:) - mean(B_fluctuation_perp(1,:))));
%     mag_fft_analysis_theta = ((B_fluctuation_perp(2,:) - mean(B_fluctuation_perp(2,:))));
%     mag_fft_analysis_phi = ((B_fluctuation_perp(3,:) - mean(B_fluctuation_perp(3,:))));

%     mag_fft_analysis_r = ((B_fluctuation_perp(1,:) - mean(B_fluctuation_perp(1,:))));
%     mag_fft_analysis_theta = ((B_fluctuation_perp(2,:) - mean(B_fluctuation_perp(2,:))));
%     mag_fft_analysis_phi = ((B_fluctuation_perp(3,:) - mean(B_fluctuation_perp(3,:))));
% 

%     mag_fft_analysis_r = B_fluctuation_perp(1,:);
%     mag_fft_analysis_theta = B_fluctuation_perp(2,:);
%     mag_fft_analysis_phi = B_fluctuation_perp(3,:);
%     
%     [f, power_spectrum_r, N] = power_spectrum_morlet(mag_fft_analysis_r, delta_t);
% 	[f, power_spectrum_theta, N] = power_spectrum_morlet(mag_fft_analysis_theta, delta_t);
% 	[f, power_spectrum_phi, N] = power_spectrum_morlet(mag_fft_analysis_phi, delta_t); 
    
%     [f, power_spectrum_r] = power_spectrum_fft(mag_fft_analysis_r);
% 	[f, power_spectrum_theta] = power_spectrum_fft(mag_fft_analysis_theta);
% 	[f, power_spectrum_phi] = power_spectrum_fft(mag_fft_analysis_phi);   

%     power_spectrum_tot = power_spectrum_r + power_spectrum_theta + power_spectrum_phi;
%     power_spectrum_tot = 2/(N*delta_t)*power_spectrum_tot;
%---------------------------------------------------------------------------------------------------------------------------    
%     B_fluctuation_perp_mag = sqrt(B_fluctuation_perp(1,:).^2 + B_fluctuation_perp(2,:).^2 + B_fluctuation_perp(3,:).^2);
%     
%     [f, power_spectrum_tot, N] = power_spectrum_morlet(B_fluctuation_perp_mag, delta_t);
% %     power_spectrum_tot = 1./(4*sin(pi*f*delta_t).^2)*2*delta_t/N.*power_spectrum_tot;
%     power_spectrum_tot = 2/(N*delta_t)*power_spectrum_tot;
% %     power_spectrum_tot = power_spectrum_r + power_spectrum_theta + power_spectrum_phi;
%     
%     [power_spectrum_scaling_constant] = get_power_spectrum_scaling_constant(B_total_std, power_spectrum_tot, f);
%     
%     
% %     power_spectrum = power_spectrum_scaling_constant*power_spectrum_tot;
%     power_spectrum = power_spectrum_tot;    
%---------------------------------------------------------------------------------------------------------------------------    
    [f, power_spectrum_tot_r,N] = power_spectrum_morlet(B_fluctuation_perp(1,:),delta_t);
    [f, power_spectrum_tot_theta,N] = power_spectrum_morlet(B_fluctuation_perp(2,:),delta_t);
    [f, power_spectrum_tot_phy,N] = power_spectrum_morlet(B_fluctuation_perp(3,:),delta_t);
    
    power_spectrum_tot = sqrt(power_spectrum_tot_r.^2 + power_spectrum_tot_theta.^2 + power_spectrum_tot_phy.^2);
    
%     B_fluctuation_perp_mag = sqrt(B_fluctuation_perp(1,:).^2 + B_fluctuation_perp(2,:).^2 + B_fluctuation_perp(3,:).^2);
%     
%     [f, power_spectrum_tot, N] = power_spectrum_morlet(B_fluctuation_perp_mag, delta_t);
%     power_spectrum_tot./power_spectrum_tot_comp
    
    
%     power_spectrum_tot = 1./(4*sin(pi*f*delta_t).^2)*2*delta_t/N.*power_spectrum_tot;
%     power_spectrum_tot = 2/(N*delta_t)*power_spectrum_tot;
    power_spectrum_tot = 2/N*power_spectrum_tot;
%     [power_spectrum_scaling_constant] = get_power_spectrum_scaling_constant(B_total_std, power_spectrum_tot, f);
%     power_spectrum = power_spectrum_scaling_constant*power_spectrum_tot;
    power_spectrum = power_spectrum_tot;   
end