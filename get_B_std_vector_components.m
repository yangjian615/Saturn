function [B_fluctuation_parallel, B_fluctuation_perp, B_std_parallel, B_std_perp] = get_B_std_vector_components(B_vector_mean, B_r, B_theta, B_phi)
    length_B = length(B_r);
    B_vector = [B_r, B_theta, B_phi].';
    
    unit_B_vector_mean = B_vector_mean/sqrt(B_vector_mean(1)^2 + B_vector_mean(2)^2 + B_vector_mean(3)^2);
    
    
    B_mean(1,1:length_B) = B_vector_mean(1);
    B_mean(2,1:length_B) = B_vector_mean(2);
    B_mean(3,1:length_B) = B_vector_mean(3);
    
    unit_B_mean(1,1:length_B) = unit_B_vector_mean(1);
    unit_B_mean(2,1:length_B) = unit_B_vector_mean(2);
    unit_B_mean(3,1:length_B) = unit_B_vector_mean(3);
    
    B_fluctuation_parallel(1,:) = B_mean(1,:) - dot(B_vector, B_mean).*unit_B_mean(1,:);
    B_fluctuation_parallel(2,:) = B_mean(2,:) - dot(B_vector, B_mean).*unit_B_mean(2,:);
    B_fluctuation_parallel(3,:) = B_mean(3,:) - dot(B_vector, B_mean).*unit_B_mean(3,:);

%     B_std_parallel(1,:) = dot(B_vector, B_mean).*unit_B_mean(1,:);
%     B_std_parallel(2,:) = dot(B_vector, B_mean).*unit_B_mean(2,:);
%     B_std_parallel(3,:) = dot(B_vector, B_mean).*unit_B_mean(3,:);
    
    B_fluctuation_perp(1,:) = B_vector(1,:) - dot(B_vector, B_mean).*unit_B_mean(1,:);
    B_fluctuation_perp(2,:) = B_vector(2,:) - dot(B_vector, B_mean).*unit_B_mean(2,:);
    B_fluctuation_perp(3,:) = B_vector(3,:) - dot(B_vector, B_mean).*unit_B_mean(3,:);
    
%     B_vector_test1 = B_vector - (B_std_parallel + B_std_prep);
    B_std_parallel = std(sqrt(B_fluctuation_parallel(1,:).^2 + B_fluctuation_parallel(1,:).^2 + B_fluctuation_parallel(1,:).^2));
    B_std_perp = std(sqrt(B_fluctuation_perp(1,:).^2 + B_fluctuation_perp(1,:).^2 + B_fluctuation_perp(1,:).^2));
    
end