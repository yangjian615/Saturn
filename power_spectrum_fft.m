function [f, power_spectrum, Num_Unique_Pts] = power_spectrum_fft(magnetometer_data, delta_t)
    
    magnetometer_data_to_analyze = magnetometer_data - mean(magnetometer_data);
    f_sample = 1/delta_t;
    
    [n, size_of_data] = size(magnetometer_data_to_analyze);
    
    % Generate FFT and calculate the power spectrum. The power spectral
    % density, a measurement of the enenrgy at various frequencies, is
    % equal to the sum of the real and imaginary components of the FF. You
    % can multiply theresult ofthe FFT by its complex conjugate in order to
    % calulate it. 
    
    % No. of points in DFT =  Next power of up from length of signal data
    % This is done to optimise FF =T algorithm
    NFFT = 2^(nextpow2(length(magnetometer_data_to_analyze)));
    
    % Perform (NFFT point) DFT padding out with zeros so length of
    % fft_magnetometer_data is NFFT
    fft_magnetometer_data = fft(magnetometer_data_to_analyze, NFFT);
    % only half of the points are unique due. So throw away half of the
    % points 
    Num_Unique_Pts = ceil((NFFT+1)/2);
    fft_magnetometer_data = fft_magnetometer_data(1:Num_Unique_Pts);
    
    % Scale the power spectrum of the data. (In our case delta t just one
    % but it is good to keep it general)
    power_spectrum = fft_magnetometer_data.*conj(fft_magnetometer_data)/size_of_data;

    if rem(NFFT, 2)
        power_spectrum(2:end) = power_spectrum(2:end)*2;
    else
        power_spectrum(2:end-1)= power_spectrum(2:end-1)*2;
    end

    % Calculate frequency scale
%     f = (0:Num_Unique_Pts-1)*f_sample/NFFT;
    f = (0:Num_Unique_Pts-1)*f_sample/NFFT;
    
    f = f(2:length(f));
    power_spectrum = power_spectrum(2:length(power_spectrum));
    
end
