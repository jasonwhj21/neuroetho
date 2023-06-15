names = categorical({'Acromyrmex','Ant','Ant (orco)','Formica','Large Liometompum', 'Small Liometopum','Solenopsis', ...
    'Bean Beetle', 'DMel', 'Fungus Gnat', 'Isopod', 'Mealy Bug Destroyer','Pirate Bug'});
names = reordercats(names,{'Acromyrmex','Ant','Ant (orco)','Formica','Large Liometompum', 'Small Liometopum','Solenopsis', ...
    'Bean Beetle', 'DMel', 'Fungus Gnat', 'Isopod', 'Mealy Bug Destroyer','Pirate Bug'});
all = zeros(13,3);
SEM_all = zeros(13,3);
for j = 1:size(ant_folder_nums,2)
    org = ant_folder_nums(j);
    flex_interactions = ((individual_stats{org}{3} < 1.75 | individual_stats{org}{4} < 1.75) & individual_stats{org}{5} <= 20000);
    flee_interactions = (individual_stats{org}{5} > 20000 & (individual_stats{org}{3} >= 1.75 & individual_stats{org}{4} >= 1.75));
    neither_interactions = (individual_stats{org}{5} < 20000 & (individual_stats{org}{3} >= 1.75 & individual_stats{org}{4} >= 1.75));
    approach_flex = mean(individual_stats{org}{2}(flex_interactions));
    approach_flee = mean(individual_stats{org}{2}(flee_interactions));
    approach_neither = mean(individual_stats{org}{2}(neither_interactions));
    all(j,:) = [approach_flex, approach_flee, approach_neither];
    SEM= [std(individual_stats{org}{2}(flex_interactions),"omitnan")/sqrt(size(individual_stats{org}{2}(flex_interactions),2)),
    std(individual_stats{org}{2}(flee_interactions),"omitnan")/sqrt(size(individual_stats{org}{2}(flee_interactions),2)),
    std(individual_stats{org}{2}(neither_interactions),"omitnan")/sqrt(size(individual_stats{org}{2}(neither_interactions),2))];
    SEM_all(j,:) = SEM;

end

for i = 1:size(other_folder_nums,2)
    org = other_folder_nums(i);
    flex_interactions = ((individual_stats{org}{3} < 1.75 | individual_stats{org}{4} < 1.75) & individual_stats{org}{5} <= 20000);
    flee_interactions = (individual_stats{org}{5} > 20000 & (individual_stats{org}{3} >= 1.75 & individual_stats{org}{4} >= 1.75));
    neither_interactions = (individual_stats{org}{5} < 20000 & (individual_stats{org}{3} >= 1.75 & individual_stats{org}{4} >= 1.75));
    approach_flex = mean(individual_stats{org}{2}(flex_interactions));
    approach_flee = mean(individual_stats{org}{2}(flee_interactions));
    approach_neither = mean(individual_stats{org}{2}(neither_interactions));
    all(7+i,:) = [approach_flex, approach_flee, approach_neither];
    SEM= [std(individual_stats{org}{2}(flex_interactions),"omitnan")/sqrt(size(individual_stats{org}{2}(flex_interactions),2)),
    std(individual_stats{org}{2}(flee_interactions),"omitnan")/sqrt(size(individual_stats{org}{2}(flee_interactions),2)),
    std(individual_stats{org}{2}(neither_interactions),"omitnan")/sqrt(size(individual_stats{org}{2}(neither_interactions),2))];
    SEM_all(7+i,:) = SEM;
end

b = bar(names,all)
title('Average Approach Velocity at Distance <125 For Different types of Bouts')
ylabel('Approach Speed')

[ngroups,nbars] = size(all);
% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
hold on
% Plot the errorbars
errorbar(x',all,SEM,'k','linestyle','none');
hold off

legend('Flex', 'Flee', 'Neither')