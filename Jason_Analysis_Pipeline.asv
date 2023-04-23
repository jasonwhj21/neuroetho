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
length = [];
max_length = 0;
for k = 1:size(folder_nums,2)
    organism = folders(folder_nums(k)).name;
    load([path,'/',organism,'/',organism,'statistics']);
    load([path,'/',organism,'/',organism,'statisticslin']);
    load([path,'/',organism,'/',organism,'long_dist_interactions']);
    load([path,'/',organism,'/',organism,'before_interactions']);
     if k ==1
        all_flex = vertcat(flex{:});
        all_dist = vertcat(distanceslin{:});
     else
        all_flex = vertcat(all_flex, flex{:});
        all_dist = vertcat(all_dist,distanceslin{:});
     end
    approach_speed_temp = [];
    flex_during_temp =[];
    flex_after_temp = [];
    dal_velocity_after_temp = [];
    curve_temp = [];
    orientation_temp = [];
    length_temp = [];
    for i = 1:size(interactions,1)
%            long_interactions = interactionslin{i}((interactionslin{i}.Var2 - interactionslin{i}.Var1)>10,:);
%         long_long_interactions = long_dist_interactions{i}((long_dist_interactions{i}.Var2 - long_dist_interactions{i}.Var1)>20,:);
        
        
          long_before_interactions = before_interactions{i}((before_interactions{i}.Var2 - before_interactions{i}.Var1)>0,:);
        for j = 1:size(long_before_interactions)
            starts = long_before_interactions.Var1(j,1);
            endings = long_before_interactions.Var2(j,1);
            length_temp(end+1) = endings-starts;
            if (endings-starts) > max_length
                max_length = endings - starts;
            end
            approach_speed_temp(end+1) = mean(velocitylin{2*i-1}.other_velocities(max(starts-20,1):starts,1),'omitnan');
            flex_during_temp(end+1) = mean(flex{i}.angles(max(starts-60,1):min(endings,size(flex{i})),1),'omitnan');
            flex_after_temp(end+1) = mean(flex{i}.angles(endings:min(endings+90,size(flex{i})),1),"omitnan");
            dal_velocity_after_temp(end+1) = mean(velocitylin{2*i-1}.dalotia_velocities(endings:min(endings+30,size(velocitylin{2*i-1})),1),"omitnan");
            curve_temp(end+1)= mean(curvature{i}.other_curvatures(max(starts-90,1):starts,1),'omitnan');
            orientations = distances{i}.midDist - distances{i}.headDist;
            orientation_temp(end+1) = mean(orientations(max(starts-5,1):starts,1),'omitnan');
            
           
        end
        
    end
    individual_stats{k,1} = {organism, approach_speed_temp,flex_during_temp,flex_after_temp,dal_velocity_after_temp,curve_temp,orientation_temp,length_temp}; 
    approach_speed = [approach_speed,approach_speed_temp];
    flex_during =[flex_during,flex_during_temp];
    flex_after = [flex_after,flex_after_temp];
    dal_velocity_after = [dal_velocity_after,dal_velocity_after_temp];
    curve = [curve,curve_temp];
    orientation = [orientation,orientation_temp];
    length = [length,length_temp];
end
flex1 = flex_during(approach_speed<10000 & orientation >20);
flex2 = flex_during(approach_speed>10000 & approach_speed<20000 & orientation >20);
flex3 = flex_during(approach_speed>20000 & approach_speed<30000 & orientation >20);
flex4 = flex_during(approach_speed>30000 & orientation >20);
dist = vertcat(distances{:,1});
flexion = vertcat(flex{:,1});

max_flex = max(flex_during)

set(0,'defaultAxesFontSize',10)

subplot(3,4,1)
% avgSpeed = [];
% avgFlex = [];
% for org = 1:11
%     avgSpeed(org) = mean(individual_stats{org}{2},'omitnan');
%     avgFlex(org) = mean(individual_stats{org}{8}, 'omitnan');
% end
% scatter(avgSpeed,avgFlex)
% labels = {'M-L','S','L','M','S','S','L','L','M-L','S','S'};
% z = labelpoints(avgSpeed,avgFlex,labels,'N');
% title({'Average Approach Speed vs', 'Average Flex of Interaction per Species'})
% xlabel('approach speed')
% ylabel('interaction length')




for i = 1:11
    subplot(3,4,i+1)
    scatter(individual_stats{i}{2},individual_stats{i}{5})
    xlabel('Approach speed')
    ylabel('Interaction length')
    title({[labels{i},folders(i).name,' Avg length: '],mean(individual_stats{i}{8},"omitnan"),' Avg Approach Velocity: ', mean(individual_stats{i}{2},"omitnan")})
    xlim([0,10000])
    ylim([0,20000])
%     colorbar
%     ylim([0,7000]);
end


sgtitle('Bouts of Closeness Orientation > 20') 
subplot(2,2,1)
histfit(flex1./max_flex,10,'beta')
xlabel('Flex angle (radians)')
ylabel('Ocurrences')
title('Flex when Approach Speed  <10000')
subplot(2,2,2)
histfit(flex2./max_flex, 10, 'beta')
xlabel('Flex angle (radians)')
ylabel('Ocurrences')
title('Flex when Approach Speed 1-20000')
subplot(2,2,3)
histfit(flex3./max_flex, 10, 'beta')
xlabel('Flex angle (radians)')
ylabel('Ocurrences')
title('Flex when Approach Speed 2-30000 ')
subplot(2,2,4)
histfit(flex4./max_flex,10,'beta')
xlabel('Flex angle (radians)')
ylabel('Ocurrences')
title('Flex when Approach Speed  >30000')
beta1 = fitdist((flex1./max_flex)','beta');
beta2 = fitdist((flex2./max_flex)','beta');
beta3 = fitdist((flex3./max_flex)','beta');
beta4 = fitdist((flex4./max_flex)','beta');
