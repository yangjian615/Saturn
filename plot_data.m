function plot_data(data)
[t,number_of_points] = size(data); 
format shortEng
%for giant q values and crazy slopes
%{
KAW_q_mean = mean(data(1,data(1,:) ~= 0));
KAW_q_std = std(data(1,data(1,:) ~= 0));
MHD_q_mean = mean(data(2,data(2,:) ~= 0));
MHD_q_std = std(data(2,data(2,:) ~= 0));
KAW_slope_mean = mean(data(9,data(9,:) ~= 0));
MHD_slope_mean = mean(data(10,data(10,:) ~= 0));
KAW_slope_std = std(data(9,data(9,:) ~= 0));
MHD_slope_std = std(data(10,data(10,:) ~= 0));
K_slope_max = KAW_slope_mean + 2*KAW_slope_std;
K_slope_min = KAW_slope_mean - 2*KAW_slope_std;
K_q_max = KAW_q_mean + 2*KAW_q_std;
M_slope_max = MHD_slope_mean + 2*MHD_slope_std;
M_slope_min = MHD_slope_mean - 2*MHD_slope_std;
M_q_max = MHD_q_mean+2*MHD_q_std;

%filtering
f_data = data;
f_data(1,f_data(9,:) > K_slope_max) = 0;
f_data(1,f_data(9,:) < K_slope_min) = 0;
f_data(1,f_data(1,:) > K_q_max) = 0;
f_data(2,f_data(10,:) > M_slope_max) = 0;
f_data(2,f_data(10,:) < M_slope_min) = 0;
f_data(2,f_data(2,:) > M_q_max) = 0;
%}
f_data = data;
plot_plot_plot = false;
how_many_windows = 20;

color_plot = ones(180,how_many_windows,2);
color_plot3 = ones(96,how_many_windows,2);
color_plot5 = ones(75,how_many_windows,2);
color_plot7 = ones(100,how_many_windows,2);
%grossest loop ever

normalization = max(f_data(1,:));

for y = 1:number_of_points
    if f_data(4,y) - floor(f_data(4,y)) < 0.25
        LT_index = 4*floor(f_data(4,y))+1;
    elseif f_data(4,y) - floor(f_data(4,y)) >= 0.25 && f_data(4,y) - floor(f_data(4,y)) < 0.5
        LT_index = 4*floor(f_data(4,y))+2;
    elseif f_data(4,y) - floor(f_data(4,y)) >= 0.5 && f_data(4,y) - floor(f_data(4,y)) < 0.75
        LT_index = 4*floor(f_data(4,y))+3;
    else
        LT_index = 4*ceil(f_data(4,y));
    end

    if f_data(1,y) || f_data(2,y)
        if f_data(1,y)
            M_or_K = 1;
        else
            M_or_K = 2;
        end
        %latitude
        if (90 + f_data(17,y)) > 79 && (90 + f_data(17,y)) < 101
            color_plot(floor(90 + f_data(17,y)),f_data(3,y),1) = color_plot(floor(90 + f_data(17,y)),f_data(3,y),1)*f_data(M_or_K,y)/normalization;
            color_plot(floor(90 + f_data(17,y)),f_data(3,y),2) = color_plot(floor(90 + f_data(17,y)),f_data(3,y),2) + 1;
            %LT
            color_plot3(LT_index,f_data(3,y),1) = color_plot3(LT_index,f_data(3,y),1)*f_data(M_or_K,y)/normalization;
            color_plot3(LT_index,f_data(3,y),2) = color_plot3(LT_index,f_data(3,y),2) + 1;
            %radial
            color_plot5(floor(f_data(5,y)),f_data(3,y),1) = color_plot5(floor(f_data(5,y)),f_data(3,y),1)*f_data(M_or_K,y)/normalization; 
            color_plot5(floor(f_data(5,y)),f_data(3,y),2) = color_plot5(floor(f_data(5,y)),f_data(3,y),2) + 1;
            %standoff distance
            if f_data(3,y) == 1
                z = y;
                dynamic_pressure = get_dynamic_pressure(f_data(5,z),2*pi*(f_data(4,z)/24)-pi);
                if dynamic_pressure > 0
                    R0 = 10.3*(dynamic_pressure^(-0.2));
                    %in units of half an Rs!!!
                    if R0 - floor(R0) < 0.5
                        index = 2*floor(R0);
                    else
                        index = 2*floor(R0)+1;
                    end
                    color_plot7(index,1,1) = color_plot7(index,1,1)*f_data(1,z)/normalization;
                    color_plot7(index,1,2) = color_plot7(index,1,2) + 1;
                    if (z+1 < number_of_points && f_data(3,z+1) == f_data(3,z) + 1)  || (z > 1 && f_data(3,z-1) == f_data(3,z) + 1)
                        if z+1 < number_of_points && f_data(3,z+1) == f_data(3,z) + 1
                            increment = 1;
                        else
                            increment = - 1;
                        end                    
                        while(z + increment < number_of_points && z + increment > 0 && f_data(3,z+increment) == f_data(3,z) + 1)
                            if f_data(1,z)
                                color_plot7(index,f_data(3,z+increment),1) = color_plot7(index,f_data(3,z+increment),1)*f_data(1,z+increment)/normalization;
                                color_plot7(index,f_data(3,z+increment),2) = color_plot7(index,f_data(3,z+increment),2) + 1;
                            elseif f_data(2,z)
                                color_plot7(index,f_data(3,z+increment),1) = color_plot7(index,f_data(3,z+increment),1)*f_data(2,z+increment)/normalization;
                                color_plot7(index,f_data(3,z+increment),2) = color_plot7(index,f_data(3,z+increment),2) + 1;
                            end
                            z = z + increment;
                        end
                    end
                end
            end
        end
    end 
