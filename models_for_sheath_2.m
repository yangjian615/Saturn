function [density,temperature,v_r,v_phi_dawn,v_phi_dusk,v_phi_split] = models_for_sheath_2()  
    data = get_LANL_moments();
    boundaries = get_location_regions_boundary_data();
    crossings = crossings_of_interest(boundaries,0);
    resolution_in_minutes = 30;
    slices = (24*60)/resolution_in_minutes;
    k = 60/resolution_in_minutes;

    %all_dens = [];
    %all_dens_LT = [];
    %all_T = [];
    %all_T_LT = [];
    all_v_r = [];
    all_vr_LT = [];
    all_vr_fluct = [];
    all_v_phi = [];
    all_vphi_LT = [];  

    dates = 24*60*(datenum(data(2,:),1,1) + (data(3,:)-1) + data(4,:)/24 + data(5,:)/(24*60)...
            + data(6,:)/(24*60*60) - datenum(2004,1,1));
    %orient_time = orientation(:,1);
    %all_yx = orientation(:,2);
    %all_yy = orientation(:,3);
    %all_yz = orientation(:,4);

    [x,y] = size(crossings);
    for i = 1:y
        %dir = 10*floor(crossings(8,i)/10) == round(orient_time);
        %y_x = all_yx(dir);
        %y_y = all_yy(dir);
        %y_z = all_yz(dir);

        %if ~isempty(y_z)
            %corotation_x = sin(2*pi*(crossings(4,i)/24));
            %corotation_y = -cos(2*pi*(crossings(4,i)/24));
            %ze_condition_dawn = false(1,length(dates));
            %ze_condition_dusk = false(1,length(dates));
            if crossings(7,i) == 2
                if i == y || crossings(9,i) == crossings(9,i+1)
                    ze_condition = dates >= crossings(8,i) & dates < crossings(8,i) + crossings(9,i)/2 & abs(data(27,:)) < 30 & ~data(29,:) & ~data(30,:);
%{
                    if dot([y_x,y_y,y_z], [corotation_x, corotation_y, 0]) >= 0.10
                        ze_condition_dawn = dates >= crossings(8,i) & dates < crossings(8,i) + crossings(9,i)/2 & abs(data(27,:)) < 30 & ~data(29,:) & ~data(30,:) ; 
                    elseif dot([y_x,y_y,y_z], [corotation_x, corotation_y, 0]) <= -0.10
                        ze_condition_dusk = dates >= crossings(8,i) & dates < crossings(8,i) + crossings(9,i)/2 & abs(data(27,:)) < 30 & ~data(29,:) & ~data(30,:) ;
                    end
%}
                else
                    ze_condition = dates >= crossings(8,i) & dates < crossings(8,i) + crossings(9,i) & abs(data(27,:)) < 30 & ~data(29,:) & ~data(30,:);
