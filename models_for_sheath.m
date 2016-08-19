function [density,temperature,v_r,v_phi_dawn,v_phi_dusk,v_phi_split] = models_for_sheath()  
    data = get_LANL_moments();

    resolution_in_minutes = 30;
    slices = (24*60)/resolution_in_minutes;
    k = 60/resolution_in_minutes;

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

    avg_model_data_T = nan(slices,1);
    avg_model_data_density = nan(slices,1);
    avg_model_data_v_r_pos = nan(slices,1);
    avg_model_data_v_phi_pos = nan(slices,1);
    avg_model_data_v_r_neg = nan(slices,1);
    avg_model_data_v_phi_neg = nan(slices,1);
    v_r_pos_points = zeros(slices,1);
    v_r_neg_points = zeros(slices,1);
    v_phi_pos_points = zeros(slices,1);
    v_phi_neg_points = zeros(slices,1);
    avg_model_data_r = nan(100,1);
%{
    density_mean = geomean(model_data(~isnan(model_data(:,2)) & model_data(:,2) ~= 0,2));
    density_std = geostd(model_data(~isnan(model_data(:,2)) & model_data(:,2) ~= 0,2));
    T_mean = geomean(model_data(~isnan(model_data(:,3)) & model_data(:,3) ~= 0,3));
    T_std = geostd(model_data(~isnan(model_data(:,3)) & model_data(:,3) ~= 0,3));
    v_r_pos_mean = geomean(model_data(~isnan(model_data(:,4)) & model_data(:,4) > 0,4));
    v_r_pos_std = geostd(model_data(~isnan(model_data(:,4)) & model_data(:,4) > 0,4));

    v_r_neg_mean = -1*geomean(-1*model_data(~isnan(model_data(:,4)) & model_data(:,4) < 0,4));
    v_r_neg_std = -1*geostd(-1*model_data(~isnan(model_data(:,4)) & model_data(:,4) < 0,4));

    v_phi_pos_mean = geomean(model_data(~isnan(model_data(:,5)) & model_data(:,5) > 0,5));
    v_phi_pos_std = geostd(model_data(~isnan(model_data(:,5)) & model_data(:,5) > 0,5));

    v_phi_neg_mean = -1*geomean(-1*model_data(~isnan(model_data(:,5)) & model_data(:,5) < 0,5));
    v_phi_neg_std = -1*geostd(-1*model_data(~isnan(model_data(:,5)) & model_data(:,5) < 0,5));
%}
    for i = 1:slices
        %only uses data based on more than 50 points, the rest is
        %linearly interpolated
        statistics = sum(floor(k*model_data(:,1)) == i);
        if statistics > 50
            avg_model_data_density(i) = geomean(model_data(floor(k*model_data(:,1)) == i,2));
            avg_model_data_T(i) = geomean(model_data(floor(k*model_data(:,1)) == i,3));

            avg_model_data_v_r_pos(i) = geomean(model_data(model_data(:,4) > 0 & floor(k*model_data(:,1)) == i,4));
            avg_model_data_v_r_neg(i) = -1*geomean(-1*model_data(model_data(:,4) < 0 & floor(k*model_data(:,1)) == i,4));
            v_r_pos_points(i) = sum(model_data(model_data(:,4) > 0 & floor(k*model_data(:,1)) == i));
            v_r_neg_points(i) = sum(model_data(model_data(:,4) < 0 & floor(k*model_data(:,1)) == i));

            avg_model_data_v_phi_pos(i) = geomean(model_data(model_data(:,5) > 0 & floor(k*model_data(:,1)) == i,5));
            avg_model_data_v_phi_neg(i) = -1*geomean(-1*model_data(model_data(:,5) < 0 & floor(k*model_data(:,1)) == i,5));
            v_phi_pos_points(i) = sum(model_data(model_data(:,5) > 0 & floor(k*model_data(:,1)) == i));
            v_phi_neg_points(i) = sum(model_data(model_data(:,5) < 0 & floor(k*model_data(:,1)) == i));
        end
    end

    total_points_v_r = v_r_pos_points + v_r_neg_points;
    total_points_v_phi =  v_phi_pos_points + v_phi_neg_points;

    avg_model_data_vr = avg_model_data_v_r_pos.*(v_r_pos_points./total_points_v_r) + avg_model_data_v_r_neg.*(v_r_neg_points./total_points_v_r);
    avg_model_data_v_phi = avg_model_data_v_phi_pos.*(v_phi_pos_points./total_points_v_phi) + avg_model_data_v_phi_neg.*(v_phi_neg_points./total_points_v_phi);

    density_first = find(~isnan(avg_model_data_density),1,'first');
    density_last = find(~isnan(avg_model_data_density),1,'last');

    temp_first = find(~isnan(avg_model_data_T),1,'first');
    temp_last = find(~isnan(avg_model_data_T),1,'last');

    v_r_first = find(~isnan(avg_model_data_vr),1,'first');
    v_r_last = find(~isnan(avg_model_data_vr),1,'last');

    v_phi_neg_first = find(~isnan(avg_model_data_v_phi) & avg_model_data_v_phi < 0,1,'first');
    v_phi_neg_last = find(~isnan(avg_model_data_v_phi) & avg_model_data_v_phi < 0,1,'last');
    v_phi_pos_first = v_phi_neg_last + 1;
    v_phi_pos_last = find(~isnan(avg_model_data_v_phi),1,'last');

    interp_density = interp1(find(~isnan(avg_model_data_density)),avg_model_data_density(~isnan(avg_model_data_density)),density_first:density_last);
    interp_temp = interp1(find(~isnan(avg_model_data_T)),avg_model_data_T(~isnan(avg_model_data_T)),temp_first:temp_last);
    interp_vr = interp1(find(~isnan(avg_model_data_vr)),avg_model_data_vr(~isnan(avg_model_data_vr)),v_r_first:v_r_last);
    interp_vphi_pos = interp1(find(~isnan(avg_model_data_v_phi)),avg_model_data_v_phi(~isnan(avg_model_data_v_phi)),v_phi_pos_first:v_phi_pos_last);
    interp_vphi_neg = interp1(find(~isnan(avg_model_data_v_phi)),avg_model_data_v_phi(~isnan(avg_model_data_v_phi)),v_phi_neg_first:v_phi_neg_last);

    smooth_density = transpose(smooth(interp_density));
    smooth_temp = transpose(smooth(interp_temp));
    smooth_vr = transpose(smooth(interp_vr));
    smooth_vphi_pos = transpose(smooth(interp_vphi_pos));
    smooth_vphi_neg = transpose(smooth(interp_vphi_neg));

    %for i = 1:100
        %avg_model_data_r(i) = mean(model_data(floor(model_data(:,6)) == i,3)); %temp as a function of r
        %avg_model_data_r(i) = nanmean(model_data(floor(model_data(:,6)) == i,2)); %density as a function of r
    %end
 

