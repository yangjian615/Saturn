function find_interesting_particle_data(data)
[t,number_of_points] = size(data);
KAW_q_mean = mean(data(1,data(1,:) ~= 0));
KAW_q_std = std(data(1,data(1,:) ~= 0));
MHD_q_mean = mean(data(2,data(2,:) ~= 0));
MHD_q_std = std(data(2,data(2,:) ~= 0));
KAW_slope_mean = mean(data(9,data(9,:) ~= 0));
MHD_slope_mean = mean(data(10,data(10,:) ~= 0));
KAW_slope_std = std(data(9,data(9,:) ~= 0));
MHD_slope_std = std(data(10,data(10,:) ~= 0));
%K_slope_max = KAW_slope_mean + 2*KAW_slope_std;
K_slope_min = KAW_slope_mean - 4.5*KAW_slope_std;
K_q_max = KAW_q_mean+2*KAW_q_std;
M_slope_max = MHD_slope_mean + 2*MHD_slope_std;
M_slope_min = MHD_slope_mean - 2*MHD_slope_std;
M_q_max = MHD_q_mean+2*MHD_q_std;
%{
q_is_1_slope_is_9 = 9;
if q_is_1_slope_is_9 == 9
    maximum = K_slope_min; %make sure the logical below is a <
else
    maximum = K_q_max;
end

%anomolous q values or slopes
points_of_interest = length(data(1,data(q_is_1_slope_is_9,:) < maximum))
big = zeros(points_of_interest,12);
big_mag = zeros(600,points_of_interest,4);
big(:,1) = data(4,data(q_is_1_slope_is_9,:) < maximum);%LT
big(:,2) = data(5,data(q_is_1_slope_is_9,:) < maximum);%Rs
big(:,3) = data(11,data(q_is_1_slope_is_9,:) < maximum);%year
big(:,4) = data(12,data(q_is_1_slope_is_9,:) < maximum);%month
big(:,5) = data(13,data(q_is_1_slope_is_9,:) < maximum);%day
big(:,6) = datenum(data(11,data(q_is_1_slope_is_9,:) < maximum),...
    data(12,data(q_is_1_slope_is_9,:) < maximum),data(13,data(q_is_1_slope_is_9,:) < maximum))...
    - datenum(data(11,data(q_is_1_slope_is_9,:) < maximum,1),1,1) + 1;%day out of 365
big(:,7) = data(14,data(q_is_1_slope_is_9,:) < maximum);%hour
big(:,8) = data(15,data(q_is_1_slope_is_9,:) < maximum);%minute
big(:,9) = data(3,data(q_is_1_slope_is_9,:) < maximum);%window
big(:,10) = data(16,data(q_is_1_slope_is_9,:) < maximum);%second
big(:,11) = data(17,data(q_is_1_slope_is_9,:) < maximum);%Lat
big(:,12) = data(3,data(q_is_1_slope_is_9,:) < maximum);%Window
big_mag(:,:,1) = mag_data(:,data(q_is_1_slope_is_9,:) < maximum,1);
big_mag(:,:,2) = mag_data(:,data(q_is_1_slope_is_9,:) < maximum,2);
big_mag(:,:,3) = mag_data(:,data(q_is_1_slope_is_9,:) < maximum,3);
big_mag(:,:,4) = mag_data(:,data(q_is_1_slope_is_9,:) < maximum,4);

for i = 1:points_of_interest
    if big(i,7) < 6
        hour = 0;
    elseif big(i,7) >= 6 && big(i,7) < 12
        hour = 6;
    elseif big(i,7) >= 12 && big(i,7) < 18
        hour = 12;
    else
        hour = 18;
    end

    figure
    hold on
    plot(1:600,big_mag(:,i,1),'r')
    plot(1:600,big_mag(:,i,2),'g')
    plot(1:600,big_mag(:,i,3),'b')
    plot(1:600,big_mag(:,i,4),'k')

    legend('B_{r}','B_{theta}','B_{phi}','B_{tot}')
    hold off

    %Low energy looks forward, high energy looks backward
    LEMONS = get_LEMMS_data(big(i,3),big(i,4),big(i,5),big(i,7),big(i,8),big(i,10));
    figure
    title('A0 - A8 Low Energy Ions');
    hold on
    plot(1:600,LEMONS(:,6))
    plot(1:600,LEMONS(:,7)+10)
    plot(1:600,LEMONS(:,8)+20)
    plot(1:600,LEMONS(:,9)+30)      
    plot(1:600,LEMONS(:,10)+40)           
    plot(1:600,LEMONS(:,11)+50)
    plot(1:600,LEMONS(:,12)+60)
    plot(1:600,LEMONS(:,13)+70)
    plot(1:600,LEMONS(:,14)+80)
    legend('27 - 35','35 - 56','56 - 106','106 - 255','255 - 506','506 - 805','805 - 1600','1615 - 4000','3328 - 4080','Location','BestOutside');
    fig = gcf;
    ax = fig.CurrentAxes;
    set(ax,'ytick',[0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90])
    set(ax,'yticklabel',repmat({'0','5'},1,8))
    ylabel('counts/second');
    xlabel('seconds');
    for c=1:8
        line([0,600],[c*10,c*10],'LineStyle','--','Color',[0 0 0])
    end
    hold off
    
    figure
    title('C0 - C7 Low Energy Electrons');
    hold on
    plot(1:600,LEMONS(:,15))
    plot(1:600,LEMONS(:,16)+10)
    plot(1:600,LEMONS(:,17)+20)
    plot(1:600,LEMONS(:,18)+30)      
    plot(1:600,LEMONS(:,19)+40)           
    plot(1:600,LEMONS(:,20)+50)
    plot(1:600,LEMONS(:,21)+60)
    plot(1:600,LEMONS(:,22)+70)
    legend('18 - 40','27 - 48','41 - 60','56 - 100','92 - 183','175 - 300','265 - 550','510 - 832','Location','BestOutside');
    fig = gcf;
    ax = fig.CurrentAxes;
    set(ax,'ytick',[0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80])
    set(ax,'yticklabel',repmat({'0','5'},1,7))
    ylabel('counts/second');
    xlabel('seconds');
    for c=1:7
        line([0,600],[c*10,c*10],'LineStyle','--','Color',[0 0 0])
    end        
    hold off
        
    figure
    title('P1 - P8 High Energy Ions');
    hold on
    plot(1:600,LEMONS(:,23))
    plot(1:600,LEMONS(:,24)+5)
    plot(1:600,LEMONS(:,25)+10)
    plot(1:600,LEMONS(:,26)+15)      
    plot(1:600,LEMONS(:,27)+20)           
    plot(1:600,LEMONS(:,28)+25)
    plot(1:600,LEMONS(:,29)+30)
    plot(1:600,LEMONS(:,30)+35)
    legend('1424 - 2278','2280 - 4492','4491 - 5744','13200 - 25400','8311 - 11449','11474 - 13433','12101 - 58902','25185 - 59000','Location','BestOutside');
    fig = gcf;
    ax = fig.CurrentAxes;
    set(ax,'ytick',[0,2.5,5,7.5,10,12.5,15,17.5,20,22.5,25,27.5,30,32.5,35,37.5,40])
    set(ax,'yticklabel',repmat({'0','2.5'},1,7))
    ylabel('counts/second');
    xlabel('seconds');
    for c=1:7
        line([0,600],[c*5,c*5],'LineStyle','--','Color',[0 0 0])
    end        
    hold off
    
    figure
    title('E0 - E7 High Energy Electrons');
    hold on
    plot(1:600,LEMONS(:,31))
    plot(1:600,LEMONS(:,32)+10)
    plot(1:600,LEMONS(:,33)+20)
    plot(1:600,LEMONS(:,34)+30)      
    plot(1:600,LEMONS(:,35)+40)           
    plot(1:600,LEMONS(:,36)+50)
    plot(1:600,LEMONS(:,37)+60)
    plot(1:600,LEMONS(:,38)+70)
    legend('110 - 365','220 - 485','340 - 1350','600 - 4950','790 - 4750','800 - 2800','1600 - 21000','7000 - 20000','Location','BestOutside');
    fig = gcf;
    ax = fig.CurrentAxes;
    set(ax,'ytick',[0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80])
    set(ax,'yticklabel',repmat({'0','5'},1,7))
    ylabel('counts/second');
    xlabel('seconds');       
    for c=1:7
        line([0,600],[c*10,c*10],'LineStyle','--','Color',[0 0 0])
    end
    hold off
   
    str1 = strcat('/media/computation/FantomHD/CassiniLEMMS/BROWSE/LCPRESS0/',num2str(big(i,3)),'/',...
        'LCPRESS0_',num2str(big(i,3)),num2str(big(i,6),'%03d'),'_01.PNG'); 
    str2 = strcat('/media/computation/FantomHD/CassiniLEMMS/BROWSE/LPHASPGM0/',num2str(big(i,3)),'/',...
        'LPHASPGM0_',num2str(big(i,3)),num2str(big(i,6),'%03d'),'_01.PNG');
    str3 = strcat('/media/computation/FantomHD/CassiniMagData/CAPS_',num2str(big(i,3)),num2str(big(i,4),'%02d')...
        ,num2str(big(i,5),'%02d'),num2str(hour,'%02d'),'0000_060000.png');
   
    I1 = imread(str1,'png');
    I2 = imread(str2,'png');
    I3 = imread(str3,'png');
    figure
    imshow(I1);
    figure
    imshow(I2);
    figure
    imshow(I3);
    fprintf('Hour %d Minute %d Local Time %d R %d Latitude %d Window %d', big(i,7), big(i,8),big(i,1),big(i,2),big(i,11),big(i,12));
    pause
    close all
end
%}
for y = 1:number_of_points
    large_phi = 5*(data(7,y)^2 + data(6,y)^2);
    if data(8,y)^2 > large_phi && (data(3,y) == 1)
        if data(14,y) < 6
            hour = 0;
        elseif data(14,y) >= 6 && data(14,y) < 12
            hour = 6;
        elseif data(14,y) >= 12 && data(14,y) < 18
            hour = 12;
        else
            hour = 18;
        end
        
        figure
        hold on
        %plot(1:600,mag_data(:,y,1),'r')
        %plot(1:600,mag_data(:,y,2),'g')
        %plot(1:600,mag_data(:,y,3),'b')
        %plot(1:600,mag_data(:,y,4),'k')
        legend('B_{r}','B_{theta}','B_{phi}','B_{tot}')
        hold off
        
        %Low energy looks forward, high energy looks backward
        LEMONS = get_LEMMS_data(data(11,y),data(12,y),data(13,y),data(14,y),data(15,y),data(16,y));
        figure
        title('A0 - A8 Low Energy Ions');
        hold on
        plot(1:600,LEMONS(:,6))
        plot(1:600,LEMONS(:,7)+10)
        plot(1:600,LEMONS(:,8)+20)
        plot(1:600,LEMONS(:,9)+30)      
        plot(1:600,LEMONS(:,10)+40)           
        plot(1:600,LEMONS(:,11)+50)
        plot(1:600,LEMONS(:,12)+60)
        plot(1:600,LEMONS(:,13)+70)
        plot(1:600,LEMONS(:,14)+80)
        legend('27 - 35','35 - 56','56 - 106','106 - 255','255 - 506','506 - 805','805 - 1600','1615 - 4000','3328 - 4080','Location','BestOutside');
        fig = gcf;
        ax = fig.CurrentAxes;
        set(ax,'ytick',[0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90])
        set(ax,'yticklabel',repmat({'0','5'},1,8))
        ylabel('counts/second');
        xlabel('seconds');
        for c=1:8
            line([0,600],[c*10,c*10],'LineStyle','--','Color',[0 0 0])
        end
        hold off
        
        figure
        title('C0 - C7 Low Energy Electrons');
        hold on
        plot(1:600,LEMONS(:,15))
        plot(1:600,LEMONS(:,16)+10)
        plot(1:600,LEMONS(:,17)+20)
        plot(1:600,LEMONS(:,18)+30)      
        plot(1:600,LEMONS(:,19)+40)           
        plot(1:600,LEMONS(:,20)+50)
        plot(1:600,LEMONS(:,21)+60)
        plot(1:600,LEMONS(:,22)+70)
        legend('18 - 40','27 - 48','41 - 60','56 - 100','92 - 183','175 - 300','265 - 550','510 - 832','Location','BestOutside');
        fig = gcf;
        ax = fig.CurrentAxes;
        set(ax,'ytick',[0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80])
        set(ax,'yticklabel',repmat({'0','5'},1,7))
        ylabel('counts/second');
        xlabel('seconds');
        for c=1:7
            line([0,600],[c*10,c*10],'LineStyle','--','Color',[0 0 0])
        end        
        hold off
        
        figure
        title('P1 - P8 High Energy Ions');
        hold on
        plot(1:600,LEMONS(:,23))
        plot(1:600,LEMONS(:,24)+5)
        plot(1:600,LEMONS(:,25)+10)
        plot(1:600,LEMONS(:,26)+15)      
        plot(1:600,LEMONS(:,27)+20)           
        plot(1:600,LEMONS(:,28)+25)
        plot(1:600,LEMONS(:,29)+30)
        plot(1:600,LEMONS(:,30)+35)
        legend('1424 - 2278','2280 - 4492','4491 - 5744','13200 - 25400','8311 - 11449','11474 - 13433','12101 - 58902','25185 - 59000','Location','BestOutside');
        fig = gcf;
        ax = fig.CurrentAxes;
        set(ax,'ytick',[0,2.5,5,7.5,10,12.5,15,17.5,20,22.5,25,27.5,30,32.5,35,37.5,40])
        set(ax,'yticklabel',repmat({'0','2.5'},1,7))
        ylabel('counts/second');
        xlabel('seconds');
        for c=1:7
            line([0,600],[c*5,c*5],'LineStyle','--','Color',[0 0 0])
        end        
        hold off
        
        figure
        title('E0 - E7 High Energy Electrons');
        hold on
        plot(1:600,LEMONS(:,31))
        plot(1:600,LEMONS(:,32)+10)
        plot(1:600,LEMONS(:,33)+20)
        plot(1:600,LEMONS(:,34)+30)      
        plot(1:600,LEMONS(:,35)+40)           
        plot(1:600,LEMONS(:,36)+50)
        plot(1:600,LEMONS(:,37)+60)
        plot(1:600,LEMONS(:,38)+70)
        legend('110 - 365','220 - 485','340 - 1350','600 - 4950','790 - 4750','800 - 2800','1600 - 21000','7000 - 20000','Location','BestOutside');
        fig = gcf;
        ax = fig.CurrentAxes;
        set(ax,'ytick',[0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80])
        set(ax,'yticklabel',repmat({'0','5'},1,7))
        ylabel('counts/second');
        xlabel('seconds');       
        for c=1:7
            line([0,600],[c*10,c*10],'LineStyle','--','Color',[0 0 0])
        end
        hold off
        
        daynumber = datenum(data(11,y),data(12,y),data(13,y)) - datenum(data(11,y),1,1);
        
        str1 = strcat('/media/computation/FantomHD/CassiniLEMMS/BROWSE/LCPRESS0/',num2str(data(11,y)),'/',...
            'LCPRESS0_',num2str(data(11,y)),num2str(daynumber,'%03d'),'_01.PNG'); 
        str2 = strcat('/media/computation/FantomHD/CassiniLEMMS/BROWSE/LPHASPGM0/',num2str(data(11,y)),'/',...
            'LPHASPGM0_',num2str(data(11,y)),num2str(daynumber,'%03d'),'_01.PNG');
        str3 = strcat('/media/computation/FantomHD/CassiniMagData/CAPS_',num2str(data(11,y)),num2str(data(12,y),'%02d')...
            ,num2str(data(13,y),'%02d'),num2str(hour,'%02d'),'0000_060000.png');
        try
            I1 = imread(str1,'png');
            I2 = imread(str2,'png');
            I3 = imread(str3,'png');
            figure
            imshow(I1);
            figure
            imshow(I2);
            figure
            imshow(I3);
            fprintf('Hour %d Minute %d Local Time %d R %d Latitude %d', data(14,y), data(15,y),data(4,y),data(5,y),data(17,y));
            pause
            close all
        catch
            fprintf('no file for this date\n');
            fprintf('Year %d Month %d Day %d Hour %d Minute %d \n',data(11,y),data(12,y),data(13,y),data(14,y),data(15,y));
        end
    end
end 
  %}