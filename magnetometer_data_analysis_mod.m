%Brandon Burkholder & Vitaliy Kaminker
%This code does power density analysis of magnetic field of Saturn around
%magnetopause boundary
clc
clear all 
format long

number_of_files = 181;
length_of_window = 3600/6;
mag_is_1_sheath_is_0 = 0;    

% formatSpec_w = ['%d-%02d-%02dT%02d:%02d:%02.2f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %10.3e %10.3e %10.3e %10.3e %10.3e %10.3e %10.3e %10.3e %10.3e %10.3e %10.3e %10.3e %10.3e %8.3f %8.3f %10.3e %4d\t %12.3e %10.3e %10.3e\n'];
[location_data] = get_location_data(); 

[regions_boundary_data] = get_location_regions_boundary_data();
[rows,cols] = size(regions_boundary_data);

[ordered_crossings] = crossings_of_interest(regions_boundary_data,mag_is_1_sheath_is_0); 
[k,crossings] = size(ordered_crossings);

crossing_date = ordered_crossings(8,1);
boundaries_inside = 1;

num_of_bad_locations = 0;
num_of_bad_slopes = 0;

region = 'beginning';
position = 0;
qs_data = zeros(2,1);
nqs_data = zeros(2,1);
mag_data = zeros(600,1,4);
q = 0;
p = 0;
modeled = 0;
moment = 0;
how_many_boundaries = 0;
moments = get_LANL_moments();

if ~mag_is_1_sheath_is_0
    [coeffs_density,coeffs_T,coeffs_v_r_rel,coeffs_v_phi_rel] = models_for_sheath();
end

%for i=2:number_of_files
 for i = 2:169
    
    start = boundaries_inside;
    
    [magnetometer_data] = get_magnetometer_data(i);
    [n, length_of_magnetometer_data] = size(magnetometer_data);
   
    dates = 24*60*(datenum(magnetometer_data(1,:)...
        , magnetometer_data(2,:), magnetometer_data(3,:)...
        , magnetometer_data(4,:), magnetometer_data(5,:)...
        , floor(magnetometer_data(6,:))) - datenum(2004,1,1));

    [boundaries_in_file,boundaries_inside,crossing_date] = find_crossings_in_file(...
        magnetometer_data,dates,ordered_crossings,start,boundaries_inside,crossing_date,0);       
    [g,number_of_crossings] = size(boundaries_in_file);  
    
    for j = 1:number_of_crossings

        clearvars -except location_data regions_boundary_data mag_data_atalysis_fileID magnetometer_data i length_of_window... 
            coeffs_density coeffs_T num_of_bad_locations num_of_bad_slopes save_data formatSpec_w boundaries_in_file...
            crossing_date dates j do_it length_of_magnetometer_data coeffs_v_r_rel coeffs_v_phi_rel ordered_crossings...
            boundaries_inside number_of_crossings position region q data mag_is_1_sheath_is_0 mag_data...
            how_many_boundaries moments modeled moment start p qs_data nqs_data
 
        [windows] = window_finder(boundaries_in_file,j,number_of_crossings);
        index_of_crossing = find(dates == boundaries_in_file(8,j));
