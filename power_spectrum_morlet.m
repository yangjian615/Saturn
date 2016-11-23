function [f, power_spectrum, Num_Unique_Pts] = power_spectrum_morlet(magnetometer_data_to_analyze, delta_t)

    f_sample = 1/delta_t;
    [n, size_of_data] = size(magnetometer_data_to_analyze);
%     f_sample = 1;
    
    NFFT = 2^(nextpow2(length(magnetometer_data_to_analyze)));
    zero_pad = (NFFT-size_of_data);
    
%     if rem(zero_pad, 2)
%         zero_pad_begin = zeros(1, floor(zero_pad/2));
%         zero_pad_end = zeros(1, ceil(zero_pad/2));
%     else
%         zero_pad_begin = zeros(1, zero_pad/2);
%         zero_pad_end = zeros(1, zero_pad/2);
%     end
%     
%     
%     morlet_data_analysis = horzcat(zero_pad_begin, magnetometer_data_to_analyze, zero_pad_end);
    
    
    Num_Unique_Pts = ceil((NFFT+1)/2);
    f = (0:Num_Unique_Pts-1)*f_sample/NFFT;
    f = f(2:length(f));

%     f = [1:size_of_data-1]*f_sample/size_of_data;

%     morlet_coefficient_squared = sum(cwt(magnetometer_data_to_analyze, 1./(1.03*f), 'morl').^2, 2).';
%     power_spectrum = 1./(4*sin(pi()*f*delta_t).^2)*2*delta_t/size_of_data.*morlet_coefficient_squared;


    morlet_coefficient_squared = sum(cwt(magnetometer_data_to_analyze, 1./(1.03*f), 'morl').^2, 2).';
    coeff1 = 1./(4*sin(pi()*f*delta_t).^2)*2*delta_t/size_of_data;
    coeff2 = sin(pi()*f*delta_t).^2;
    power_spectrum = morlet_coefficient_squared;    


%_________________________________________________________________________________________________________________
%     data_time_length = 3600;
%     
%     [n, size_of_data] = size(magnetometer_data_to_analyze);
% 
%     delta_t = 1;
%     f_sample = 1/delta_t;
%     
%     
%     NFFT = 2^(nextpow2(length(magnetometer_data_to_analyze)));
%     zero_pad = (NFFT-size_of_data);
%     
%     if rem(zero_pad, 2)
%         zero_pad_begin = zeros(1, floor(zero_pad/2));
%         zero_pad_end = zeros(1, ceil(zero_pad/2));
%     else
%         zero_pad_begin = zeros(1, zero_pad/2);
%         zero_pad_end = zeros(1, zero_pad/2);
%     end
%     
%     
%     morlet_data_analysis = horzcat(zero_pad_begin, magnetometer_data_to_analyze, zero_pad_end);
%     
%     
%     Num_Unique_Pts = ceil((NFFT+1)/2);
%     f = (0:Num_Unique_Pts-1)*f_sample/NFFT;
%     f = f(2:length(f));
% 
% %     f = [1:size_of_data-1]*f_sample/size_of_data;
% 
% %     morlet_coefficient_squared = sum(cwt(magnetometer_data_to_analyze, 1./(1.03*f), 'morl').^2, 2).';
% %     power_spectrum = 1./(4*sin(pi()*f*delta_t).^2)*2*delta_t/size_of_data.*morlet_coefficient_squared;
% 
%     morlet_coefficient_squared = sum(cwt(magnetometer_data_to_analyze, 1./(1.03*f), 'morl').^2, 2).';
% %     coeff1 = 1./(4*sin(pi()*f*delta_t).^2)*2*delta_t/size_of_data;
% %     coeff2 = sin(pi()*f*delta_t).^2;
%     power_spectrum = morlet_coefficient_squared;   
    
end
