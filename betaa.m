function [] = betaa(plasma_beta,LT)
    color_plot = zeros(24,20);
    for i = 1:20
        for j = 1:24
            color_plot(j,i) = mean(plasma_beta(floor(LT(:,i)) == j,i));
        end
    end
color_plot
figure
pcolor(log10(color_plot))
colorbar
end
        