%{
        if ~isempty(index_of_crossing)
            bound_LT_and_r  = location_data(10:11, location_data(1,:) == magnetometer_data(1,index_of_crossing)...
                & location_data(2,:) == magnetometer_data(2,index_of_crossing)...                                     
                & location_data(3,:) == magnetometer_data(3,index_of_crossing)...
                & location_data(4,:) == magnetometer_data(4,index_of_crossing));
            if windows <= 2
                q = q+1;
                qs_data(1,q) = bound_LT_and_r(1,1);
                qs_data(2,q) = bound_LT_and_r(2,1);
            else
                p = p+1;
                nqs_data(1,p) = bound_LT_and_r(1,1);
                nqs_data(2,p) = bound_LT_and_r(2,1);
            end
%}       
%{        
%magnetosphere     
        if (windows > 1) && ~isempty(index_of_crossing) 
        %if windows < 5 
            how_many_boundaries = how_many_boundaries + 1;
            for k = 1:min([20,windows])        
                do_it = false;
                if boundaries_in_file(7,j) == 1 && ((index_of_crossing + length_of_window/5) + k*length_of_window - 1 <= length_of_magnetometer_data)
                    %fft starting at beginning of interval
                    mag_data_to_analyze = magnetometer_data(:, (index_of_crossing + length_of_window/5) +... 
                        (k - 1)*length_of_window:(index_of_crossing + length_of_window/5) + k*length_of_window - 1);
                    region = 'Sheath to Magnetosphere ';
                    position = k;
                    do_it =  true;
                elseif boundaries_in_file(7,j) == 2 && (index_of_crossing - length_of_window/5 - (min([20,windows])-k+1)*length_of_window >= 0)
                   %needs to end at start of interval
                    mag_data_to_analyze = magnetometer_data(:, (index_of_crossing - length_of_window/5) -...
                        (min([20,windows])-k+1)*length_of_window:(index_of_crossing - length_of_window/5) -...
                        (min([20,windows])-k)*length_of_window-1);
                    region = 'Magnetosphere to Sheath ';
                    position = min([20,windows])-k+1;
                    do_it = true;
                end 
%}                     
        %magnetosheath
        if windows > 1 && ~isempty(index_of_crossing) 
            how_many_boundaries = how_many_boundaries + 1;
            %to determine sheath flow always at boundary
            bound_LT_and_r  = location_data(10:11, location_data(1,:) == magnetometer_data(1,index_of_crossing)...
                & location_data(2,:) == magnetometer_data(2,index_of_crossing)...                                     
                & location_data(3,:) == magnetometer_data(3,index_of_crossing)...
                & location_data(4,:) == magnetometer_data(4,index_of_crossing));

            %uses an average of all available times in sheath after
            %boundary crossing so all windows after a boundary have
            %constant density temp and v
            %[density,T,v_r_rel,v_phi_rel] = find_moment_data(start+j-1,ordered_crossings,moments);
            %start + j - 1
            
            %can calculate v temp and density for every window or as above
            %where all values are the same for windows attached to a
            %particular crossing
            %if isnan(density) || isnan(T) || isnan(v_r_rel) || isnan(v_phi_rel)
                v_r_rel = 1000*polyval(coeffs_v_r_rel,bound_LT_and_r(1,1));%convert m/s
                v_phi_rel = 1000*polyval(coeffs_v_phi_rel,bound_LT_and_r(1,1));
                density = polyval(coeffs_density,bound_LT_and_r(1,1))*(.001/6.022140857e23); %convert number density to mass density
                T = 11600*polyval(coeffs_T,bound_LT_and_r(1,1)); %convert eV to K
            %    modeled = modeled + 1;
            %else
            %    moment = moment + 1;
            %end

            %my poor useless model (requires density and temp models)
            %[v_phi_rel, v_r_rel] = get_v_rel_sheath(bound_LT_and_r(2,1),2*pi*(bound_LT_and_r(1,1)/24)-pi);
               
            for k = 1:min([20,windows])
                do_it = false;
                if boundaries_in_file(7,j) == 2 && ((index_of_crossing + length_of_window/5) + k*length_of_window - 1) <= length_of_magnetometer_data
                    mag_data_to_analyze = magnetometer_data(:, (index_of_crossing + length_of_window/5) +... 
                        (k - 1)*length_of_window:(index_of_crossing + length_of_window/5) + k*length_of_window - 1);
                    region = 'Magnetosphere to Sheath ';
                    position = k;
                    do_it = true;
                elseif boundaries_in_file(7,j) == 1 && ((index_of_crossing - length_of_window/5) - (min([20,windows])-k)*length_of_window-1) >= 0
                    mag_data_to_analyze = magnetometer_data(:, (index_of_crossing - length_of_window/5) -...
                        (min([20,windows])-k+1)*length_of_window:(index_of_crossing - length_of_window/5) -...
                        (min([20,windows])-k)*length_of_window-1);
                    region = 'Sheath to Magnetosphere ';
                    position = min([20,windows])-k+1;
                    do_it = true;
                end
                
                if do_it
                    try
                        clearvars -except location_data regions_boundary_data mag_data_atalysis_fileID magnetometer_data...
                            i length_of_window do_it mag_data coeffs_density coeffs_T num_of_bad_locations num_of_bad_slopes...
                            save_data formatSpec_w boundaries_in_file crossing_date dates j ordered_crossings...
                            length_of_magnetometer_data coeffs_v_phi_rel coeffs_v_r_rel boundaries_inside mag_data_to_analyze...
                            index_of_crossing region windows k number_of_crossings position data q v_phi_rel v_r_rel density T...
                            mag_is_1_sheath_is_0 how_many_boundaries moments modeled moment start

                        location_initial(1:6,1) = mag_data_to_analyze(1:6,1);
                        location_initial(7:13,1) = location_data(5:11, location_data(1,:) == mag_data_to_analyze(1,1) ...
                            & location_data(2,:) == mag_data_to_analyze(2,1) ...                                     
                            & location_data(3,:) == mag_data_to_analyze(3,1) ...
                            & location_data(4,:) == mag_data_to_analyze(4,1));

                        location_final(1:6,1) = mag_data_to_analyze(1:6,length_of_window);                  
                        location_final(7:13,1) = location_data(5:11, location_data(1,:) == mag_data_to_analyze(1,length_of_window) ...
                            & location_data(2,:) == mag_data_to_analyze(2,length_of_window) ...                                     
                            & location_data(3,:) == mag_data_to_analyze(3,length_of_window) ...
                            & location_data(4,:) == mag_data_to_analyze(4,length_of_window)); 

                        B_r = mag_data_to_analyze(7,:).';
                        B_theta = mag_data_to_analyze(8,:).';
                        B_phi = mag_data_to_analyze(9,:).';
                        B_tot = mag_data_to_analyze(10,:).';

                        N = length(B_r);
                        time_step = 1; %1s
                        lag = floor(N/10);

                        B_r = B_r*1e-9;
                        B_theta = B_theta*1e-9;
                        B_phi = B_phi*1e-9;
                        B_tot = B_tot*1e-9;   

                        B_r_std = std(B_r);
                        B_r_rms = rms(B_r);
                        B_r_mean = mean(B_r);
                        B_r_min = min(B_r);
                        B_r_max = max(B_r);

                        B_theta_std = std(B_theta);
                        B_theta_rms = rms(B_theta);
                        B_theta_mean = mean(B_theta);
                        B_theta_min = min(B_theta);
                        B_theta_max = max(B_theta);

                        B_phi_std = std(B_phi);
                        B_phi_rms = rms(B_phi);
                        B_phi_mean = mean(B_phi);
                        B_phi_min = min(B_phi);
                        B_phi_max = max(B_phi);

                %       B_total_std = std(B_tot);
                %       B_total_std = sqrt(std(B_r)^2+std(B_theta)^2+std(B_phi)^2);
                        B_total_rms = rms(B_tot);
                        B_total_mean = mean(B_tot);
                        B_total_min = min(B_tot);
                        B_total_max = max(B_tot);

                        B_vector_mean = get_B_vector_mean(B_r_mean, B_theta_mean, B_phi_mean);
                        [B_fluctuation_parallel, B_fluctuation_perp, B_std_parallel, B_std_perp] = get_B_std_vector_components(B_vector_mean, B_r, B_theta, B_phi);
                        B_total_std = B_std_perp;

                        [gyration_frequency] = get_gyration_frequency(B_tot,mag_is_1_sheath_is_0);  

                        [f, power_spectrum] = get_power_spectrum_mod(B_fluctuation_perp, B_total_std);
            %           [f, power_spectrum] = get_power_spectrum(B_fluctuation_perp(1,:), B_fluctuation_perp(2,:), B_fluctuation_perp(3,:), B_tot, B_total_std);      

                        Rs = 60268e3; %m
                        tau = 50; %s

                        %is this the same in sheath?
                        H = get_scale_height(location_initial(13));

                        if mag_is_1_sheath_is_0
                            [v_phi_rel, v_r_rel] = get_v_rel(location_initial(13));
                            density = get_density(location_initial(10), H, location_initial(13));
                            T = get_temperature(H);
                        else
                            %density = polyval(coeffs_density,location_initial(12))*(.001/6.022140857e23); %convert number density to mass density
                            %T = 11600*polyval(coeffs_T,location_initial(12)); %convert eV to K
                            %v_r_rel = 1000*polyval(coeffs_v_r_rel,location_initial(12));%convert m/s
                            %v_phi_rel = 1000*polyval(coeffs_v_phi_rel,location_initial(12));
                        end


                        larmor_radius = get_larmor_radius(T, B_total_mean,mag_is_1_sheath_is_0);
            %           l_parallel = get_dipole_magnetic_field_line_length(location_initial(13), location_initial(10));  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%might require different model in
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%sheath
                        %l_parallel = H*Rs;
                        l_prependicular = get_magnetic_field_prependicular_length(tau, v_phi_rel, v_r_rel,mag_is_1_sheath_is_0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        q_KAW_delB = get_heating_coefficient_KAW(B_total_std, larmor_radius, density, v_phi_rel, v_r_rel, tau, mag_is_1_sheath_is_0);
                        %q_MHD_delB = get_heating_coefficient_MHD(B_total_std, B_total_mean, density, l_parallel, l_prependicular);
                        q_MHD_strong_delB = get_heating_coefficient_MHD_strong(B_total_std, B_total_mean, density, l_prependicular);

            %           [coeff_1_line, coeff_2_line, coeff_1_power, coeff_2_power, f1, f2, power_spectrum_1, power_spectrum_2] = get_power_spectrum_slopes(f, power_spectrum, gyration_frequency);
                        [coeff_MHD, coeff_KAW, f_MHD, f_KAW, power_spectrum_MHD, power_spectrum_KAW] = get_power_spectrum_slopes(f, power_spectrum, gyration_frequency);      

                        k_prependicular_MHD = get_k_prependicular(f_MHD, v_phi_rel, v_r_rel, B_vector_mean,mag_is_1_sheath_is_0);
                        k_prependicular_KAW = get_k_prependicular(f_KAW, v_phi_rel, v_r_rel, B_vector_mean,mag_is_1_sheath_is_0);

                        %Khi = get_Khi(B_total_std, B_total_mean, l_parallel, l_prependicular);

                        q_hybrid = 0;

                        if length(f_MHD) > 0
                            %[q_MHD_PS, q_MHD] = get_heating_coefficient_MHD_PS(B_total_std, B_total_mean, power_spectrum_MHD, f_MHD, density, l_parallel, l_prependicular, v_phi_rel, k_prependicular_MHD);
                            [q_MHD_strong_PS, q_MHD_strong] = get_heating_coefficient_MHD_strong_PS(B_total_std, B_total_mean, power_spectrum_MHD, f_MHD, density, l_prependicular, v_phi_rel, k_prependicular_MHD);
                            q_hybrid = q_MHD_strong;
                        else
                            %q_MHD_PS = [];
                            %q_MHD = 0;
                            q_MHD_PS_strong = [];
                            q_MHD_strong = 0;
                        end

                        if  length(f_KAW) > 0
                            [q_KAW_PS, q_KAW] = get_heating_coefficient_KAW_PS(B_total_std, power_spectrum_KAW, f_KAW, larmor_radius, density, k_prependicular_KAW);

                            q_hybrid = q_KAW;    
                        else
                            q_KAW_PS = [];
                            q_KAW = 0;
                        end  

                        q = q + 1;
                        if ~isnan(q_KAW) && isreal(q_KAW)
                            data(1,q) = q_KAW;
                        else
                            data(1,q) = 0;
                        end
                        if ~isnan(q_MHD_strong) && isreal(q_MHD_strong)
                            data(2,q) = q_MHD_strong;
                        else
                            data(2,q) = 0;
                        end

                        data(3,q) = position; %number of windows away from magnetosphere
                        data(4,q) = location_initial(12); %LT
                        data(5,q) = location_initial(13); %radial dist
                        data(6,q) = B_r_mean;%%%%%%%%
                        data(7,q) = B_theta_mean;%%%% any with dominant phi?
                        data(8,q) = B_phi_mean;%%%%%%
                        data(9,q) = coeff_KAW(1);
                        data(10,q) = coeff_MHD(1);
                        data(11:16,q) = location_initial(1:6,1);
                        data(17,q) = location_initial(10); %Latitude
                        data(18,q) = v_phi_rel;
                        data(19,q) = v_r_rel;

                        %mag_data(:,q,1) = B_r;
                        %mag_data(:,q,2) = B_theta;
                        %mag_data(:,q,3) = B_phi;
                        %mag_data(:,q,4) = B_tot;

                    catch
                        magnetic_field_boundary_ID = [-4, -4];
                        num_of_bad_locations = num_of_bad_locations + 1;

                        tau = 50; %s
                        H = 0;
                        density = 0;
                        v_phi_rel = 0;
                        v_r_rel = 0;
                        T = 0;
                        larmor_radius = 0;
                        q_KAW_delB = 0;
                        q_MHD_delB = 0;
                        q_KAW = 0;
                        q_MHD = 0;
                        coeff_MHD = 0;
                        coeff_KAW = 0; 
                        f_MHD = 0;
                        f_KAW = 0;
                        power_spectrum_MHD = 0;
                        power_spectrum_KAW = 0;

                    end
                end
            end 
        end
    end
 end
%save('quick_succession_crossings','data')
%save('qs','qs_data')
%save('nqs','nqs_data')
%all_model_data = data;
how_many_boundaries
%modeled 388
%moment 1055
%save('test_data','all_model_data');
%save('mag_data_proper_magsphere','mag_data');
%plot_data(data);

%q per given local time as a function of window number from boundary
%for i = 10:96
%figure
%plot(1:20,color_plot3(i,:,1));
%title(sprintf('LT %d',i/4));
%xlabel('Windows from boundary');
%ylabel('q(W/m^3)');
%pause
%end