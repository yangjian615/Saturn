function l_prependicular = get_magnetic_field_prependicular_length(tau, v_phi_rel, v_r_rel,mag_is_1_sheath_is_0)
    if mag_is_1_sheath_is_0
        v_rel = v_phi_rel;
    else
        v_rel = sqrt(v_phi_rel^2 + v_r_rel^2);
    end
    l_prependicular = tau*v_rel;
end
