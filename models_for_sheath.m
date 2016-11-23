function [density,temperature,v_r,v_phi_dawn] = models_for_sheath()  
    data = get_LANL_moments();
    boundaries = get_location_regions_boundary_data();
    %crossings = crossings_of_interest(boundaries,0);
    crossings = crossings_of_interest_2(boundaries);
    resolution_in_minutes = 30;
    slices = (24*60)/resolution_in_minutes;
    k = 60/resolution_in_minutes;
    length_of_time_bins_in_mins = 50;    
    save_data = false;
    h = 0;

    if save_data
        moment_times_path_Name_w = '/home/computation/GitProjects/';
        moment_times_file_Name_w = 'from_shock.txt';     
        moment_times_file_Name = horzcat(moment_times_path_Name_w, moment_times_file_Name_w);
        moment_times_fileID = fopen(moment_times_file_Name, 'w');

        header = 'Year        DOY        Hour       Min       Sec        LT\n'; 
        fprintf(moment_times_fileID, header); 
    end

    dates = 24*60*(datenum(data(2,:),1,1) + (data(3,:)-1) + data(4,:)/24 + data(5,:)/(24*60)...
            + data(6,:)/(24*60*60) - datenum(2004,1,1));

    [x,y] = size(crossings); 
    crossing_by_crossing_average = zeros(y,20,6);
    cbcLT = zeros(y,20);

    %file = 2;
    %[magnetometer_data] = get_magnetometer_data(file);
    %mag_dates = 24*60*(datenum(magnetometer_data(1,:)...
    %    , magnetometer_data(2,:), magnetometer_data(3,:)...
    %    , magnetometer_data(4,:), magnetometer_data(5,:)...
    %    , floor(magnetometer_data(6,:))) - datenum(2004,1,1));

    for i = 1:y
        %while  crossings(8,i) > mag_dates(end)
        %    file = file + 1;
        %    [magnetometer_data] = get_magnetometer_data(file);
    %		mag_dates = 24*60*(datenum(magnetometer_data(1,:)...
    %            , magnetometer_data(2,:), magnetometer_data(3,:)...
    %    		, magnetometer_data(4,:), magnetometer_data(5,:)...
    %    		, floor(magnetometer_data(6,:))) - datenum(2004,1,1));
    %    end
		
        if crossings(7,i) == 2
            %mag_condition = mag_dates >= crossings(8,i) & mag_dates <= crossings(8,i) + crossings(9,i)/2;
            ze_condition = ~isnan(data(8,:)) & dates >= crossings(8,i) & dates <= crossings(8,i)...
                + crossings(9,i)/2 & abs(data(27,:)) < 30 & ~data(29,:) & ~data(30,:) & data(7,:) > 0 &...
                ((data(28,:) < 12 & data(37,:)) | (data(28,:) >= 12 & ~data(37,:)) & data(10,:) ~= -999 &...
                data(9,:) ~= -999 & data(8,:) ~= -999);
            TFC = dates(ze_condition) - crossings(8,i);
            %mag_TFC = mag_dates(mag_condition) - crossings(8,i);
        else
            %mag_condition = mag_dates <= crossings(8,i) & mag_dates >= crossings(8,i) - crossings(9,i)/2;
            ze_condition = ~isnan(data(8,:)) & dates <= crossings(8,i) & dates >= crossings(8,i)...
                - crossings(9,i)/2 & abs(data(27,:)) < 30 & ~data(29,:) & ~data(30,:) & data(7,:) > 0 &...
                ((data(28,:) < 12 & data(37,:)) | (data(28,:) >= 12 & ~data(37,:)) & data(10,:) ~= -999 &...
                data(9,:) ~= -999 & data(8,:) ~= -999);
            TFC = crossings(8,i) - dates(ze_condition);
            %mag_TFC = crossings(8,i) - mag_dates(mag_condition);
        end

            %these_dates = data(2:6,ze_condition & data(9,:) ~= -999);

            %mag_points = 10^(-9)*magnetometer_data(10,mag_condition);
            densities = data(7,ze_condition);
            temps = data(8,ze_condition);
            v_r_rel = data(9,ze_condition);
            %vr_R = data(26, ze_condition);
            v_r_fluct = sqrt((v_r_rel - mean(v_r_rel)).^2);
            v_phi_rel = data(10,ze_condition);
            vphi_LT = data(28, ze_condition);

            %avoid repeat data
            data(7,ze_condition) = 0;
            data(8,ze_condition) = -999;
            data(9,ze_condition) = -999;
            data(10,ze_condition) = -999;
            
            for g = 1:20
                crossing_by_crossing_average(i,g,1) =  mean(v_phi_rel(TFC >= (g-1)*50 & TFC < g*50));
                crossing_by_crossing_average(i,g,2) =  mean(v_r_rel(TFC >= (g-1)*50 & TFC < g*50));
                crossing_by_crossing_average(i,g,3) =  mean(v_r_fluct(TFC >= (g-1)*50 & TFC < g*50));
                crossing_by_crossing_average(i,g,4) =  mean(densities(TFC >= (g-1)*50 & TFC < g*50));
                crossing_by_crossing_average(i,g,5) =  mean(temps(TFC >= (g-1)*50 & TFC < g*50));
                %crossing_by_crossing_average(i,g,6) =  nanmean(mag_points(mag_TFC >= (g-1)*50 & mag_TFC < g*50).^2);
                cbcLT(i,g) = mean(vphi_LT(TFC >= (g-1)*50 & TFC < g*50));
            end

        if save_data
            pre_and_post_noon = these_dates(:,vphi_LT > 10 & vphi_LT < 14);
            pre_and_post_noon_times = vphi_LT(vphi_LT > 10 & vphi_LT < 14);
            h = h  + length(pre_and_post_noon_times);
            for not_k = 1:length(pre_and_post_noon_times)
                times_to_write = [pre_and_post_noon(:,not_k)',pre_and_post_noon_times(not_k)]; 
                formatSpec_w = ['%f %f %f %f %f %f\n'];          
                fprintf(moment_times_fileID, formatSpec_w, times_to_write);
            end
        end
    end

    crossing_by_crossing_average(crossing_by_crossing_average == 0) = NaN;
    %plasma_beta = 2*(4*pi*(10^-7))*(10^6)*crossing_by_crossing_average(:,:,4).*crossing_by_crossing_average(:,:,5)./crossing_by_crossing_average(:,:,6);
    %save('plasma_beta','plasma_beta');

%flag_view = zeros(1,length(all_v_r(all_vr_LT < 14 & all_vr_LT > 10)));
%flag_edge_anode = zeros(1,length(all_v_r(all_vr_LT < 14 & all_vr_LT > 10)));
%fid = fopen('/home/computation/GitProjects/pre&postnoon_fixed&flagged&halved.txt');
%FC = textscan(fid,'%s','Delimiter','\n');
%for i = 1:length(all_v_r(all_vr_LT < 14 & all_vr_LT > 10))
%    b = FC{1}(i);
%    flag_view(i) = b{1}(1);
%    flag_edge_anode(i) = b{1}(2);
%end

%flag_view == 101 %e
%flag_edge_anode == 43 %+
%all_v_r = all_v_r((flag_view == 105 & flag_edge_anode == 43));
%all_vr_TFC = all_vr_TFC((flag_view == 105 & flag_edge_anode == 43));
%all_vr_fluct = all_vr_fluct((flag_view == 105 & flag_edge_anode == 43));
%all_vr_LT = all_vr_LT((flag_view == 105 & flag_edge_anode == 43));
%all_v_phi = all_v_phi((flag_view == 105 & flag_edge_anode == 43));
%all_vphi_TFC = all_vphi_TFC((flag_view == 105 & flag_edge_anode == 43));
%all_vphi_LT = all_vphi_LT((flag_view == 105 & flag_edge_anode == 43));

time_bins = 10;
avg_model_data_v_phi_t = zeros(slices,time_bins);
avg_model_data_T_t = zeros(slices,time_bins);
avg_model_data_density_t = zeros(slices,time_bins);
avg_model_data_v_r_t = zeros(slices,time_bins);
vr_fluct = zeros(slices,time_bins);

for t = 1:time_bins
    here_vphi = crossing_by_crossing_average(:,t,1);
    here_vr = crossing_by_crossing_average(:,t,2);
    here_vr_fluct = crossing_by_crossing_average(:,t,3);
    here_density = crossing_by_crossing_average(:,t,4);
    here_temp = crossing_by_crossing_average(:,t,5);
    here_LT = cbcLT(:,t);
    for i = 1:slices         
        LT_condition = floor(k*here_LT) == i;

        avg_model_data_density_t(i,t) = nanmean(here_density(LT_condition));
        avg_model_data_T_t(i,t) = nanmean(here_temp(LT_condition));
        avg_model_data_v_r_t(i,t) = nanmean(here_vr(LT_condition));
        avg_model_data_v_phi_t(i,t) = nanmean(here_vphi(LT_condition));
        vr_fluct(i,t) = mean(here_vr_fluct(LT_condition));

        if isnan(avg_model_data_v_phi_t(i,t))
            avg_model_data_v_phi_t(i,t) = 0;
        end
    end
end

dawn1 = k*7;
dawn2 = k*11;
dusk1 = k*13;
dusk2 = k*17;
means_time2 = zeros(time_bins,dawn2-dawn1+1,2);
means_time3 = zeros(time_bins,2);
%means_time4 = zeros(time_bins,4);

for i = 1:time_bins
    density_this_slice = avg_model_data_density_t(:,i);
    density_first = find(~isnan(density_this_slice),1,'first');
    density_last = find(~isnan(density_this_slice),1,'last');

    temp_this_slice = avg_model_data_T_t(:,i);
    temp_first = find(~isnan(temp_this_slice),1,'first');
    temp_last = find(~isnan(temp_this_slice),1,'last');

    vr_this_slice = avg_model_data_v_r_t(:,i);
    v_r_first = find(~isnan(vr_this_slice),1,'first');
    v_r_last = find(~isnan(vr_this_slice),1,'last');
    vr_fluct_this_slice = vr_fluct(:,i);

    vphi_this_slice = avg_model_data_v_phi_t(:,i);
    vphi_this_slice(vphi_this_slice == 0) = NaN;
    v_phi_first = find(~isnan(vphi_this_slice),1,'first');
    v_phi_last = find(~isnan(vphi_this_slice),1,'last');

    if sum(~isnan(density_this_slice)) > 1
        interp_density = interp1(find(~isnan(density_this_slice)),density_this_slice(~isnan(density_this_slice)),density_first:density_last);
        smooth_density = interp_density;
        %smooth_density = transpose(smooth(interp_density));
        p2 = polyfit(density_first:density_last,smooth_density,2);
        figure
        plot(density_first:density_last,smooth_density)
        line([slices/2 slices/2],[0,0.3],'Color','r')
        title('density')
        hold on
        x1 = linspace(density_first,density_last);
        y2 = polyval(p2,x1);
        plot(x1,y2)
        hold off
    end

    if sum(~isnan(temp_this_slice)) > 1
        interp_temp = interp1(find(~isnan(temp_this_slice)),temp_this_slice(~isnan(temp_this_slice)),temp_first:temp_last);
        smooth_temp = interp_temp;
        %smooth_temp = transpose(smooth(interp_temp));
        p1 = polyfit(temp_first:temp_last,smooth_temp,2);
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
    end 

   
    if sum(~isnan(vr_this_slice)) > 1
        interp_vr = interp1(find(~isnan(vr_this_slice)),vr_this_slice(~isnan(vr_this_slice)),v_r_first:v_r_last);
        smooth_vr = interp_vr;
        %smooth_vr = transpose(smooth(interp_vr));
        p3 = polyfit(v_r_first:v_r_last,smooth_vr,3);
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
    end


    if sum(vphi_this_slice ~= 0) > 1
        interp_vphi = interp1(find(~isnan(vphi_this_slice)),vphi_this_slice(~isnan(vphi_this_slice)),v_phi_first:v_phi_last);        
        smooth_vphi = interp_vphi;
        %smooth_vphi = transpose(smooth(interp_vphi));
        p4 = polyfit(v_phi_first:v_phi_last,smooth_vphi,3);
        figure
        title(['v_{phi}',num2str(5*(i-1)),'-',num2str(5*i)])
        line([slices/2 slices/2],[-300,300],'Color','r')
        hold on
        line([0 slices],[0,0],'Color','r')
        %plot(v_phi_first:v_phi_last,smooth_vphi)
        scatter(v_phi_first:v_phi_last,vphi_this_slice(v_phi_first:v_phi_last),'.')
        %plot(v_phi_first:v_phi_last,smooth_vphi)
        x1 = linspace(v_phi_first,v_phi_last);
        y2 = polyval(p4,x1);
        plot(x1,y2)
        hold off
    end

%{
    if sum(~isnan(vphi_this_slice)) > 1
        figure
        title(['v_{\phi}',num2str(length_of_time_bins_in_mins*(i-1)),'-',num2str(length_of_time_bins_in_mins*i),'mins'])
        line([slices/2 slices/2],[-300,300],'Color','k')
        hold on
        line([0 slices],[0,0],'Color','k')
        %h1 = errorbar(v_phi_first+0.1:v_phi_last+0.1,vphi_this_slice(v_phi_first:v_phi_last),10*std_pos_this_slice(v_phi_first:v_phi_last),'g.');
        %h2 = errorbar(v_phi_first-0.1:v_phi_last-0.1,vphi_this_slice(v_phi_first:v_phi_last),10*std_neg_this_slice(v_phi_first:v_phi_last),'r.');
        %legend([h1; h2],{'v_{\phi_{+}} std','v_{\phi_{-}} std'},'Location','northwest')
        scatter(v_phi_first:v_phi_last,vphi_this_slice(v_phi_first:v_phi_last),[],vr_fluct_this_slice(v_phi_first:v_phi_last),'.','SizeData',500);
        xlabel('Local Time');
        ylabel('km/s');
        h = colorbar;
        ylabel(h,'v_r fluctuation')
        ax = gca;
        ax.XTickLabel = {'0','5:00','10:00','15:00','20:00','-'};
        text((v_phi_first:v_phi_last)+0.1,vphi_this_slice(v_phi_first:v_phi_last)+0.1,cellstr(num2str(total_points_vphi_this_slice(v_phi_first:v_phi_last))),'FontSize',6);
        hold off
        %saveas(gcf,strcat('\home\computation\Pictures\vphi_',num2str(length_of_time_bins_in_mins*(i-1)),'_',num2str(length_of_time_bins_in_mins*(i)),'_flags'),'jpg');
     %}
        means_time2(i,:,1) = vphi_this_slice(dawn1:dawn2);
        means_time2(i,:,2) = vphi_this_slice(dusk1:dusk2);
        means_time3(i,1) = nanmean(vphi_this_slice(dawn1:dawn2));
        means_time3(i,2) = nanmean(vphi_this_slice(dusk1:dusk2));
    %end
end

    %rgb_colors = parula(100);
    %r = rgb_colors(:,1);
    %g = rgb_colors(:,2);
    %b = rgb_colors(:,3);
  
    bp1 = means_time2(:,:,1);
    bp2 = means_time2(:,:,2);
    figure
    h1 = boxplot(bp1','Whisker',0,'Colors','r');
    ylim manual
    hold on
    h2 = boxplot(bp2','Whisker',0,'Colors','b');
    scatter(1:time_bins,means_time3(:,1),'.r');
    scatter(1:time_bins,means_time3(:,2),'.b');
    hold off
    set(h1(7,:),'Visible','off');
    set(h2(7,:),'Visible','off');
    text(2, 60, 'Dusk');
    text(1, 60, '-----', 'Color', 'blue');
    text(2, 30, 'Dawn');
    text(1, 30, '-----', 'Color', 'red');

    %for i=1:time_bins
    %    bb1 = bar(i,means_time2(i,2),'k');
        %set(bb1(1),'facecolor',[r(99) g(99) b(99)]); 
    %end
    %for i=1:time_bins
    %    bb2 = bar(i,means_time2(i,3),'w');
        %set(bb2(1),'facecolor',[r(1) g(1) b(1)]); 
    %end
    %h = colorbar;
    %ylabel(h,'v_r fluctuation')
    %h.TickLabels = [0 10 20 30 40 50 60 70 80 90 100];
    title([num2str(dawn1/k),':00-',num2str(dawn2/k),':00 & ',num2str(dusk1/k),':00-',num2str(dusk2/k),':00'])
    xlabel('Spacecraft time from bow shock crossing (minutes)')
    ylabel('average V_{\phi} km/s')
    line([0 slices],[0,0],'Color','k')
    axis([0 11 -400 400])
    set(gca,'XTickMode','manual');
    set(gca,'XTick',0:4:10);
    set(gca,'XtickLabels',0:200:50*time_bins);
    %saveas(gcf,'\home\computation\Pictures\8_1130_vphi_bar_flags','jpg');
%{
space_bins = ceil(max(all_vr_R)/4);
avg_model_data_v_phi_pos_R = zeros(slices,space_bins);
avg_model_data_v_phi_neg_R = zeros(slices,space_bins);
v_phi_pos_points_R = zeros(slices,space_bins);
v_phi_neg_points_R = zeros(slices,space_bins);
v_r_pos_points = zeros(slices,space_bins);
v_r_neg_points = zeros(slices,space_bins);
vr_fluct = zeros(slices,space_bins);
for t = 1:space_bins
    for i = 1:slices         
            vr_condition = floor(k*all_vr_LT) == i & all_vr_R >= (t-1)*4 & all_vr_R < t*4;
            vphi_condition = floor(k*all_vphi_LT) == i & all_vphi_R >= (t-1)*4 & all_vphi_R < t*4;

            avg_model_data_v_phi_pos_R(i,t) = geomean(all_v_phi(all_v_phi > 0 & vphi_condition));
            avg_model_data_v_phi_neg_R(i,t) = -1*geomean(-1*all_v_phi(all_v_phi < 0 & vphi_condition));
            if isnan(avg_model_data_v_phi_pos_R(i,t))
                avg_model_data_v_phi_pos_R(i,t) = 0;
            end
            if isnan(avg_model_data_v_phi_neg_R(i,t))
                avg_model_data_v_phi_neg_R(i,t) = 0;
            end

            vr_fluct(i,t) = mean(all_vr_fluct(vr_condition));
            v_r_pos_points(i,t) = sum(all_v_r > 0 & vr_condition);
            v_r_neg_points(i,t) = sum(all_v_r < 0 & vr_condition);
            v_phi_pos_points_R(i,t) = sum(all_v_phi > 0 & vphi_condition);
            v_phi_neg_points_R(i,t) = sum(all_v_phi < 0 & vphi_condition);
    end
end

total_points_v_phi_R =  v_phi_pos_points_R + v_phi_neg_points_R;
avg_model_data_v_phi_R = avg_model_data_v_phi_pos_R.*(v_phi_pos_points_R./total_points_v_phi_R) +...
    avg_model_data_v_phi_neg_R.*(v_phi_neg_points_R./total_points_v_phi_R);

means_time2 = zeros(time_bins,4);
means_time3 = zeros(time_bins,4);
%means_time4 = zeros(time_bins,4);

for i = 1:space_bins
    vphi_this_slice = avg_model_data_v_phi_R(:,i);
    total_points_vphi_this_slice = total_points_v_phi_R(:,i);
    vr_fluct_this_slice = vr_fluct(:,i);
     
        dawn1 = k*7;
        dawn2 = k*10;
        dusk1 = k*14;
        dusk2 = k*17;
        means_time2(i,2) = nansum(vphi_this_slice(dawn1:dawn2).*total_points_vphi_this_slice(dawn1:dawn2)/sum(total_points_vphi_this_slice(dawn1:dawn2)));
        means_time2(i,3) = nansum(vphi_this_slice(dusk1:dusk2).*total_points_vphi_this_slice(dusk1:dusk2)/sum(total_points_vphi_this_slice(dusk1:dusk2)));
        means_time3(i,2) = nanmean(vr_fluct_this_slice(dawn1:dawn2));
        means_time3(i,3) = nanmean(vr_fluct_this_slice(dusk1:dusk2));
end

    figure
    hold on
    for i=1:space_bins
        bb = bar(i,means_time2(i,2));
        %set(bb(1),'facecolor',[r(ceil(means_time3(i,2)/max(max(means_time3))*100)) g(ceil(means_time3(i,2)/max(max(means_time3))*100)) b(ceil(means_time3(i,2)/max(max(means_time3))*100))]); 
    end
    for i=1:space_bins
        bb = bar(i,means_time2(i,3));
        %set(bb(1),'facecolor',[r(ceil(means_time3(i,3)/max(max(means_time3))*100)) g(ceil(means_time3(i,3)/max(max(means_time3))*100)) b(ceil(means_time3(i,3)/max(max(means_time3))*100))]); 
    end
    h = colorbar;
    ylabel(h,'v_r fluctuation')
    title([num2str(dawn1/k),':00-',num2str(dawn2/k),':00 & ',num2str(dusk1/k),':00-',num2str(dusk2/k),':00'])
    xlabel('Radial Distance (Rs)')
    ylabel('average V_{\phi} km/s')
    ylim([-250 250])
%}
 
    %temperature = p1;
    %density = p2;
    %v_r = p3;
    %v_phi = p4;
