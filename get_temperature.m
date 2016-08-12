function T=get_temperature(H)
        m_w = 18e-3; %kg/mol
        m_p = 1.007276466879; %kg/mol
    
        Rs = 60268.0*1e3; %m
        k_B = 1.3806488e-23; %J/K 

        avagadro_constant = 6.022140857e23; %mol^-1
        T = 1.56*(m_w/m_p)*(H/Rs)^2*(1/k_B);
%     T = 3/2*m_w/(avagadro_constant*k)*v_phi^2*H^2
end