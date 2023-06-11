path = '/Users/jasonwong/Projects/Beetle_Learning_MATLAB/Organism_CSVs';
folders = dir([path,'/','Dal_*']);
num_folders = size(folders,1);
ant_folder_nums = [1,2,3,6,9,12,13];
other_folder_nums = [4,5,7,8,10,11];
all_folder_nums = 1:13;
approach_speed = [];
flex_during =[];
flex_after = [];
dal_velocity_after = [];
curve = [];
orientation = [];
length = [];
dal_approach_speed = [];
other_velocity_after = [];
other_orientation = [];
max_length = 0;
for k = 1:size(ant_folder_nums,2)
    organism = folders(ant_folder_nums(k)).name;
    load([path,'/',organism,'/',organism,'statistics']);
    load([path,'/',organism,'/',organism,'statisticslin']);
    
     if k ==1
        all_flex = vertcat(flex{:});
        all_dist = vertcat(distanceslin{:});
        all_vel = vertcat(velocitylin{1:2:end});
        all_interaction_velocities = [];
        
     else
        all_flex = vertcat(all_flex, flex{:});
        all_dist = vertcat(all_dist,distanceslin{:});
        all_vel = vertcat(all_vel, velocitylin{1:2:end});
     end
    approach_speed_temp = [];
    flex_during_temp =[];
    flex_after_temp = [];
    dal_velocity_after_temp = [];
    curve_temp = [];
    orientation_temp = [];
    length_temp = [];
    dal_approach_speed_temp = [];
    other_velocity_after_temp = [];
    other_orientation_temp = [];
    for i = 1:size(interactions,1)
            long_interactions = interactionslin{i}((interactionslin{i}.Var2 - interactionslin{i}.Var1)> 0,:);
         long_long_interactions = long_dist_interactionslin{i}((long_dist_interactionslin{i}.Var2 - long_dist_interactionslin{i}.Var1)>0,:);
        
        
           long_before_interactions = before_interactionslin{i}((before_interactionslin{i}.Var2 - before_interactionslin{i}.Var1)>0,:);
        for j = 1:size(long_long_interactions)
            starts = long_long_interactions.Var1(j,1);
            endings = long_long_interactions.Var2(j,1);
            all_interaction_velocities = vertcat(all_interaction_velocities, velocitylin{2*i-1}(starts:endings,:));
            length_temp(end+1) = endings-starts;
            if (endings-starts) > max_length
                max_length = endings - starts;
            end
            approach_speed_temp(end+1) = mean(velocitylin{2*i-1}.other_velocities(max(starts-10,1):starts,1),'omitnan');
            flex_during_temp(end+1) = mean(flex{i}.angles(max(starts-60,1):min(endings,size(flex{i})),1),'omitnan');
            flex_after_temp(end+1) = mean(flex{i}.angles(endings:min(endings+90,size(flex{i})),1),"omitnan");
            dal_velocity_after_temp(end+1) = mean(velocitylin{2*i-1}.dalotia_velocities(endings:min(endings+10,size(velocitylin{2*i-1})),1),"omitnan");
            curve_temp(end+1)= mean(curvature{i}.other_curvatures(max(starts-90,1):starts,1),'omitnan');
            orientations = distances{i}.midDist - distances{i}.headDist;
            orientation_temp(end+1) = mean(orientations(max(starts-60,1):starts,1),'omitnan');
            dal_approach_speed_temp(end+1) = mean(velocitylin{2*i-1}.dalotia_velocities(max(starts-10,1):starts,1),'omitnan');
            other_velocity_after_temp(end+1) = mean(velocitylin{2*i-1}.other_velocities(endings:min(endings+10,size(velocitylin{2*i-1})),1),"omitnan");
            other_orientations = distances{i}.midDist - distances{i}.midHead;
            other_orientation_temp(end+1) = mean(other_orientations(max(starts-10,1):starts,1),'omitnan');
        end
        
    end
    individual_stats{k,1} = {organism, approach_speed_temp,flex_during_temp,flex_after_temp,dal_velocity_after_temp,curve_temp,orientation_temp,length_temp, dal_approach_speed_temp,other_velocity_after_temp,other_orientation_temp}; 
    approach_speed = [approach_speed,approach_speed_temp];
    flex_during =[flex_during,flex_during_temp];
    flex_after = [flex_after,flex_after_temp];
    dal_velocity_after = [dal_velocity_after,dal_velocity_after_temp];
    curve = [curve,curve_temp];
    orientation = [orientation,orientation_temp];
    orientation(abs(orientation) > 40) = nan;
    length = [length,length_temp];
    dal_approach_speed = [dal_approach_speed,dal_approach_speed_temp];
    other_velocity_after = [other_velocity_after, other_velocity_after_temp];
    other_orientation = [other_orientation, other_orientation_temp];
    %1. Organism
    %2. Approach_speed (-10 frames)
    %3. Flex_during (-60 frames)
    %4. Flex_after (90 frames after)
    %5. Dal_velocity_after (10 frames)
    %6. Curvature (-90 frames)
    %7. Orientation (-10 frames)
    %8. Length of Interaction
    %9. Dal_approach_speed (-10 frames)
    %10. Other_velocity_after (10 frames)
    %11. Other_orientation (-10 frames)
end
