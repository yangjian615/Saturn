function [LEMMS_data] = get_LEMMS_data(year,month,day,hour,minute,second)
    day_number = datenum(year,month,day) - datenum(year,1,1);
    if year == 2004 || year == 2008 || year == 2012 
        if day_number < 32
            second_part_path_name = '/001_031_JAN/LEMMS_ACCUMULATION_RATES/';
        elseif day_number > 31 && day_number < 61
            second_part_path_name = '/032_060_FEB/LEMMS_ACCUMULATION_RATES/';                 
        elseif day_number > 60 && day_number < 92         
            second_part_path_name = '/061_091_MAR/LEMMS_ACCUMULATION_RATES/';            
        elseif day_number > 91 && day_number < 122
            second_part_path_name = '/092_121_APR/LEMMS_ACCUMULATION_RATES/';
        elseif day_number > 121 && day_number < 153
            second_part_path_name = '/122_152_MAY/LEMMS_ACCUMULATION_RATES/';               
        elseif day_number > 152 && day_number < 183
            second_part_path_name = '/153_182_JUN/LEMMS_ACCUMULATION_RATES/';             
        elseif day_number > 182 && day_number < 214
            second_part_path_name = '/183_213_JUL/LEMMS_ACCUMULATION_RATES/';               
        elseif day_number > 213 && day_number < 245
            second_part_path_name = '/214_244_AUG/LEMMS_ACCUMULATION_RATES/';                
        elseif day_number > 244 && day_number < 275
            second_part_path_name = '/245_274_SEP/LEMMS_ACCUMULATION_RATES/';                
        elseif day_number > 274 && day_number < 306
            second_part_path_name = '/275_305_OCT/LEMMS_ACCUMULATION_RATES/';                
        elseif day_number > 305 && day_number < 336
            second_part_path_name = '/306_335_NOV/LEMMS_ACCUMULATION_RATES/';                
        else
            second_part_path_name = '/336_366_DEC/LEMMS_ACCUMULATION_RATES/';                
        end
    else 
        if day_number < 32
            second_part_path_name = '/001_031_JAN/LEMMS_ACCUMULATION_RATES/';
        elseif day_number > 31 && day_number < 60
            second_part_path_name = '/032_059_FEB/LEMMS_ACCUMULATION_RATES/';                  
        elseif day_number > 59 && day_number < 91         
            second_part_path_name = '/060_090_MAR/LEMMS_ACCUMULATION_RATES/';            
        elseif day_number > 90 && day_number < 121
            second_part_path_name = '/091_120_APR/LEMMS_ACCUMULATION_RATES/';
        elseif day_number > 120 && day_number < 152
            second_part_path_name = '/121_151_MAY/LEMMS_ACCUMULATION_RATES/';                
        elseif day_number > 151 && day_number < 182
            second_part_path_name = '/152_181_JUN/LEMMS_ACCUMULATION_RATES/';             
        elseif day_number > 181 && day_number < 213
            second_part_path_name = '/182_212_JUL/LEMMS_ACCUMULATION_RATES/';               
        elseif day_number > 212 && day_number < 244
            second_part_path_name = '/213_243_AUG/LEMMS_ACCUMULATION_RATES/';                
        elseif day_number > 243 && day_number < 274
            second_part_path_name = '/244_273_SEP/LEMMS_ACCUMULATION_RATES/';                
        elseif day_number > 273 && day_number < 305
            second_part_path_name = '/274_304_OCT/LEMMS_ACCUMULATION_RATES/';                
        elseif day_number > 304 && day_number < 335
            second_part_path_name = '/305_334_NOV/LEMMS_ACCUMULATION_RATES/';                
        else
            second_part_path_name = '/335_365_DEC/LEMMS_ACCUMULATION_RATES/';                
        end
    end
    for i = 1:4
        path_Name = strcat('/media/computation/FantomHD/LEMMS_uncalibrated/DATA/SATURN/',num2str(year),second_part_path_name);
        file_Name = strcat('LACC',num2str(i),'_',num2str(year),num2str(day_number,'%03d'),'_',num2str(3,'%04d'),'.CSV');
        full_file_Name = strcat(path_Name, file_Name)
        fileID = fopen(full_file_Name, 'r');
        if fileID ~= -1
            break;
        end         
    end
    
    fgetl(fileID);
    fgetl(fileID);
    fgetl(fileID);
    fgetl(fileID);
    fgetl(fileID);
    fgetl(fileID);
    fgetl(fileID);
    
    nextday = 0;
    start_time = hour*60*60 + minute*60; + round(second);
    LEMMS_data = zeros(600,38);
    this_line = fgetl(fileID);
    all_columns = strsplit(this_line,',');
    date_and_time = strsplit(all_columns{2},{'-','T',':'});
    los_segundos = str2double(date_and_time{3})*60*60 + str2double(date_and_time{4})*60 + round(str2double(strrep(date_and_time{5},'"',''))) - start_time;
    
    while los_segundos <= 600
        if los_segundos > 0
            LEMMS_data(los_segundos,1) = str2double(strrep(date_and_time{1},'"',''));%year
            LEMMS_data(los_segundos,2) = str2double(date_and_time{2});%day out of 365
            LEMMS_data(los_segundos,3) = str2double(date_and_time{3});%hour
            LEMMS_data(los_segundos,4) = str2double(date_and_time{4});%minute
            LEMMS_data(los_segundos,5) = str2double(strrep(date_and_time{5},'"',''));%second
            
            interval = str2double(all_columns{5}) - str2double(all_columns{4});
            window = los_segundos+round(interval);
            if window > 600
                window = 600;
            end
                
            %From Krupp 
            %Low energy end ions
            LEMMS_data(los_segundos:window,6) = str2double(all_columns{14})/interval;%A0
            LEMMS_data(los_segundos:window,7) = str2double(all_columns{15})/interval;%A1
            LEMMS_data(los_segundos:window,8) = str2double(all_columns{16})/interval;%A2
            LEMMS_data(los_segundos:window,9) = str2double(all_columns{17})/interval;%A3
            LEMMS_data(los_segundos:window,10) = str2double(all_columns{18})/interval;%A4
            LEMMS_data(los_segundos:window,11) = str2double(all_columns{19})/interval;%A5
            LEMMS_data(los_segundos:window,12) = str2double(all_columns{20})/interval;%A6
            LEMMS_data(los_segundos:window,13) = str2double(all_columns{21})/interval;%A7
            LEMMS_data(los_segundos:window,14) = str2double(all_columns{22})/interval;%A8
            %Low energy end electrons
            LEMMS_data(los_segundos:window,15) = str2double(all_columns{28})/interval;%C0
            LEMMS_data(los_segundos:window,16) = str2double(all_columns{29})/interval;%C1
            LEMMS_data(los_segundos:window,17) = str2double(all_columns{30})/interval;%C2
            LEMMS_data(los_segundos:window,18) = str2double(all_columns{31})/interval;%C3
            LEMMS_data(los_segundos:window,19) = str2double(all_columns{32})/interval;%C4
            LEMMS_data(los_segundos:window,20) = str2double(all_columns{33})/interval;%C5
            LEMMS_data(los_segundos:window,21) = str2double(all_columns{34})/interval;%C6
            LEMMS_data(los_segundos:window,22) = str2double(all_columns{35})/interval;%C7

            %High energy end ions
            LEMMS_data(los_segundos:window,23) = str2double(all_columns{50})/interval; %P1
            LEMMS_data(los_segundos:window,24) = str2double(all_columns{51})/interval; %P2
            LEMMS_data(los_segundos:window,25) = str2double(all_columns{52})/interval; %P3
            LEMMS_data(los_segundos:window,26) = str2double(all_columns{53})/interval; %P4
            LEMMS_data(los_segundos:window,27) = str2double(all_columns{54})/interval; %P5
            LEMMS_data(los_segundos:window,28) = str2double(all_columns{55})/interval; %P6
            LEMMS_data(los_segundos:window,29) = str2double(all_columns{56})/interval; %P7
            LEMMS_data(los_segundos:window,30) = str2double(all_columns{57})/interval; %P8
            %High energy end electrons
            LEMMS_data(los_segundos:window,31) = str2double(all_columns{41})/interval; %E0
            LEMMS_data(los_segundos:window,32) = str2double(all_columns{42})/interval; %E1
            LEMMS_data(los_segundos:window,33) = str2double(all_columns{43})/interval; %E2
            LEMMS_data(los_segundos:window,34) = str2double(all_columns{44})/interval; %E3
            LEMMS_data(los_segundos:window,35) = str2double(all_columns{45})/interval; %E4
            LEMMS_data(los_segundos:window,36) = str2double(all_columns{46})/interval; %E5
            LEMMS_data(los_segundos:window,37) = str2double(all_columns{47})/interval; %E6
            LEMMS_data(los_segundos:window,38) = str2double(all_columns{48})/interval; %E7         
        end
        this_line = fgetl(fileID);
        if ~ischar(this_line)
            file_Name = strcat('LACC',num2str(i),'_',num2str(year),num2str(day_number+1,'%03d'),'_',num2str(3,'%04d'),'.CSV');
            full_file_Name = strcat(path_Name, file_Name)
            fileID = fopen(full_file_Name, 'r');
            fgetl(fileID);
            fgetl(fileID);
            fgetl(fileID);
            fgetl(fileID);
            fgetl(fileID);
            fgetl(fileID);
            fgetl(fileID);
            this_line = fgetl(fileID);
            nextday = 1;
        end
        all_columns = strsplit(this_line,',');
        date_and_time = strsplit(all_columns{2},{'-','T',':'});
        los_segundos = nextday*24*60*60 + str2double(date_and_time{3})*60*60 + str2double(date_and_time{4})*60 + round(str2double(strrep(date_and_time{5},'"',''))) - start_time;  
    end
    fclose(fileID);
    
   