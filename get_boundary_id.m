function [magnetic_field_boundary_ID]=get_boundary_id(location_initial, location_final, regions_boundary_data)                                       
    a = 1;
    window_start_datenum = datenum(location_initial(1), location_initial(2), location_initial(3), location_initial(4), 0, 0);
    window_end_datenum = datenum(location_final(1), location_final(2), location_final(3), location_final(4), 0, 0);
    [n, length_of_boundary_data] = size(regions_boundary_data);

    boundary_date = datenum(regions_boundary_data(1,a), regions_boundary_data(2,a), regions_boundary_data(3,a),...
                        regions_boundary_data(4,a), regions_boundary_data(5,a), regions_boundary_data(6,a));
   
    while (boundary_date < window_start_datenum & a <= length_of_boundary_data)
        a = a+1;
        boundary_date = datenum(regions_boundary_data(1,a), regions_boundary_data(2,a), regions_boundary_data(3,a),...
                        regions_boundary_data(4,a), regions_boundary_data(5,a), regions_boundary_data(6,a));
    end
    
    magnetic_field_boundary_ID_change = regions_boundary_data(7, ...
            (regions_boundary_data(1,:) < location_final(1) & regions_boundary_data(1,:) >= location_initial(1)) & ...  
            (regions_boundary_data(2,:) < location_final(2) & regions_boundary_data(2,:) >= location_initial(2)) & ...  
            (regions_boundary_data(3,:) < location_final(3) & regions_boundary_data(3,:) >= location_initial(3)) & ...  
            (regions_boundary_data(4,:) < location_final(4) & regions_boundary_data(4,:) >= location_initial(4)));

    [n, length_magnetic_field_boundary_ID_change] = size(magnetic_field_boundary_ID_change);
    
    if magnetic_field_boundary_ID_change > 0
        magnetic_field_boundary_ID(1) = regions_boundary_data(7,a-1);
        magnetic_field_boundary_ID(2:length(magnetic_field_boundary_ID_change)) = magnetic_field_boundary_ID_change;
    else
        magnetic_field_boundary_ID = regions_boundary_data(7,a-1);
    end
end
