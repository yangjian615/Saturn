function H= get_scale_height(L)
    Rs = 60268.0e3; %m
    B_coefficient = 8.70;
    H =sqrt(L^2/(3*B_coefficient));
end
