function [density,temperature,v_r,v_phi] = models_for_sheath()  
    data = get_LANL_moments();

    boundaries = get_location_regions_boundary_data();
    crossings = crossings_of_interest(boundaries,0);

    all_dens = 0;
    all_T = 0;
    all_LT = 0;
    all_v_r = 0;
    all_v_phi = 0;
    all_r = 0;

    [x,y] = size(crossings);
    for i = 1:y
        if crossings(7,i) == 1
            ze_condition = data(7,:) ~= 0 & data(2,:) == crossings(1,i) & data(3,:)*24*60 + data(4,:)*60 + data(5,:)...
            + data(6,:)/60 <= crossings(8,i) - 24*60*(datenum(crossings(1,i),1,1)-datenum(2004,1,1)) & abs(data(29,:)) < 11 & ...
            data(3,:)*24*60 + data(4,:)*60 + data(5,:) + data(6,:)/60 > crossings(8,i) - 24*60*(datenum(crossings(1,i),1,1)-datenum(2004,1,1))...
            - crossings(9,i);
        else
            ze_condition = data(7,:) ~= 0 & data(2,:) == crossings(1,i) & data(3,:)*24*60 + data(4,:)*60 + data(5,:)...
            + data(6,:)/60 >= crossings(8,i) - 24*60*(datenum(crossings(1,i),1,1)-datenum(2004,1,1)) & abs(data(29,:)) < 11 &...
            data(3,:)*24*60 + data(4,:)*60 + data(5,:) + data(6,:)/60 < crossings(8,i) - 24*60*(datenum(crossings(1,i),1,1)-datenum(2004,1,1))...
            + crossings(9,i);
        end

        densities = data(7,ze_condition);
        temps = data(8,ze_condition);
        v_r_rel = data(9,ze_condition);
        v_phi_rel = data(10,ze_condition);
        local_time = data(28,ze_condition);
        r = data(27,ze_condition);
        %avoid repeat data
        data(7,ze_condition) = 0;

        all_dens = vertcat(all_dens,transpose(densities));
        all_T = vertcat(all_T,transpose(temps));
        all_v_r = vertcat(all_v_r,transpose(v_r_rel));
        all_v_phi = vertcat(all_v_phi,transpose(v_phi_rel));
        all_LT = vertcat(all_LT,transpose(local_time));
        all_r = vertcat(all_r,transpose(r));
    end  
      
    model_data = horzcat(all_LT,all_dens,all_T,all_v_r,all_v_phi,all_r);

    avg_model_data_T = nan(288,1);
    avg_model_data_density = nan(288,1);
    avg_model_data_v_r = nan(288,1);
    avg_model_data_v_phi = nan(288,1);
    avg_model_data_r = nan(100,1);

    density_mean = nanmean(model_data(:,2));
    density_std = nanstd(model_data(:,2));
    T_mean = nanmean(model_data(:,3));
    T_std = nanstd(model_data(:,3));
    v_r_mean = nanmean(model_data(:,4));
    v_r_std = nanstd(model_data(:,4));
    v_phi_mean = nanmean(model_data(:,5));
    v_phi_std = nanstd(model_data(:,5));

    for i = 1:288
        %only uses data based on more than 50 points, the rest is
        %linearly interpolated
        statistics = sum(floor(12*model_data(:,1)) == i);
        if statistics > 50
            avg_model_data_density(i) = nanmean(model_data(floor(12*model_data(:,1)) == i & model_data(:,2) < density_mean+2*density_std,2));
            avg_model_data_T(i) = nanmean(model_data(floor(12*model_data(:,1)) == i & model_data(:,3) < T_mean+2*T_std,3));
            avg_model_data_v_r(i) = nanmean(model_data(floor(12*model_data(:,1)) == i & abs(model_data(:,4)) < v_r_mean+2*v_r_std,4));
            avg_model_data_v_phi(i) = nanmean(model_data(floor(12*model_data(:,1)) == i & abs(model_data(:,5)) < v_phi_mean+2*v_phi_std,5));
        end
    end

    interp_density = interp1(find(~isnan(avg_model_data_density)),avg_model_data_density(~isnan(avg_model_data_density)),1:288);
    interp_temp = interp1(find(~isnan(avg_model_data_T)),avg_model_data_T(~isnan(avg_model_data_T)),1:288);
    interp_vr = interp1(find(~isnan(avg_model_data_v_r)),avg_model_data_v_r(~isnan(avg_model_data_v_r)),1:288);
    interp_vphi = interp1(find(~isnan(avg_model_data_v_phi)),avg_model_data_v_phi(~isnan(avg_model_data_v_phi)),1:288);

    %for i = 1:100
        %avg_model_data_r(i) = mean(model_data(floor(model_data(:,6)) == i,3)); %temp as a function of r
        %avg_model_data_r(i) = nanmean(model_data(floor(model_data(:,6)) == i,2)); %density as a function of r
    %end
 

%hopefully this plot is a straight line
    %figure
    %plot(1:100,avg_model_data_r)

    p1 = polyfit(48:228,interp_temp(48:228),3);
    p2 = polyfit(48:228,interp_density(48:228),3);
    p3 = polyfit(48:228,interp_vr(48:228),3);
    p4 = polyfit(48:228,interp_vphi(48:228),3);

    figure
    %plot(48:228,avg_model_data_v_r(48:228))
    plot(1:288,interp_vr)
    line([144 144],[-100,300],'Color','r')
    title('v_r')
    hold on
    x1 = linspace(48,228);
    y1 = polyval(p3,x1);
    plot(x1,y1)
    hold off

    figure
    %plot(48:228,avg_model_data_v_phi(48:228))
    plot(1:288,interp_vphi)
    title('v_{phi}')
    line([144 144],[-300,300],'Color','r')
    hold on
    y2 = polyval(p4,x1);
    plot(x1,y2)
    hold off

    figure
    %plot(48:228,avg_model_data_density(48:228)) 
    plot(1:288,interp_density)
    line([144 144],[0,0.6],'Color','r')
    title('density')
    hold on
    y2 = polyval(p2,x1);
    plot(x1,y2)
    hold off

    figure
    plot(48:228,avg_model_data_T(48:228))
    plot(1:288,interp_temp)
    title('temperature')
    line([144 144],[0,700],'Color','r')
    hold on
    y2 = polyval(p1,x1);
    plot(x1,y2)
    hold off

    temperature = p1;
    density = p2;
    v_r = p3;
    v_phi = p4;