%hopefully this plot is a straight line
    %figure
    %plot(1:100,avg_model_data_r)

    p1 = polyfit(temp_first:temp_last,smooth_temp,2);
    p2 = polyfit(density_first:density_last,smooth_density,2);
    p3 = polyfit(v_r_first:v_r_last,smooth_vr,3);
    p4 = polyfit(v_phi_pos_first:v_phi_pos_last,smooth_vphi_pos,3);
    p5 = polyfit(v_phi_neg_first:v_phi_neg_last,smooth_vphi_neg,3);

    figure
    %plot(1:72,avg_model_data_v_r_pos(1:72))
    plot(v_r_first:v_r_last,smooth_vr)
    line([slices/2 slices/2],[-40,160],'Color','r')
    title('v_r')
    hold on
    line([0 slices],[0,0],'Color','r')
    x1 = linspace(v_r_first,v_r_last);
    y1 = polyval(p3,x1);
    plot(x1,y1)
    hold off

    figure
    %plot(1:72,avg_model_data_v_phi_pos(1:72))
    title('v_{phi}')
    line([slices/2 slices/2],[-300,300],'Color','r')
    hold on
    line([0 slices],[0,0],'Color','r')
    plot(v_phi_pos_first:v_phi_pos_last,smooth_vphi_pos)
    plot(v_phi_neg_first:v_phi_neg_last,smooth_vphi_neg)
    x1 = linspace(v_phi_pos_first,v_phi_pos_last);
    x2 = linspace(v_phi_neg_first,v_phi_neg_last);
    y2 = polyval(p4,x1);
    y3 = polyval(p5,x2);
    plot(x1,y2)
    plot(x2,y3)
    hold off

    figure
    %plot(1:72,avg_model_data_density(1:72)) 
    plot(density_first:density_last,smooth_density)
    line([slices/2 slices/2],[0,0.3],'Color','r')
    title('density')
    hold on
    x1 = linspace(density_first,density_last);
    y2 = polyval(p2,x1);
    plot(x1,y2)
    hold off

    figure
    %plot(1:72,avg_model_data_T(1:72))
    plot(temp_first:temp_last,smooth_temp)
    title('temperature')
    line([slices/2 slices/2],[0,600],'Color','r')
    hold on
    x1 = linspace(temp_first,temp_last);
    y2 = polyval(p1,x1);
    plot(x1,y2)
    hold off

    temperature = p1;
    density = p2;
    v_r = p3;
    v_phi_dawn = p4;
    v_phi_dusk = p5;
    v_phi_split = v_phi_neg_last;
