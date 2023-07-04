names = categorical({'Acromyrmex','Liometopum','Liometopum (orco)','Formica','Large Liometompum', 'Small Liometopum','Solenopsis', ...
    'Bean Beetle', 'DMel', 'Fungus Gnat', 'Isopod', 'MealyBugDestroyer','Pirate Bug'});
names = reordercats(names,{'Acromyrmex','Solenopsis','Formica','Liometopum','Large Liometompum', 'Liometopum (orco)','Small Liometopum', ...
    'Bean Beetle', 'DMel', 'Fungus Gnat', 'Isopod', 'MealyBugDestroyer','Pirate Bug'});
fig = figure('units','inch','position',[0,0,20,10]);
ant_folder_nums = [1,2,3,6,9,12,13];
for j = 1:size(ant_folder_nums,2)
    org = ant_folder_nums(j);
    facing = (individual_stats{org}{13}>3);
    
    how_long_facing = mean(individual_stats{org}{9}(facing),"omitnan");
    how_long_not_facing = mean(individual_stats{org}{9}(~facing),"omitnan");
    all(j,:) = [how_long_facing, how_long_not_facing];
    SEM= [std(individual_stats{org}{9}(facing),"omitnan")/sqrt(size(individual_stats{org}{9}(facing),2)),
    std(individual_stats{org}{9}(~facing),"omitnan")/sqrt(size(individual_stats{org}{9}(~facing),2))];
    SEM_all(j,:) = SEM;
end

for i = 1:size(other_folder_nums,2)
    org = other_folder_nums(i);
    facing = (individual_stats{org}{13} > 3);
   
    how_long_facing = mean(individual_stats{org}{9}(facing),"omitnan");
    how_long_not_facing = mean(individual_stats{org}{9}(~facing),"omitnan");
    all(7+i,:) = [how_long_facing, how_long_not_facing];
    SEM= [std(individual_stats{org}{9}(facing),"omitnan")/sqrt(size(individual_stats{org}{9}(facing),2)),
    std(individual_stats{org}{9}(~facing),"omitnan")/sqrt(size(individual_stats{org}{9}(~facing),2))];
    SEM_all(7+i,:) = SEM;
end

b = bar(names,all)
L = legend('Orientation > 0 (facing)', 'Orientation < 0 (non-Facing)')
L.AutoUpdate = 'off';
titles = "Average Interaction Length at Distance <125 For Each Orientations";
title(titles)



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
    
    ylabel('Average Interaction Duration', 'FontSize', 14);
    whitebg('white')

saveas(gcf,'/Users/jasonwong/Projects/neuroetho/Ant Graphs/'+ titles + '.png')