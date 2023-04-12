path = '/Users/jasonwong/Projects/Beetle_Learning_MATLAB/Organism_CSVs';
folders = dir([path,'/','Dal_*']);
num_folders = size(folders,1);
folder_nums = [1:11];
approach_speed = [];
flex_during =[];
flex_after = [];
dal_velocity_after = [];
curve = [];
orientation = [];
for k = 1:size(folder_nums,2)
    organism = folders(folder_nums(k)).name;
    load([path,'/',organism,'/',organism,'statistics']);
    load([path,'/',organism,'/',organism,'long_dist_interactions']);
    load([path,'/',organism,'/',organism,'before_interactions']);
     if k ==1
        all_flex = vertcat(flex{:});
        all_dist = vertcat(distances{:});
     else
        all_flex = vertcat(all_flex, flex{:});
        all_dist = vertcat(all_dist,distances{:});
     end
    approach_speed_temp = [];
    flex_during_temp =[];
    flex_after_temp = [];
    dal_velocity_after_temp = [];
    curve_temp = [];
    orientation_temp = [];
    for i = 1:size(interactions,1)
         long_interactions = interactions{i}((interactions{i}.Var2 - interactions{i}.Var1)>10,:);
%         long_long_interactions = long_dist_interactions{i}((long_dist_interactions{i}.Var2 - long_dist_interactions{i}.Var1)>0,:);
        
        
%          long_before_interactions = before_interactions{i}((before_interactions{i}.Var2 - before_interactions{i}.Var1)>15,:);
        for j = 1:size(long_interactions)
            starts = long_interactions.Var1(j,1);
            endings = long_interactions.Var2(j,1);
            approach_speed_temp(end+1) = mean(velocity{2*i-1}.other_velocities(max(starts,1):endings,1),'omitnan');
            flex_during_temp(end+1) = mean(flex{i}.angles(max(starts-60,1):min(endings+90,size(flex{i})),1),'omitnan');
            flex_after_temp(end+1) = mean(flex{i}.angles(endings:min(endings+90,size(flex{i})),1),"omitnan");
            dal_velocity_after_temp(end+1) = mean(velocity{2*i-1}.dalotia_velocities(endings:min(endings+90,size(velocity{2*i-1})),1),"omitnan");
            curve_temp(end+1)= mean(curvature{i}.other_curvatures(max(starts-90,1):starts,1),'omitnan');
            orientations = distances{i}.midDist - distances{i}.headDist;
            orientation_temp(end+1) = mean(orientations(max(starts-5,1):starts,1),'omitnan');
            individual_stats{k,1} = {organism, approach_speed_temp,flex_during_temp,flex_after_temp,dal_velocity_after_temp,curve_temp,orientation_temp}; 
           
        end
        
    end
    individual_stats{k} = {organism, approach_speed_temp,flex_during_temp,flex_after_temp,dal_velocity_after_temp,curve_temp,orientation_temp}; 
    approach_speed = [approach_speed,approach_speed_temp];
    flex_during =[flex_during,flex_during_temp];
    flex_after = [flex_after,flex_after_temp];
    dal_velocity_after = [dal_velocity_after,dal_velocity_after_temp];
    curve = [curve,curve_temp];
    orientation = [orientation,orientation_temp];
end
flex1 = flex_during(approach_speed<10000);
flex2 = flex_during(approach_speed>10000 & approach_speed<20000);
flex3 = flex_during(approach_speed>20000 & approach_speed<30000);
flex4 = flex_during(approach_speed>30000);
dist = vertcat(distances{:,1});
flexion = vertcat(flex{:,1});

max_flex = max(flex_during)

set(0,'defaultAxesFontSize',15)

subplot(2,2,1)
avgSpeed = [10338,	6013,	6120,	23960,	15308,	24278,	3472,	4031,	7169,	9331,	8386];
avgFlex = [2.395,	2.350,	2.376,  2.264,   2.414,	2.14,	2.415,	2.409,	2.593,	2.508,	2.341];
scatter(avgSpeed,avgFlex)
labels = {'M-L','S','L','M','S','S','L','L','M-L','S','S'};
z = labelpoints(avgSpeed,avgFlex,labels,'N')
title('Average Approach Speed vs Average Flex of Interaction per Species')
xlabel('Approach Speed (pixel/s')
ylabel('Flexion (radians)')

subplot(2,2,3)
scatter(orientation(flex_during<2.5),approach_speed(flex_during<2.5))
xlim([-100,100])
ylim([0,5000])
title('Orientation and Approach Speed of interactions w/ Avg flex <2.5')
xlabel('Orientation (midDist - HeadDist)')
ylabel('Approach Speed (pixel/second')
subplot(2,2,4)
scatter(orientation(flex_during<2),approach_speed(flex_during<2))
xlim([-100,100])
ylim([0,5000])
title('Orientation and Approach Speed of interactions w/ Avg flex <2')
xlabel('Orientation (midDist - HeadDist)')
ylabel('Approach Speed (pixel/second')
subplot(2,2,2)
scatter(orientation,approach_speed)
xlim([-100,100])
ylim([0,5000])
title('Orientation and Approach Speed of All Interactions')
xlabel('Orientation (midDist - HeadDist)')
ylabel('Approach Speed (pixel/second)')

% for i = 1:11
%     subplot(3,4,i+1)
%     scatter(individual_stats{i}{7}(individual_stats{i}{3}<=2.5),individual_stats{i}{2}(individual_stats{i}{3}<=2.5),10)
%     xlabel('orientation')
%     ylabel('approach speed into the 50-250 range')
%     title({'Ant Medium Large. Avg flex: ',mean(individual_stats{i}{3},"omitnan"),' Avg Approach Velocity: ', mean(individual_stats{i}{2},"omitnan")})
%     xlim([-70,70])
%     colorbar
%     ylim([0,7000]);
% end
