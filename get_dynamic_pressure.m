function Dp = get_dynamic_pressure(R,theta)
%uses model from Kanani
a1 = 10.3;
a2 = 0.2;
a3 = 0.73;
a4 = 0.4;

a = 0.00001;
b = 1;
c = (a+b)/2;

lambda = (2/(1+cos(theta)));

while true
    first = R/(a1*lambda^(a3)) - a^(-a2)*lambda^(a4*a);
    middle = R/(a1*lambda^(a3)) - c^(-a2)*lambda^(a4*c);
    second = R/(a1*lambda^(a3)) - b^(-a2)*lambda^(a4*b);    
    if sqrt(middle^2) < 0.0001
        Dp = c;
        break
    elseif first < 0 && middle > 0
        b = c;
        c = (a+b)/2;
    elseif middle < 0 && second > 0
        a = c;
        c = (a+b)/2;
    else
        a = a*0.1;
        b = b + 0.1;
        if b > 10
            Dp = 0;
            break
        end
    end
end