end

stats1 = color_plot(:,:,2);
color_plot = color_plot(:,:,1);
stats2 = color_plot3(:,:,2);
color_plot3 = color_plot3(:,:,1);
stats3 = color_plot5(:,:,2);
color_plot5 = color_plot5(:,:,1);
stats4 = color_plot7(:,:,2);
color_plot7 = color_plot7(:,:,1);

%compute geometric means
color_plot(stats1 == 1) = NaN;
color_plot3(stats2 == 1) = NaN;
color_plot5(stats3 == 1) = NaN;
color_plot7(stats4 == 1) = NaN;

color_plot = color_plot.^(1./(stats1-1))*normalization;
color_plot3 = color_plot3.^(1./(stats2-1))*normalization;
color_plot5 = color_plot5.^(1./(stats3-1))*normalization;
color_plot7 = color_plot7.^(1./(stats4-1))*normalization;

%normalize!
color_plot2 = transpose(bsxfun(@rdivide,transpose(color_plot),max(transpose(color_plot)))); 
color_plot4 = transpose(bsxfun(@rdivide,transpose(color_plot3),max(transpose(color_plot3))));
color_plot6 = transpose(bsxfun(@rdivide,transpose(color_plot5),max(transpose(color_plot5))));
color_plot8 = transpose(bsxfun(@rdivide,transpose(color_plot7),max(transpose(color_plot7)))); 

if plot_plot_plot
%square plots    
    figure
    pcolor(1:how_many_windows,1:180,log10(color_plot));
    title('Not normalized latitude')
    
    figure
    pcolor(1:how_many_windows,1:180,log10(color_plot2));
    title('Normalized latitude');
    
    figure;
    pcolor(1:how_many_windows,1:96,log10(color_plot3));
    title('not normalized binned by LT');

    figure;
    pcolor(1:how_many_windows,1:96,log10(color_plot4));
    title('normalized binned by LT');

    figure;
    pcolor(1:how_many_windows,1:75,log10(color_plot5));
    title('not normalized binned by R_s');

    figure;
    pcolor(1:how_many_windows,1:75,log10(color_plot6));
    title('normalized binned by R_s');
    
    figure;
    pcolor(1:how_many_windows,1:100,log10(color_plot7));
    title('dynamic pressure');
    
    figure;
    pcolor(1:how_many_windows,1:100,log10(color_plot8));
    title('normalized dynamic pressure');

