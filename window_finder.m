function [windows] = window_finder(boundaries_in_file,j,number_of_crossings,length_of_window,how_many_windows)
    windows = floor(boundaries_in_file(9,j)/length_of_window);
    if number_of_crossings > 1
        if j == 1 
            if boundaries_in_file(9,j) == boundaries_in_file(9,j+1) &&...
               floor(boundaries_in_file(9,j)/length_of_window) < how_many_windows        
                windows = ceil(floor(boundaries_in_file(9,j)/length_of_window)/2);  
            end
        elseif j == number_of_crossings 
            if boundaries_in_file(9,j) == boundaries_in_file(9,j-1) &&...
               floor(boundaries_in_file(9,j)/length_of_window) < how_many_windows
                windows = ceil(floor(boundaries_in_file(9,j)/length_of_window)/2);
            end
        else
            if boundaries_in_file(9,j) == boundaries_in_file(9,j+1)...
               || boundaries_in_file(9,j) == boundaries_in_file(9,j-1)
                windows = ceil(floor(boundaries_in_file(9,j)/length_of_window)/2);
            end
        end
    end
end