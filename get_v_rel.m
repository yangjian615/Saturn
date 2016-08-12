function [v_phi_rel, v_r_rel] = get_v_rel(L)
    v_phi_rel = (7.2*L-23)*1e3;
    v_r_rel = (-0.74*L+15)*1e3;
    v_rel = sqrt(v_r_rel^2+v_phi_rel^2);
end