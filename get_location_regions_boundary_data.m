function [regions_boundary_data] = get_location_regions_boundary_data()    
    location_path_Name = '/home/computation/GitProjects/Saturn/';
    boundary_file_name = 'Delamere_bc_ids-2.txt';
    
    boundary_formatSpec = ['%d %d %d %d %d %d %d'];
    
    boundary_data_size = [7 Inf];
    
    boundary_full_file_name = horzcat(location_path_Name, boundary_file_name);
    
    boundary_fileID = fopen(boundary_full_file_name,'r');
    
    regions_boundary_data = fscanf(boundary_fileID,boundary_formatSpec,boundary_data_size);
    
    fclose(boundary_fileID)

%     date_of_location = datetime(datenum(location_data_read(1,:), month(location_data_read(2,:)), day(location_data_read(2,:)), location_data_read(3,:), location_data_read(4,:), floor(location_data_read(5,:))), 'ConvertFrom', 'datenum');

end