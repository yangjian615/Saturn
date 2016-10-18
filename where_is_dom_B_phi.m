function where_is_dom_B_phi(data)
    LT = data(4,:);
    which_window = data(3,:);
    how_many = zeros(24,1);
    for i = 1:24
        how_many(i) = sum(floor(LT) == i);
    end
    figure
    plot(1:24,how_many);

    B_r = data(6,:);
    B_theta = data(7,:);
    B_phi = data(8,:);

    how_many_big_phi = zeros(24,1);
    for i = 1:24
        how_many_big_phi(i) = sum(floor(LT) == i & B_phi.^2 > (B_r.^2 + B_theta.^2) & which_window < 5);
    end
        
    figure
    
    plot(1:24,how_many_big_phi./how_many)