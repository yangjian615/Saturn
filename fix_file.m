path_Name = '/home/computation/GitProjects/';
file_Name1 = 'pre&postnoon_flagged.txt';
file_Name2 = 'pre&postnoon_lat_halfies.txt';
full_file_Name1 = strcat(path_Name, file_Name1);
full_file_Name2 = strcat(path_Name, file_Name2);
fileID1 = fopen(full_file_Name1, 'r');
fileID2 = fopen(full_file_Name2, 'r');
fgetl(fileID1);
fgetl(fileID1);
fgetl(fileID1);
fgetl(fileID1);
fgetl(fileID1);
fgetl(fileID1);
fgetl(fileID1);
fgetl(fileID1);
fgetl(fileID1);
fgetl(fileID2);
ready = true;

if ready
    %moment_times_path_Name_w = '/home/computation/GitProjects/';
    %moment_times_file_Name_w = 'pre&postnoon_fixed&flagged&halved.txt';     
    %moment_times_file_Name = horzcat(moment_times_path_Name_w, moment_times_file_Name_w);
    %moment_times_fileID = fopen(moment_times_file_Name, 'wt');
    more_times_fileID = fopen('/home/computation/GitProjects/missed_these.txt', 'wt')

    header = 'Year        DOY        Hour       Min       Sec        LT\n'; 
    fprintf(more_times_fileID, header); 
end


lat = fgetl(fileID2);
flag = fgetl(fileID1);
while lat ~= -1
    flag_cell = cellstr(flag);
    flag_str = strsplit(flag_cell{1});
    lat_cell = cellstr(lat);
    lat_str = strsplit(lat_cell{1});

    yl_comp = lat_str{1};
    yf_comp = flag_str{1};
    yl = lat_str(1);
    yf = flag_str(1);
    doyl = lat_str(2);
    doyf = flag_str(2);
    hrl = lat_str(3);
    hrf = flag_str(3);
    minl = lat_str(4);
    minf = flag_str(4);
    secl = lat_str(5);
    secf = flag_str(5);
    LTf = flag_str(6);
    LTl = lat_str(6);

    while ~strcmp(yl_comp,yf_comp(3:end)) || ~strcmp(doyl,doyf) || ~strcmp(hrl,hrf) || ~strcmp(minl,minf) || ~strcmp(secl,secf)
        if (str2double(yf) > str2double(yl)) ||...
            str2double(doyf) + str2double(hrf)/24 + str2double(minf)/(24*60) + str2double(secf)/(24*60*60) >...
            str2double(doyl) + str2double(hrl)/24 + str2double(minl)/(24*60) + str2double(secl)/(24*60*60)  
            
            ready = false;
            times_to_write = [yl{1} ' ' doyl{1} ' ' hrl{1} ' ' minl{1} ' ' secl{1} ' ' LTl{1}] ;     
            fprintf(more_times_fileID, '%s\n', times_to_write);
        break
        end

        flag = fgetl(fileID1);
        flag_cell = cellstr(flag);
        flag_str = strsplit(flag_cell{1});

        yf_comp = flag_str{1};
        yf = flag_str(1);
        doyf = flag_str(2);
        hrf = flag_str(3);
        minf = flag_str(4);
        secf = flag_str(5);
        LTf = flag_str(6);
    end
    if ready
        %times_to_write = [yf{1} ' ' doyf{1} ' ' hrf{1} ' ' minf{1} ' ' secf{1} ' ' LTf{1}] ;     
        %fprintf(moment_times_fileID, '%s\n', times_to_write);
        flag = fgetl(fileID1);
    end

lat = fgetl(fileID2);
ready = true;
end

fclose(fileID1);
fclose(fileID2);
fclose(moment_times_fileID);