%{                   
                    if dot([y_x,y_y,y_z], [corotation_x, corotation_y, 0]) >= 0.10                                                                                  %& ~data(29,:) & ~data(30,:)
                        ze_condition_dawn = dates >= crossings(8,i) & dates < crossings(8,i) + crossings(9,i) & abs(data(27,:)) < 30 & ~data(29,:) & ~data(30,:);
                    elseif dot([y_x,y_y,y_z], [corotation_x, corotation_y, 0]) <= -0.10
                        ze_condition_dusk = dates >= crossings(8,i) & dates < crossings(8,i) + crossings(9,i) & abs(data(27,:)) < 30 & ~data(29,:) & ~data(30,:);
                    end
%}
               end
            else
                if i == 1 || crossings(9,i) == crossings(9,i-1)
                    ze_condition = dates < crossings(8,i) & dates >= crossings(8,i) - crossings(9,i)/2 & abs(data(27,:)) < 45 & ~data(29,:) & ~data(30,:); 
   %{
                    if dot([y_x,y_y,y_z], [corotation_x, corotation_y, 0]) >= 0.10
                        ze_condition_dawn = dates < crossings(8,i) & dates >= crossings(8,i) - crossings(9,i)/2 & abs(data(27,:)) < 30 & ~data(29,:) & ~data(30,:);
                    elseif dot([y_x,y_y,y_z], [corotation_x, corotation_y, 0]) <= -0.10
                        ze_condition_dusk = dates < crossings(8,i) & dates >= crossings(8,i) - crossings(9,i)/2 & abs(data(27,:)) < 30 & ~data(29,:) & ~data(30,:);
                    end
%}
                else          
                    ze_condition = dates < crossings(8,i) & dates >= crossings(8,i) - crossings(9,i) & abs(data(27,:)) < 45 & ~data(29,:) & ~data(30,:);          
                 %{            
                    if dot([y_x,y_y,y_z], [corotation_x, corotation_y, 0]) >= 0.10
                        ze_condition_dawn = dates < crossings(8,i) & dates >= crossings(8,i) - crossings(9,i) & abs(data(27,:)) < 30 & ~data(29,:) & ~data(30,:);
                    elseif dot([y_x,y_y,y_z], [corotation_x, corotation_y, 0]) <= -0.10
                        ze_condition_dusk = dates < crossings(8,i) & dates >= crossings(8,i) - crossings(9,i) & abs(data(27,:)) < 30 & ~data(29,:) & ~data(30,:);
                    end
%}
                end
            end

            %densities = data(7,ze_condition & data(7,:) > 0);
            %density_LT = data(28, ze_condition & data(7,:) > 0);
            %temps = data(8,ze_condition & data(8,:) > -999);
            %temp_LT = data(28, ze_condition & data(8,:) > -999);
            v_r_rel = data(9,ze_condition & ~isnan(data(8,:)) & data(9,:) > -999);
            vr_LT = data(28, ze_condition & ~isnan(data(8,:)) & data(9,:) > -999);
            v_r_fluct = sqrt((v_r_rel - mean(v_r_rel)).^2);
            v_phi_rel = data(10,ze_condition & ~isnan(data(8,:)) & data(10,:) > -999);
            vphi_LT = data(28, ze_condition & ~isnan(data(8,:)) & data(10,:) > -999);

            %avoid repeat data
            %data(7,ze_condition) = 0;
            %data(8,ze_condition) = -999;
            data(9,ze_condition) = -999;
            data(10,ze_condition) = -999;

            %all_dens = vertcat(all_dens,transpose(densities));
            %all_dens_LT = vertcat(all_dens_LT,transpose(density_LT));
            %all_T = vertcat(all_T,transpose(temps));
            %all_T_LT = vertcat(all_T_LT,transpose(temp_LT));
            all_v_r = vertcat(all_v_r,v_r_rel');
            all_vr_LT = vertcat(all_vr_LT,vr_LT');
            all_vr_fluct = vertcat(all_vr_fluct,v_r_fluct');
            all_v_phi = vertcat(all_v_phi,v_phi_rel');
            all_vphi_LT = vertcat(all_vphi_LT,vphi_LT');    
        %end
    end

    %avg_model_data_T = nan(slices,1);
    %avg_model_data_density = nan(slices,1);
    %avg_model_data_v_r_pos = nan(slices,1);
    %avg_model_data_v_r_neg = nan(slices,1);
    avg_model_data_v_phi_pos = zeros(slices,1);
    avg_model_data_v_phi_neg = zeros(slices,1);
    std_model_data_v_phi_pos = zeros(slices,1);
    std_model_data_v_phi_neg = zeros(slices,1);
    %v_r_pos_points = zeros(slices,1);
    %v_r_neg_points = zeros(slices,1);
    v_phi_pos_points = zeros(slices,1);
    v_phi_neg_points = zeros(slices,1);
    vr_fluct = zeros(slices,1);

    for i = 1:slices
        %avg_model_data_density(i) = geomean(model_data(floor(k*model_data(:,1)) == i,2));
        %avg_model_data_T(i) = geomean(model_data(floor(k*model_data(:,1)) == i,3));
        %avg_model_data_v_r_pos(i) = geomean(model_data(model_data(:,4) > 0 & floor(k*model_data(:,1)) == i,4));
        %avg_model_data_v_r_neg(i) = -1*geomean(-1*model_data(model_data(:,4) < 0 & floor(k*model_data(:,1)) == i,4));
        %v_r_pos_points(i) = sum(model_data(:,4) > 0 & floor(k*model_data(:,1)) == i);
        %v_r_neg_points(i) = sum(model_data(:,4) < 0 & floor(k*model_data(:,1)) == i);
        avg_model_data_v_phi_pos(i) = geomean(all_v_phi(all_v_phi > 0 & floor(k*all_vphi_LT) == i));
        avg_model_data_v_phi_neg(i) = -1*geomean(-1*all_v_phi(all_v_phi < 0 & floor(k*all_vphi_LT) == i))
        %std_model_data_v_phi_pos(i) = geostd(all_v_phi(all_v_phi > 0 & floor(k*all_vphi_LT) == i));
        %std_model_data_v_phi_neg(i) = geostd(-1*all_v_phi(all_v_phi < 0 & floor(k*all_vphi_LT) == i));
        if isnan(avg_model_data_v_phi_pos(i))
            avg_model_data_v_phi_pos(i) = 0;
        end
        if isnan(avg_model_data_v_phi_neg(i))
            avg_model_data_v_phi_neg(i) = 0;
        end
        vr_fluct(i) = nanmean(all_vr_fluct_dawn(floor(k*all_vr_LT_dawn) == i));
        v_phi_pos_points(i) = sum(all_v_phi_dawn > 0 & floor(k*all_vphi_LT_dawn) == i);
        v_phi_neg_points(i) = sum(all_v_phi_dawn < 0 & floor(k*all_vphi_LT_dawn) == i);
    end

    %total_points_v_r = v_r_pos_points + v_r_neg_points;
    total_points_v_phi =  v_phi_pos_points + v_phi_neg_points;
    nansum(total_points_v_phi(8:23))
    nansum(total_points_v_phi(25:40))

    %avg_model_data_vr = avg_model_data_v_r_pos.*(v_r_pos_points./total_points_v_r) + avg_model_data_v_r_neg.*(v_r_neg_points./total_points_v_r);
    avg_model_data_v_phi = avg_model_data_v_phi_pos.*(v_phi_pos_points./total_points_v_phi) + avg_model_data_v_phi_neg.*(v_phi_neg_points./total_points_v_phi);

    %density_first = find(~isnan(avg_model_data_density),1,'first');
    %density_last = find(~isnan(avg_model_data_density),1,'last');

    %temp_first = find(~isnan(avg_model_data_T),1,'first');
    %temp_last = find(~isnan(avg_model_data_T),1,'last');

    %v_r_first = find(~isnan(avg_model_data_vr),1,'first');
    %v_r_last = find(~isnan(avg_model_data_vr),1,'last');

    v_phi_first = find(~isnan(avg_model_data_v_phi),1,'first');
    v_phi_last = find(~isnan(avg_model_data_v_phi),1,'last');
    %v_phi_neg_first = find(avg_model_data_v_phi ~= 0 & avg_model_data_v_phi < 0,1,'first');
    %v_phi_neg_last = find(avg_model_data_v_phi ~= 0 & avg_model_data_v_phi < 0,1,'last');
    %v_phi_pos_first = v_phi_neg_last + 1;
    %v_phi_pos_last = find(avg_model_data_v_phi ~= 0,1,'last');

    %interp_density = interp1(find(~isnan(avg_model_data_density)),avg_model_data_density(~isnan(avg_model_data_density)),density_first:density_last);
    %interp_temp = interp1(find(~isnan(avg_model_data_T)),avg_model_data_T(~isnan(avg_model_data_T)),temp_first:temp_last);
    %interp_vr = interp1(find(~isnan(avg_model_data_vr)),avg_model_data_vr(~isnan(avg_model_data_vr)),v_r_first:v_r_last);
    %interp_vphi_pos = interp1(find(~isnan(avg_model_data_v_phi)),avg_model_data_v_phi(~isnan(avg_model_data_v_phi)),v_phi_pos_first:v_phi_pos_last);
    %interp_vphi_neg = interp1(find(~isnan(avg_model_data_v_phi)),avg_model_data_v_phi(~isnan(avg_model_data_v_phi)),v_phi_neg_first:v_phi_neg_last);

    %smooth_density = transpose(smooth(interp_density));
    %smooth_temp = transpose(smooth(interp_temp));
    %smooth_vr = transpose(smooth(interp_vr));
    %smooth_vphi_pos = transpose(smooth(interp_vphi_pos));
    %smooth_vphi_neg = transpose(smooth(interp_vphi_neg));

    %p1 = polyfit(temp_first:temp_last,smooth_temp,2);
    %p2 = polyfit(density_first:density_last,smooth_density,2);
    %p3 = polyfit(v_r_first:v_r_last,smooth_vr,3);
    %p4 = polyfit(v_phi_pos_first:v_phi_pos_last,smooth_vphi,3);
    %p5 = polyfit(v_phi_neg_first:v_phi_neg_last,smooth_vphi_neg,3);
%{
    figure
    plot(v_r_first:v_r_last,smooth_vr)
    line([slices/2 slices/2],[-40,160],'Color','r')
    title('v_r')
    hold on
    line([0 slices],[0,0],'Color','r')
    x1 = linspace(v_r_first,v_r_last);
    y1 = polyval(p3,x1);
    plot(x1,y1)
    hold off
%}
    figure
    title('v_{\phi}')
    line([slices/2 slices/2],[-300,300],'Color','k')
    hold on
    line([0 slices],[0,0],'Color','k')
    %plot(v_phi_pos_first:v_phi_pos_last,smooth_vphi_pos)
    %plot(v_phi_neg_first:v_phi_neg_last,smooth_vphi_neg)
    %h1 = errorbar(v_phi_first+0.1:v_phi_last+0.1,avg_model_data_v_phi(v_phi_first:v_phi_last),10*std_model_data_v_phi_pos(v_phi_first:v_phi_last),'g.');
    %h2 = errorbar(v_phi_first-0.1:v_phi_last-0.1,avg_model_data_v_phi(v_phi_first:v_phi_last),10*std_model_data_v_phi_neg(v_phi_first:v_phi_last),'r.');
    %legend([h1; h2],{'v_{\phi_{+}} std','v_{\phi_{-}} std'},'Location','northwest');
    scatter(v_phi_first:v_phi_last,avg_model_data_v_phi(v_phi_first:v_phi_last),[],vr_fluct(v_phi_first:v_phi_last),'.','SizeData',500)
    ylabel('km/s')
    xlabel('Local Time')
    h = colorbar;
    ylabel(h,'v_r fluctuation')
    ax = gca;
    ax.XTickLabel = {'0','5:00','10:00','15:00','20:00','-'};
    saveas(gcf,'\home\computation\Pictures\total_vphi_scatter_flags','jpg');
   
    rgb_colors = parula(100);
    r = rgb_colors(:,1);
    g = rgb_colors(:,2);
    b = rgb_colors(:,3);

    figure
    d = avg_model_data_v_phi(8:15);
    tp = total_points_v_phi(8:15);
    d2 = avg_model_data_v_phi(16:23);
    tp2 = total_points_v_phi(16:23);
    d3 = avg_model_data_v_phi(25:32);
    tp3 = total_points_v_phi(25:32);
    d4 = avg_model_data_v_phi(33:40);
    tp4 = total_points_v_phi(33:40);

    %bar(1:4,[nansum(d.*tp/sum(tp(~isnan(d)))),nansum(d2.*tp2/sum(tp2(~isnan(d2)))),...
    %    nansum(d3.*tp3/sum(tp3(~isnan(d3)))),nansum(d4.*tp4/sum(tp4(~isnan(d4))))])
    hold on
    maximum = max([mean(vr_fluct(8:15)) mean(vr_fluct(16:23)) mean(vr_fluct(25:32)) mean(vr_fluct(33:40))]);
    bb = bar(1,nansum(d.*tp/sum(tp(~isnan(d)))));

    set(bb(1),'facecolor',[r(ceil(nanmean(vr_fluct(8:15))/maximum*100)) g(ceil(nanmean(vr_fluct(8:15))/maximum*100)) b(ceil(nanmean(vr_fluct(8:15))/maximum*100))]); 
    bb2 = bar(2,nansum(d2.*tp2/sum(tp2(~isnan(d2)))));
    set(bb2(1),'facecolor',[r(ceil(nanmean(vr_fluct(16:23))/maximum*100)) g(ceil(nanmean(vr_fluct(16:23))/maximum*100)) b(ceil(nanmean(vr_fluct(16:23))/maximum*100))]); 
    bb3 = bar(3,nansum(d3.*tp3/sum(tp3(~isnan(d3)))));
    set(bb3(1),'facecolor',[r(ceil(nanmean(vr_fluct(25:32))/maximum*100)) g(ceil(nanmean(vr_fluct(25:32))/maximum*100)) b(ceil(nanmean(vr_fluct(25:32))/maximum*100))]); 
    bb4 = bar(4,nansum(d4.*tp4/sum(tp4(~isnan(d4)))));
    set(bb4(1),'facecolor',[r(ceil(nanmean(vr_fluct(33:40))/maximum*100)) g(ceil(nanmean(vr_fluct(33:40))/maximum*100)) b(ceil(nanmean(vr_fluct(33:40))/maximum*100))]); 
    xlabel('local time bin');
    ylabel('km/s');
    h = colorbar;
    ylabel(h,'v_r fluctuation')
    ylim([-175 250])
    ax = gca;
    ax.XTickLabel = {'0','4-7:30','8-11:30','12:30-16','16:30-20','-'};
    title('all time bins')
    %saveas(gcf,'\home\computation\Pictures\total_vphi_bar_flags','jpg');
    
    %figure
    %x1 = linspace(v_phi_pos_first,v_phi_pos_last);
    %x2 = linspace(v_phi_neg_first,v_phi_neg_last);
    %y2 = polyval(p4,x1);
    %y3 = polyval(p5,x2);
    %plot(x1,y2)
    %plot(x2,y3)
    %hold off
%{
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
%}
    %temperature = p1;
    %density = p2;
    %v_r = p3;
    %v_phi_dawn = p4;
    %v_phi_dusk = p5;