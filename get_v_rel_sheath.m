function [v_phi_rel,v_r_rel] = get_v_rel_sheath(R,LT)
    Dp = get_dynamic_pressure(R,LT);
    %for plotting
    %theta = 0:0.01:3*pi/4;
    %r = 10.3*(Dp^(-0.20)).*(2./(1+cos(theta))).^(0.73 + 0.4*Dp);
    %x = r.*cos(theta);
    %y = r.*sin(theta);
    %plot(x,y);
    
    a1 = 10.3;
    a2 = 0.2;
    a3 = 0.73;
    a4 = 0.4;
    R0 = a1*(Dp^(-a2));
    
    f = R0*(2/(1+cos(LT)))^(a3+a4*Dp);
    ff = (2*R0*(a3 + a4*Dp)*sin(LT))/((1 + cos(LT))^2)*(2/(1 + cos(LT)))^(a3 + a4*Dp - 1);
    slope1 = -abs((ff*sin(LT) + f*cos(LT))/(ff*cos(LT) - f*sin(LT)));
    
    f2 = R0*(2/(1+cos(3*pi/4)))^(a3+a4*Dp);
    ff2 = (2*R0*(a3 + a4*Dp)*sin(3*pi/4))/((1 + cos(3*pi/4))^2)*(2/(1 + cos(3*pi/4)))^(a3 + a4*Dp - 1);
    slope2 = -abs((ff2*sin(3*pi/4) + f2*cos(3*pi/4))/(ff2*cos(3*pi/4) - f2*sin(3*pi/4)));

    
    v_phi_rel = f*sqrt((400000*slope2/slope1)^2/(ff^2+f^2));
    v_r_rel = sqrt((400000*slope2/slope1)^2 - v_phi_rel^2);

    %v = v_r_rel*v_r_rel + v_phi_rel*v_phi_rel
   
   