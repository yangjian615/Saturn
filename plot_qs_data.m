function [] = plot_qs_data(data_qs,data_nqs)
    x1 = data_qs(2,:).*cos(pi+(data_qs(1,:)*(2*pi/24)));
    y1 = data_qs(2,:).*sin(pi+(data_qs(1,:)*(2*pi/24)));

    x2 = data_nqs(2,:).*cos(pi+(data_nqs(1,:)*(2*pi/24)));
    y2 = data_nqs(2,:).*sin(pi+(data_nqs(1,:)*(2*pi/24)));

    total = 0;
    x3 = horzcat(data_qs(1,:),data_nqs(1,:));
    for i = 1:24
        total(i) = sum(floor(x3(:)) == i);
    end

    figure
    scatter(x1,y1,'o')
    hold on
    scatter(x2,y2,'.')
    Dp = get_dynamic_pressure(min(data_qs(2,:)),pi+data_qs(1,find(data_qs(2,:) == min(data_qs(2,:)),1))*(2*pi/24));
    theta = -3*pi/4:(2*pi/24):3*pi/4
    r = 10.3*(Dp^(-0.20)).*(2./(1+cos(theta))).^(0.73 + 0.4*Dp);
    a = r.*cos(theta);
    b = r.*sin(theta);
    plot(a,b,'k','LineWidth',2);
%{
    z = zeros(size(a));
    col = log10(total(3:21));  % This is the color, vary with x in this case.

    surface([a;a],[b;b],[z;z],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',2);

%}
hold off