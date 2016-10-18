function [B_parallel_pertr, B_perp_pertr, B_parallel_std, B_perp_std] = get_B_std_vector_components(B_vector_mean, B_r, B_theta, B_phi)
% 	length_B = length(B_r);    
%     B_vector = [B_r, B_theta, B_phi].';
%     
%     B_ave(1,1:length_B) = B_vector_mean(1);
%     B_ave(2,1:length_B) = B_vector_mean(2);
%     B_ave(3,1:length_B) = B_vector_mean(3);
%     
%     unit_B_ave = [(B_ave(1,:)./sqrt(B_ave(1,:).^2 + B_ave(2,:).^2 + B_ave(3,:).^2)).', ...
%                  (B_ave(2,:)./sqrt(B_ave(1,:).^2 + B_ave(2,:).^2 + B_ave(3,:).^2)).', ...
%                  (B_ave(3,:)./sqrt(B_ave(1,:).^2 + B_ave(2,:).^2 + B_ave(3,:).^2)).'].';
%              
%     
%     B_parallel_to_ave(1,:) = dot(B_vector, unit_B_ave).*unit_B_ave(1,:);
%     B_parallel_to_ave(2,:) = dot(B_vector, unit_B_ave).*unit_B_ave(2,:);
%     B_parallel_to_ave(3,:) = dot(B_vector, unit_B_ave).*unit_B_ave(3,:);
%     
%     B_parallel_pertr = B_parallel_to_ave - B_ave;
%     B_perp_pertr = B_vector - B_parallel_to_ave;
% 
%     B_parallel_std = std(sqrt(B_parallel_pertr(1,:).^2 + B_parallel_pertr(2,:).^2 + B_parallel_pertr(3,:).^2));
%     B_perp_std = std(sqrt(B_perp_pertr(1,:).^2 + B_perp_pertr(2,:).^2 + B_perp_pertr(3,:).^2));
%     
%     
%     B_perp_pertr_mag = sqrt(B_parallel_pertr(1,:).^2 + B_parallel_pertr(2,:).^2 + B_parallel_pertr(3,:).^2);
%     B_perp_std_mag = sqrt(B_perp_pertr(1,:).^2 + B_perp_pertr(2,:).^2 + B_perp_pertr(3,:).^2);
% 
%     B_parallel_pertr_mag = sqrt(B_parallel_pertr(1,:).^2 + B_parallel_pertr(2,:).^2 + B_parallel_pertr(3,:).^2);
%     B_perp_std_mag = sqrt(B_perp_pertr(1,:).^2 + B_perp_pertr(2,:).^2 + B_perp_pertr(3,:).^2);  
%     
%     figure(12)
%     clf
%     plot(B_perp_std_mag, 'b')
%     hold on
%     plot(B_parallel_pertr_mag, 'k')
%     hold on 
%----------------------------------------------------------------------------------------------------------------------------------


    length_B = length(B_r);    
    B_vector = [B_r, B_theta, B_phi].';
    
    B_ave(1,1:length_B) = B_vector_mean(1);
    B_ave(2,1:length_B) = B_vector_mean(2);
    B_ave(3,1:length_B) = B_vector_mean(3);
    
    unit_B_ave = [(B_ave(1,:)./sqrt(B_ave(1,:).^2 + B_ave(2,:).^2 + B_ave(3,:).^2)).', ...
                 (B_ave(2,:)./sqrt(B_ave(1,:).^2 + B_ave(2,:).^2 + B_ave(3,:).^2)).', ...
                 (B_ave(3,:)./sqrt(B_ave(1,:).^2 + B_ave(2,:).^2 + B_ave(3,:).^2)).'].';
    
    B_pertr = B_vector - B_ave;
    
    B_parallel_pertr(1,:) = dot(B_pertr, unit_B_ave).*unit_B_ave(1,:);
    B_parallel_pertr(2,:) = dot(B_pertr, unit_B_ave).*unit_B_ave(2,:);
    B_parallel_pertr(3,:) = dot(B_pertr, unit_B_ave).*unit_B_ave(3,:);
    
    B_perp_pertr = B_pertr - B_parallel_pertr;

    B_parallel_std = std(sqrt(B_parallel_pertr(1,:).^2 + B_parallel_pertr(2,:).^2 + B_parallel_pertr(3,:).^2));
    B_perp_std = std(sqrt(B_perp_pertr(1,:).^2 + B_perp_pertr(2,:).^2 + B_perp_pertr(3,:).^2));

    
    
%----------------------------------------------------------------------------------------------------------------------------  
    
     
    
%     length_B = length(B_r);
%     B_vector = [B_r, B_theta, B_phi].';
%     
%     unit_B_vector_mean = B_vector_mean/sqrt(B_vector_mean(1)^2 + B_vector_mean(2)^2 + B_vector_mean(3)^2);
%     
%     
%     B_mean(1,1:length_B) = B_vector_mean(1);
%     B_mean(2,1:length_B) = B_vector_mean(2);
%     B_mean(3,1:length_B) = B_vector_mean(3);
%     
%     unit_B_mean(1,1:length_B) = unit_B_vector_mean(1);
%     unit_B_mean(2,1:length_B) = unit_B_vector_mean(2);
%     unit_B_mean(3,1:length_B) = unit_B_vector_mean(3);
%     
%     B_parallel_pertr(1,:) = B_mean(1,:) - dot(B_vector, B_mean).*unit_B_mean(1,:);
%     B_parallel_pertr(2,:) = B_mean(2,:) - dot(B_vector, B_mean).*unit_B_mean(2,:);
%     B_parallel_pertr(3,:) = B_mean(3,:) - dot(B_vector, B_mean).*unit_B_mean(3,:);
% 
% %     B_std_parallel(1,:) = dot(B_vector, B_mean).*unit_B_mean(1,:);
% %     B_std_parallel(2,:) = dot(B_vector, B_mean).*unit_B_mean(2,:);
% %     B_std_parallel(3,:) = dot(B_vector, B_mean).*unit_B_mean(3,:);
%     
%     B_perp_pertr(1,:) = B_vector(1,:) - dot(B_vector, B_mean).*unit_B_mean(1,:);
%     B_perp_pertr(2,:) = B_vector(2,:) - dot(B_vector, B_mean).*unit_B_mean(2,:);
%     B_perp_pertr(3,:) = B_vector(3,:) - dot(B_vector, B_mean).*unit_B_mean(3,:);
% 
%     B_parallel_std = std(sqrt(B_parallel_pertr(1,:).^2 + B_parallel_pertr(1,:).^2 + B_parallel_pertr(1,:).^2));
%     B_perp_std = std(sqrt(B_perp_pertr(1,:).^2 + B_perp_pertr(1,:).^2 + B_perp_pertr(1,:).^2));
    
%----------------------------------------------------------------------------------------------------------------------------    
%     B_parallel_pertr_mag = sqrt(B_parallel_pertr(1,:).^2 + B_parallel_pertr(2,:).^2 + B_parallel_pertr(3,:).^2);
%     B_perp_std_mag = sqrt(B_perp_pertr(1,:).^2 + B_perp_pertr(2,:).^2 + B_perp_pertr(3,:).^2);  
%     
%     figure(12)
%     clf
%     plot(B_perp_std_mag, 'b')
%     hold on
%     plot(B_parallel_pertr_mag, 'k')
%     hold on   
    
end