function [location_data] = get_location_data()    
    location_path_Name = '/home/computation/Documents/MATLAB/Saturn_power_spectrum2/'; 
    location_file_Name = 'Cassini_orbits_2004-2012.txt';    
    
    
    location_formatSpec = ['%d %d %d %d %f %f %f %f %f %f %f %f']; 
    
    location_data_size = [12 Inf];

    location_full_file_Name = horzcat(location_path_Name, location_file_Name);

    location_fileID = fopen(location_full_file_Name, 'r');

    location_data_read = fscanf(location_fileID, location_formatSpec, location_data_size);
    
    fclose(location_fileID);
 
    [n, length_location_data_read] = size(location_data_read);
    
    
    for i = 1: length_location_data_read
        if location_data_read(1,i)==2004 | location_data_read(1,i)==2008 | location_data_read(1,i)==2012
            location_data(1:4,i) = [location_data_read(1,i); month(location_data_read(2,i)); day(location_data_read(2,i)); location_data_read(3,i)];
            location_data(5:11,i) = location_data_read(6:12,i);
        elseif (month(location_data_read(2,i)) == 2 & day(location_data_read(2,i))>28) | month(location_data_read(2,i))>2
            location_data(1:4,i) = [location_data_read(1,i); month(location_data_read(2,i)+1); day(location_data_read(2,i)+1); location_data_read(3,i)];
            location_data(5:11,i) = location_data_read(6:12,i);     
        else
            location_data(1:4,i) = [location_data_read(1,i); month(location_data_read(2,i)); day(location_data_read(2,i)); location_data_read(3,i)];
            location_data(5:11,i) = location_data_read(6:12,i);
        end            
                
    end
    
end