end
%polar plots
    r = (how_many_windows-((1:how_many_windows)-1))'/how_many_windows;
    %r = ((1:how_many_windows)-1)'/how_many_windows;
    theta = pi+(0:95)*(2*pi/95);
    t_x = r*cos(theta);
    t_y = r*sin(theta);
    
    figure;
    pcolor(t_x,t_y,log10(transpose(color_plot3)));
    colorbar;
    figure;
    pcolor(t_x,t_y,log10(transpose(color_plot4)));
    colorbar;

%line plots
    figure;
    %average q all local times as a function of window number from boundary
    average_q_window = zeros(20,1);
    for i = 1:20
        average_q_window(i) = log10(geomean(color_plot3(~isnan(color_plot3(:,i)),i)));
    end
    plot(average_q_window)

    %average q all window numbers as a function of local time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %standard_error = geostd(log10(line_plot),2)./sqrt(nansum(line_plot,2));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    line_plot3 = color_plot3;
    save('sheath_LT_line_plot','line_plot3')
    %std_err_sheath = standard_error;
    sheath_LT_windows = color_plot3;
    %save('sheath_LT_errors','std_err_sheath')
    save('sheath_side','sheath_LT_windows')

%{ 
    line_plot2 = color_plot3;
    save('mag_LT_line_plot','line_plot2')
    %std_err_mag = standard_error;
    magsphere_LT_windows = color_plot3;
    %save('mag_LT_errors','std_err_mag')
    save('mag_side','magsphere_LT_windows')
%}
    load('mag_LT_line_plot');
    %load('mag_LT_errors');
    load('sheath_LT_line_plot');
    %load('sheath_LT_errors');
    figure
    hold on

    combo_plot1 = zeros(96,1);
    combo_plot2 = zeros(96,1);

for i = 1:96
    combo_plot1(i) = log10(geomean(line_plot2(i,~isnan(line_plot2(i,:))),2));
    combo_plot2(i) = log10(geomean(line_plot3(i,~isnan(line_plot3(i,:))),2));
end

    plot(combo_plot1)
    plot(combo_plot2)

    %errorbar(geomean(log10(line_plot2),2),std_err_mag);
    %errorbar(geomean(log10(line_plot3),2),std_err_sheath);
    legend('magnetosphere','sheath');
    hold off
    
%FANCIEST PLOT YET
    r = (40-((1:40)-1))'/40;
    theta = pi+(0:95)*(2*pi/95);
    t_x = r*cos(theta);
    t_y = r*sin(theta);
    load('mag_side.mat');
    load('sheath_side.mat');
    
    figure;
    pcolor(t_x,t_y,log10(transpose(horzcat(fliplr(sheath_LT_windows),magsphere_LT_windows))));
    colorbar;
    pos = [-1/2 -1/2 1 1];
    rectangle('Position',pos,'Curvature',[1 1],'EdgeColor','r','linewidth',3)
    color_plot4 = transpose(bsxfun(@rdivide,transpose(horzcat(fliplr(sheath_LT_windows),...
        magsphere_LT_windows)),max(transpose(horzcat(fliplr(sheath_LT_windows),magsphere_LT_windows)))));

    figure;
    pcolor(t_x,t_y,log10(transpose(color_plot4)));
    colorbar;
    
%histograms near hot region of sheath (not necessary b/c of error bars?)
%{
    figure
    bar(horzcat(fliplr(sheath_LT_windows(49,:,2)),magsphere_LT_windows(49,:,2)));
    title('12:15');
%}
end