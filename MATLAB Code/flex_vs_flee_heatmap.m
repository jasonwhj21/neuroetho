%We divide approach speed and orientation into 10 equal subdivisions each. 
%At each combination of approach speed and orientation, how likely is a
%beetle to flex vs flee?

flex_interactions = ((flex_during < 1.75 | flex_after < 1.75 | min_flex<1.75) & dal_velocity_after <= 20000);
flee_interactions = (dal_velocity_after > 20000 & (flex_during >= 1.75 & flex_after >= 1.75 & min_flex >= 1.75));
both_interactions = ((flex_during < 1.75 | flex_after < 1.75 | min_flex < 1.75) & dal_velocity_after>20000);
neither_interactions = ~(flex_interactions | flee_interactions | both_interactions);


approach_divs = linspace(0,40000,30);
orientation_divs = linspace(-30,30,30);

labels = ['Flex', 'Flee', 'Both', 'Neither'];
% labels = [1:4];

for i = 1:29
    app(i,:) = approach_speed > approach_divs(i) & approach_speed <= approach_divs(i+1);
    ori(i,:) = orientation > orientation_divs(i) & orientation <= orientation_divs(i+1);
    total_danger_response_app = sum(flex_interactions & app(i,:)) + sum(flee_interactions & app(i,:)) + sum(both_interactions & app(i,:));
    total_app = sum(app(i,:));
    flex_percentage_app(i) = sum(app(i,:) & (flex_interactions | both_interactions))/total_danger_response_app;
    flee_percentage_app(i) = sum(app(i,:)  &  (flee_interactions | both_interactions))/total_danger_response_app;
    both_percentage_app(i) = sum(app(i,:) & both_interactions)/total_danger_response_app;
    neither_percentage_app(i) = sum(app(i,:) & neither_interactions)/total_app;
    danger_percentage_app(i) = sum(app(i,:)  & ~neither_interactions)/total_app;
    flexes_by_app(i) = sum(app(i,:) & flex_interactions);
    flees_by_app(i) = sum(app(i,:) & flee_interactions);
    boths_by_app(i) = sum(app(i,:) & both_interactions);
    neithers_by_app(i) = sum(app(i,:) & neither_interactions);
    dangers_by_app(i) = sum(app(i,:) & ~neither_interactions);

    total_danger_response_ori = sum(flex_interactions & ori(i,:)) + sum(flee_interactions & ori(i,:)) + sum(both_interactions & ori(i,:));
    total_ori = sum(ori(i,:));
    flex_percentage_ori(i) = sum(ori(i,:) & (flex_interactions | both_interactions ))/total_danger_response_ori;
    flee_percentage_ori(i) = sum(ori(i,:) & (flee_interactions | both_interactions))/total_danger_response_ori;
    both_percentage_ori(i) = sum(ori(i,:) & both_interactions)/total_danger_response_ori;
    neither_percentage_ori(i) = sum(ori(i,:) & neither_interactions)/total_ori;
    danger_percentage_ori(i) = sum(ori(i,:) & ~neither_interactions)/total_ori;
    flexes_by_ori(i) = sum(ori(i,:) & flex_interactions);
    flees_by_ori(i) = sum(ori(i,:) & flee_interactions);
    boths_by_ori(i) = sum(ori(i,:) & both_interactions);
    neithers_by_ori(i) = sum(ori(i,:) & neither_interactions);
    dangers_by_ori(i) = sum(ori(i,:) & ~neither_interactions);
end
all_by_app = [flex_percentage_app; flee_percentage_app; both_percentage_app; neither_percentage_app];
% for j = 1:19
%     for k = 1:2
%         all  = sum(app(j,:) & ori(k,:));
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
set(0,'defaultAxesFontSize',15)
fig = figure('units','inch','position',[0,0,20,10]);
subplot(1,2,1)
plot(approach_divs(1:29),flex_percentage_app, '-k+','MarkerSize', 8,'MarkerEdgeColor', 'red', 'MarkerFaceColor','red','LineWidth',3)
title('Flex')
xlabel('Ant Approach Speed (pixels/minute)')
ylabel('Percentage Flex Response')

subplot(1,2,2)
plot(approach_divs(1:29), flee_percentage_app, '-k+','MarkerSize', 8,'MarkerEdgeColor', 'blue',"MarkerFaceColor",'blue','LineWidth',3)
title('Flee')
xlabel('Ant Approach Speed (pixels/minute)')
ylabel('Percentage Flee Response')

% 
titles = "Proportion of Flex and Flee Responses by Ant Approach Speed (Ants)"
sgtitle(titles,'FontSize',20)
% 
% plot(approach_divs(1:29),danger_percentage_app)
% titles = "Proportion of Responses that are Danger Responses by Approach Speed (Ants)"
% title(titles)
% ylabel('Percentage Danger Responses')
% xlabel('Ant Approach Speed (pixels/minute)')
saveas(gcf,'/Users/jasonwong/Projects/neuroetho/Ant Graphs/'+ titles + '.png')