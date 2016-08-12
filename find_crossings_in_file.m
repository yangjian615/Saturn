function [boundaries_in_file,boundaries_inside,crossing_date] = find_crossings_in_file(magnetometer_data,dates,ordered_crossings,start,boundaries_inside,crossing_date,sheath_or_mag)

    [g,length_of_magnetometer_data] = size(magnetometer_data);

if sheath_or_mag     
    while(crossing_date <= dates(length_of_magnetometer_data))
        if ordered_crossings(7,boundaries_inside) == 1
            if  crossing_date + ordered_crossings(9,boundaries_inside) > dates(length_of_magnetometer_data)
                ordered_crossings(9,boundaries_inside) = min([dates(length_of_magnetometer_data) -...
                    crossing_date,ordered_crossings(9,boundaries_inside)]);
            end
            boundaries_inside = boundaries_inside + 1;
            crossing_date = ordered_crossings(8,boundaries_inside);
        else
            if crossing_date - ordered_crossings(9,boundaries_inside) < dates(1)
                ordered_crossings(9,boundaries_inside) = min([crossing_date -...
                    dates(1),ordered_crossings(9,boundaries_inside)]);
            end
            boundaries_inside = boundaries_inside + 1;
            crossing_date = ordered_crossings(8,boundaries_inside);
        end                
    end
    boundaries_in_file = ordered_crossings(:,start:boundaries_inside-1);
else
    while(crossing_date <= dates(length_of_magnetometer_data))
        if ordered_crossings(7,boundaries_inside) == 2
            if  crossing_date + ordered_crossings(9,boundaries_inside) > dates(length_of_magnetometer_data)
                ordered_crossings(9,boundaries_inside) = min([dates(length_of_magnetometer_data) -...
                    crossing_date,ordered_crossings(9,boundaries_inside)]);
            end
            boundaries_inside = boundaries_inside + 1;
            crossing_date = ordered_crossings(8,boundaries_inside);
        else
            if crossing_date - ordered_crossings(9,boundaries_inside) < dates(1)
                ordered_crossings(9,boundaries_inside) = min([crossing_date -...
                    dates(1),ordered_crossings(9,boundaries_inside)]);
            end
            boundaries_inside = boundaries_inside + 1;
            crossing_date = ordered_crossings(8,boundaries_inside);
        end                
    end
    boundaries_in_file = ordered_crossings(:,start:boundaries_inside-1);   
end  
end