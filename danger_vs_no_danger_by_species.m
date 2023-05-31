danger_interactions = ((flex_during < 1.75 | flex_after < 1.75) | dal_velocity_after > 20000);
names = categorical({'Acromyrmex','Ant','Ant (orco)','Formica','Large Liometompum', 'Small Liometopum','Solenopsis', ...
    'Bean Beetle', 'DMel', 'Fungus Gnat', 'Isopod', 'Mealworm','Pirate Bug'});
names = reordercats(names,{'Acromyrmex','Ant','Ant (orco)','Formica','Large Liometompum', 'Small Liometopum','Solenopsis', ...
    'Bean Beetle', 'DMel', 'Fungus Gnat', 'Isopod', 'Mealworm','Pirate Bug'});

all = zeros(13,2);
SEM_all = zeros(13,2);
for j = 1:size(ant_folder_nums,2)
    org = ant_folder_nums(j);
    flex_interactions = ((individual_stats{org}{3} < 1.75 | individual_stats{org}{4} < 1.75) & individual_stats{org}{5} <= 20000);
    flee_interactions = (individual_stats{org}{5} > 20000 & (individual_stats{org}{3} >= 1.75 & individual_stats{org}{4} >= 1.75));
    both_interactions = (individual_stats{org}{5} > 20000 & (individual_stats{org}{3} < 1.75 | individual_stats{org}{4} < 1.75));
    percent_flex = sum(flex_interactions)/(sum(flee_interactions)+sum(flex_interactions)+sum(both_interactions));
    percent_flee = sum(flee_interactions)/(sum(flee_interactions)+sum(flex_interactions)+sum(both_interactions));
    all(j,:) = [percent_flex,percent_flee];
%     SEM = [std(individual_stats{org}{2}(danger_interactions),"omitnan")/sqrt(size(individual_stats{org}{2}(danger_interactions),2)),
%     std(individual_stats{org}{2}(~danger_interactions),"omitnan")/sqrt(size(individual_stats{org}{2}(~danger_interactions),2))];
%     SEM_all(j,:) = SEM;

end

for i = 1:size(other_folder_nums,2)
    org = other_folder_nums(i);
    flex_interactions = ((individual_stats{org}{3} < 1.75 | individual_stats{org}{4} < 1.75) & individual_stats{org}{5} <= 20000);
    flee_interactions = (individual_stats{org}{5} > 20000 & (individual_stats{org}{3} >= 1.75 & individual_stats{org}{4} >= 1.75));
    both_interactions = (individual_stats{org}{5} > 20000 & (individual_stats{org}{3} < 1.75 | individual_stats{org}{4} < 1.75));
    percent_flex = sum(flex_interactions)/(sum(flee_interactions)+sum(flex_interactions)+sum(both_interactions));
    percent_flee = sum(flee_interactions)/(sum(flee_interactions)+sum(flex_interactions)+sum(both_interactions));
    all(i+7,:) = [percent_flex, percent_flee];
%     SEM = [std(individual_stats{org}{2}(danger_interactions),"omitnan")/sqrt(size(individual_stats{org}{2}(danger_interactions),2)),
%     std(individual_stats{org}{2}(~danger_interactions),"omitnan")/sqrt(size(individual_stats{org}{2}(~danger_interactions),2))];
%     SEM_all(i+7,:) = SEM;
end

b = bar(names,all)
title('Percentage of Each Danger Responses by Species')
ylabel('Percent of All Danger Responses')
% 
% [ngroups,nbars] = size(all);
% % Get the x coordinate of the bars
% x = nan(nbars, ngroups);
% for i = 1:nbars
%     x(i,:) = b(i).XEndPoints;
% end
% hold on
% % Plot the errorbars
% errorbar(x',all,SEM,'k','linestyle','none');
% hold off

legend('Percent Flex','Percent Flee')