function [los_momentos] = get_LANL_moments()
    location_path_Name = '/home/computation/GitProjects/Saturn/';
    file_name = '2004-2011_LANL_moments.csv';
    formatSpec = ['%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f'];
    data_size = [37 Inf];
    full_file_name = horzcat(location_path_Name, file_name);
    fileID = fopen(full_file_name,'r');
    los_momentos = fscanf(fileID,formatSpec,data_size);
    fclose(fileID);
