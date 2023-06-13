   flex_interactions = ((flex_during < 1.75 | flex_after < 1.75) & dal_velocity_after <= 20000);
flee_interactions = (dal_velocity_after > 20000 & (flex_during >= 1.75 & flex_after >= 1.75));
both_interactions = ((flex_during < 1.75 | flex_after < 1.75) & dal_velocity_after>20000);
neither_interactions = ~(flex_interactions | flee_interactions | both_interactions);

approach_divs = linspace(0,40000,20);
orientation_divs = linspace(min(orientation),max(orientation),20);
length_by_app = zeros(1,19);
length_by_ori = zeros(1,19);

for i = 1:19
    app(i,:) = approach_speed > approach_divs(i) & approach_speed <= approach_divs(i+1);
    ori(i,:) = orientation > orientation_divs(i) & orientation <= orientation_divs(i+1);
    length_by_app(i) = mean(length(app(i,:) & ~neither_interactions));
    length_by_ori(i) = mean(length(ori(i,:)));
    error(i) = std(length(ori(i,:)))/sqrt(size(length(ori(i,:)),2));
end
all_by_app = [flex_percentage_app; flee_percentage_app; both_percentage_app; neither_percentage_app];
% for j = 1:9
%     for k = 1:9
%         all  = sum(app(i,:) & ori(j,:));
%         flexes_by_app_ori(j,k) = sum(app(j,:) & ori(k,:) & flex_interactions);
%         flees_by_app_ori(j,k) = sum(app(j,:) & ori(k,:) & flee_interactions);
%         bothes_by_app_ori(j,k) = sum(app(j,:) & ori(k,:) & both_interactions);
%         neithers_by_app_ori(j,k) = sum(app(j,:) & ori(k,:) & neither_interactions);
%         flex_percentage_app_ori(j,k) = flexes(j,k)/(flexes(j,k)+flees(j,k));
%         flee_percentage_app_ori(j,k) = flees(j,k)/(flexes(j,k)+flees(j,k));
%     end
% end
% surf(approach_divs(1:9),orientation_divs(1:9),flee_percentage)
% colorbar
errorbar(orientation_divs(1:19),length_by_ori,error)
titles = "Length of Interactions by Orientation with Danger Response (Ants)"
title(titles)
%saveas(gcf,'./Ant Graphs/'+ titles + '.png')