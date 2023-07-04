flex1 = flex_during(approach_speed<10000 & orientation >20);
flex2 = flex_during(approach_speed>10000 & approach_speed<20000 & orientation >20);
flex3 = flex_during(approach_speed>20000 & approach_speed<30000 & orientation >20);
flex4 = flex_during(approach_speed>30000 & orientation >20);
dist = vertcat(distances{:,1});
flexion = vertcat(flex{:,1});

max_flex = max(flex_during)

set(0,'defaultAxesFontSize',15)


%%


% subplot(2,2,1)
% histogram(all_vel.other_velocities)
% xlim([0,40000])
% subplot(2,2,2)
% histogram(all_interaction_velocities.other_velocities)
% xlim([0,40000])
% subplot(2,2,3)
% histogram(all_vel.dalotia_velocities)
% xlim([0,40000])
% subplot(2,2,4)
% histogram(all_interaction_velocities.dalotia_velocities)
% xlim([0,40000])
%%

% avgSpeed = [];
% avgFlex = [];
% stats2 = [];
% stats5 = [];
% labels = {'Acromyrmex','Ant','Ant (orco)','Formica','Large Liometompum', 'Small Liometopum','Solenopsis', ...
%     'Bean Beetle', 'DMel', 'Fungus Gnat', 'Isopod', 'Mealworm','Pirate Bug'};
% for org = 1:13
%     avgSpeed(org) = mean(individual_stats{org}{2},'omitnan');
%     avgFlex(org) = mean(individual_stats{org}{5}, 'omitnan');
%     two = bootstrp(1000,@(x)[mean(x) std(x)],individual_stats{org}{2});
%     five = bootstrp(1000,@(x)[mean(x) std(x)],individual_stats{org}{5});
%     stats2(org) = mean(two(:,2));
%     stats5(org) = mean(five(:,2));
% end
% 
% subplot(1,2,1)
% scatter(avgSpeed(ant_folder_nums),avgFlex(ant_folder_nums), 40, "filled", "b")
% hold on
% title('Original Data')
% xlabel('Other Approach Velocity')
% ylabel('Dal Escape Velocity')
% 
% subplot(1,2,2)
% scatter(stats2(ant_folder_nums),stats5(ant_folder_nums),40,"filled","b")
% hold on
% title('BootStrapped Data (1000)')
% xlabel('Other Approach Velocity')
% ylabel('Dal Escape Velocity')
% 
% subplot(1,2,1)
% scatter(avgSpeed(other_folder_nums),avgFlex(other_folder_nums), 40, "filled", "r")
% legend("Ant", "Non Ant")
% z = labelpoints(avgSpeed,avgFlex,labels,'N');
% 
% subplot(1,2,2)
% scatter(stats2(other_folder_nums),stats5(other_folder_nums),40,"filled","r")
% legend("Ant", "Non Ant")
% zs = labelpoints(stats2,stats5,labels,'N');
% 
% 
% sgtitle('Approach Speed vs Escape Speed at Distance (<125)')



%%
% scatter(avgSpeed(ant_folder_nums),avgFlex(ant_folder_nums))
% labels = {'M','M','L','L','M','S','S'};
% z = labelpoints(avgSpeed(ant_folder_nums),avgFlex(ant_folder_nums),labels,'N');
% title({'Average Approach Speed vs', 'Average Escape Velocity (Ants Only, Interaction Dist <125)'})
% xlabel('Approach speed  (Pixels per minute)')
% ylabel('Escape Velocity (Pixels per minute)')


% 
% for i = 1:13
%     subplot(3,5,i)
%     scatter(individual_stats{i}{2},individual_stats{i}{5})
%     xlabel('Other Approach velocity')
%     ylabel('Dal Escape Velocity')
%     title(folders(i).name)
% 
% end
% sgtitle('Other Approach Velocity vs. Dal Escape Velocity By Species ')
% all = zeros(13,2);


%%

names = categorical({'Acromyrmex','Liometopum','Liometopum (orco)','Formica','Large Liometompum', 'Small Liometopum','Solenopsis', ...
    'Bean Beetle', 'DMel', 'Fungus Gnat', 'Isopod', 'MealyBugDestroyer','Pirate Bug'});
names = reordercats(names,{'Acromyrmex','Liometopum','Liometopum (orco)','Formica','Large Liometompum', 'Small Liometopum','Solenopsis', ...
    'Bean Beetle', 'DMel', 'Fungus Gnat', 'Isopod', 'MealyBugDestroyer','Pirate Bug'});
for j = 1:size(ant_folder_nums,2)
    org = ant_folder_nums(j);
    facing = (individual_stats{org}{8}>=0);
    not_facing = (individual_stats{org}{8}<0);
    how_long_facing = mean(individual_stats{org}{9}(facing),"omitnan");
    how_long_not_facing = mean(individual_stats{org}{9}(not_facing),"omitnan");
    all(j,:) = [how_long_facing, how_long_not_facing];
    SEM= [std(individual_stats{org}{9}(facing),"omitnan")/sqrt(size(individual_stats{org}{9}(facing),2)),
    std(individual_stats{org}{9}(not_facing),"omitnan")/sqrt(size(individual_stats{org}{9}(not_facing),2))];
    SEM_all(j,:) = SEM;
end

for i = 1:size(other_folder_nums,2)
    org = other_folder_nums(i);
    facing = (individual_stats{org}{8}>=0);
    not_facing = (individual_stats{org}{8}<0);
    how_long_facing = mean(individual_stats{org}{9}(facing),"omitnan");
    how_long_not_facing = mean(individual_stats{org}{9}(not_facing),"omitnan");
    all(7+i,:) = [how_long_facing, how_long_not_facing];
    SEM= [std(individual_stats{org}{9}(facing),"omitnan")/sqrt(size(individual_stats{org}{9}(facing),2)),
    std(individual_stats{org}{9}(not_facing),"omitnan")/sqrt(size(individual_stats{org}{9}(not_facing),2))];
    SEM_all(7+i,:) = SEM;
end

b = bar(names,all)
L = legend('Orientation > 0 (facing)', 'Orientation < 0 (non-Facing)')
L.AutoUpdate = 'off';
title('Average Interaction Length at Distance <125 For Each Orientations')
ylabel('Interaction Length')


[ngroups,nbars] = size(all);
% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
hold on
% Plot the errorbars
errorbar(x',all,SEM_all,'k','linestyle','none');
hold off

    set(gca, ...
        'LineWidth', 2,...
        'XColor', 'k',...
        'YColor', 'k',...
        'FontName', 'Arial',...
        'FontSize', 16,...
        'Box', 'off');
    
    ylabel('Average Interaction Length', 'FontSize', 14);
    whitebg('white')

% subplot(4,7,28)
% for org = 1:13
%     avgSpeed = mean(individual_stats{org}{2},'omitnan');
%     avgFlex = mean(individual_stats{org}{8}, 'omitnan');
%     if any(ant_folder_nums == org)
%         scatter(avgSpeed,avgFlex, 20, "filled", "b")
%     else
%         scatter(avgSpeed,avgFlex, 20, "filled", "r")
%     end
%     hold on
% end
%%
