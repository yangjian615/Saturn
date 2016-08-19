function [density,T,v_r_rel,v_phi_rel] = find_moment_data(i,crossings,moments)

    if crossings(7,i) == 1
        ze_condition = moments(7,:) ~= 0 & moments(2,:) == crossings(1,i) & moments(3,:)*24*60 ...
        + moments(4,:)*60 + moments(5,:) + moments(6,:)/60 <= crossings(8,i) - 24*60*(datenum(crossings(1,i),1,1)-datenum(2004,1,1)) &...
        abs(moments(29,:)) < 11 & moments(3,:)*24*60 + moments(4,:)*60 + moments(5,:) + moments(6,:)/60 > crossings(8,i)...
        - 24*60*(datenum(crossings(1,i),1,1)-datenum(2004,1,1)) - crossings(9,i);
    else
        ze_condition = moments(7,:) ~= 0 & moments(2,:) == crossings(1,i) & moments(3,:)*24*60 ... 
        + moments(4,:)*60 + moments(5,:) + moments(6,:)/60 >= crossings(8,i) - 24*60*(datenum(crossings(1,i),1,1)-datenum(2004,1,1)) &...
        abs(moments(29,:)) < 11 & moments(3,:)*24*60 + moments(4,:)*60 + moments(5,:) + moments(6,:)/60 < crossings(8,i)...
        - 24*60*(datenum(crossings(1,i),1,1)-datenum(2004,1,1)) + crossings(9,i);
    end

    years = moments(2,ze_condition);
    days = moments(3,ze_condition);
    hours = moments(4,ze_condition);
    minutes = moments(5,ze_condition);
    times = horzcat(transpose(years),transpose(days),transpose(hours),transpose(minutes));

    densities = moments(7,ze_condition);
    density = (.001/6.022140857e23)*geomean(densities);
    temps = moments(8,ze_condition);
    T = 11600*geomean(temps);
    
    v_rs = moments(9,ze_condition);
    v_r_rel_pos = 1000*geomean(v_rs(v_rs > 0));
    v_r_rel_neg = -1000*geomean(-1*v_rs(v_rs < 0));
    pos_points = sum(v_rs(v_rs > 0));
    neg_points = sum(v_rs(v_rs < 0));
    total_points = pos_points + neg_points;
    v_r_rel = v_r_rel_pos*(pos_points/total_points) + v_r_rel_neg*(neg_points/total_points);
    
    v_phis = moments(10,ze_condition);
    v_phi_rel_pos = 1000*geomean(v_phis(v_phis > 0));
    v_phi_rel_neg = -1000*geomean(-1*v_phis(v_phis < 0));
    pos_points = sum(v_phis(v_phis > 0));
    neg_points = sum(v_phis(v_phis < 0));
    total_points = pos_points + neg_points;
    v_phi_rel = v_phi_rel_pos*(pos_points/total_points) + v_phi_rel_neg*(neg_points/total_points);
    