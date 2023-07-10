% 
% path = '/Users/jasonwong/Projects/Beetle_Learning_MATLAB/Organism_CSVs';
% folders = dir([path,'/','Dal_*']);
% num_folders = size(folders,1);
% ant_folder_nums = [1,2,3,6,9,12,13]; 
% other_folder_nums = [4,5,7,8,10,11];
% all_folder_nums = 1:13;
% for k = 1:size(ant_folder_nums,2)
%     organism = folders(ant_folder_nums(k)).name;
%     load([path,'/',organism,'/',organism,'statistics']);
%     load([path,'/',organism,'/',organism,'statisticslin']);
%     load([path,'/',organism,'/',organism,'app_angle']);
%     
%      if k ==1
%         all_flex = vertcat(flex{:});
%         all_dist = vertcat(distanceslin{:});
%         all_vel = vertcat(velocitylin{1:2:end});
%         all_interaction_velocities = [];
%     
%         
%      else
%         
%         all_dist = vertcat(all_dist,distanceslin{:});
%         all_vel = vertcat(all_vel, velocitylin{1:2:end});
%         all_flex = vertcat(all_flex, flex{:});
%      end
% end

distances_divs = [0:40:400]
flex_by_dist = zeros(1,9);
vel_by_dist = zeros(1,9);
for i = 1:9
    dist(i,:) = all_dist.midDist < distances_divs(i+1) & all_dist.midDist > distances_divs(i);
    flex_by_dist(i) = mean(all_flex.angles(dist(i,:)), "omitnan");
    vel_by_dist(i) = mean(all_vel.dalotia_velocities(dist(i,:)),"omitnan");
end
plot(distances_divs(1:9),vel_by_dist)