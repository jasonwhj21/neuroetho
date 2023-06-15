danger_interactions = ((flex_during < 1.75 | flex_after < 1.75) | dal_velocity_after > 20000);
names = categorical({'Acromyrmex','Ant','Ant (orco)','Formica','Large Liometopum', 'Small Liometopum','Solenopsis', ...
    'Bean Beetle', 'DMel', 'Fungus Gnat', 'Isopod', 'Mealy Bug Destroyer','Pirate Bug'});
names = reordercats(names,{'Acromyrmex','Ant','Ant (orco)','Formica','Large Liometopum', 'Small Liometopum','Solenopsis', ...
    'Bean Beetle', 'DMel', 'Fungus Gnat', 'Isopod', 'Mealy Bug Destroyer','Pirate Bug'});
size_names = reordercats(names, {'Formica', 'Acromyrmex', 'Mealy Bug Destroyer','Ant','Large Liometopum','Ant (orco)', 'Isopod', 'Bean Beetle'...
    'DMel','Solenopsis','Small Liometopum','Pirate Bug','Fungus Gnat'});
size_folder_nums = [4,1,12,2,5,3,11,8,9,7,6,13,10];
size_names_ants = categorical({'Formica','Acromyrmex','Ant','Large Lio','Ant (orco)','Solenopsis','Small Liometopum'});
size_names_ants = reordercats(size_names_ants,{'Formica','Acromyrmex','Ant','Large Lio','Ant (orco)','Solenopsis','Small Liometopum'});
size_ant_nums=[4,1,2,5,3,7,6];

all = zeros(7,2);
SEM_all = zeros(7,2);
num_interactions = zeros(7,3);
for j = 1:size(size_ant_nums,2)
    org = size_ant_nums(j);
    flex_interactions = ((individual_stats{org}{3} < 1.75 | individual_stats{org}{4} < 1.75) & individual_stats{org}{5} <= 20000);
    flee_interactions = (individual_stats{org}{5} > 20000 & (individual_stats{org}{3} >= 1.75 & individual_stats{org}{4} >= 1.75));
    both_interactions = (individual_stats{org}{5} > 20000 & (individual_stats{org}{3} < 1.75 | individual_stats{org}{4} < 1.75));
    percent_flex = sum(flex_interactions)/(sum(flee_interactions)+sum(flex_interactions)+sum(both_interactions));
    percent_flee = sum(flee_interactions)/(sum(flee_interactions)+sum(flex_interactions)+sum(both_interactions));
    all(j,:) = [percent_flex,percent_flee];
    num_interactions(j,:) = [sum(flex_interactions),sum(flee_interactions), sum(both_interactions)];
%     SEM = [std(individual_stats{org}{2}(danger_interactions),"omitnan")/sqrt(size(individual_stats{org}{2}(danger_interactions),2)),
%     std(individual_stats{org}{2}(~danger_interactions),"omitnan")/sqrt(size(individual_stats{org}{2}(~danger_interactions),2))];
%     SEM_all(j,:) = SEM;

end
% 
% for i = 1:size(other_folder_nums,2)
%     org = other_folder_nums(i);
%     flex_interactions = ((individual_stats{org}{3} < 1.75 | individual_stats{org}{4} < 1.75) & individual_stats{org}{5} <= 20000);
%     flee_interactions = (individual_stats{org}{5} > 20000 & (individual_stats{org}{3} >= 1.75 & individual_stats{org}{4} >= 1.75));
%     both_interactions = (individual_stats{org}{5} > 20000 & (individual_stats{org}{3} < 1.75 | individual_stats{org}{4} < 1.75));
%     percent_flex = (sum(flex_interactions)+sum(both_interactions))/(sum(flee_interactions)+sum(flex_interactions)+sum(both_interactions));
%     percent_flee = (sum(flee_interactions)+sum(both_interactions))/(sum(flee_interactions)+sum(flex_interactions)+sum(both_interactions));
%     all(i+7,:) = [percent_flex, percent_flee];
%     num_interactions(i+7,:) = [sum(flex_interactions),sum(flee_interactions), sum(both_interactions)];
% %     SEM = [std(individual_stats{org}{2}(danger_interactions),"omitnan")/sqrt(size(individual_stats{org}{2}(danger_interactions),2)),
% %     std(individual_stats{org}{2}(~danger_interactions),"omitnan")/sqrt(size(individual_stats{org}{2}(~danger_interactions),2))];
% %     SEM_all(i+7,:) = SEM;
% end

b = bar(size_names_ants,all)
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