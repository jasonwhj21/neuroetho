%We divide approach speed and orientation into 10 equal subdivisions each. 
%At each combination of approach speed and orientation, how likely is a
%beetle to flex vs flee?

flex_interactions = ((flex_during < 1.75  | min_flex<1.75) & dal_velocity_after <= 20000);
flee_interactions = (dal_velocity_after > 20000 & (flex_during >= 1.75 & flex_after >= 1.75 & min_flex >= 1.75));
both_interactions = ((flex_during < 1.75  | min_flex < 1.75) & dal_velocity_after>20000);
neither_interactions = ~(flex_interactions | flee_interactions | both_interactions);


approach_divs = linspace(0,40000,30);
orientation_divs = linspace(-30,30,30);

labels = ['Flex', 'Flee', 'Both', 'Neither'];
% labels = [1:4];

for i = 1:29
    app(i,:) = approach_speed > approach_divs(i) & approach_speed <= approach_divs(i+1);
    ori(i,:) = orientation > orientation_divs(i) & orientation <= orientation_divs(i+1);
    total_danger_response_app(i) = sum(flex_interactions & app(i,:)) + sum(flee_interactions & app(i,:)) + sum(both_interactions & app(i,:));
    total_app(i) = sum(app(i,:));
    total_pos = sum(app(i,:) & orientation > 0);
    total_neg = sum(app(i,:) & orientation <= 0);
    flex_percentage_app(i) = sum(app(i,:) & (flex_interactions | both_interactions))/total_danger_response_app(i);
    flee_percentage_app(i) = sum(app(i,:)  &  (flee_interactions | both_interactions))/total_danger_response_app(i);
    both_percentage_app(i) = sum(app(i,:) & both_interactions)/total_danger_response_app(i);
    neither_percentage_app(i) = sum(app(i,:) & neither_interactions)/total_app(i);
    danger_percentage_app(i) = sum(app(i,:)  & ~neither_interactions)/total_app(i);
    danger_percentage_app_pos(i) = sum(app(i,:)  & ~neither_interactions & orientation > 0)/total_pos;
    danger_percentage_app_neg(i) = sum(app(i,:)  & ~neither_interactions & orientation <= 0)/total_neg;
    flexes_by_app(i) = sum(app(i,:) & flex_interactions);
    flees_by_app(i) = sum(app(i,:) & flee_interactions);
    boths_by_app(i) = sum(app(i,:) & both_interactions);
    neithers_by_app(i) = sum(app(i,:) & neither_interactions);


    total_danger_response_ori(i) = sum(flex_interactions & ori(i,:)) + sum(flee_interactions & ori(i,:)) + sum(both_interactions & ori(i,:));
    total_ori(i) = sum(ori(i,:));
    flex_percentage_ori(i) = sum(ori(i,:) & (flex_interactions | both_interactions ))/total_danger_response_ori(i);
    flee_percentage_ori(i) = sum(ori(i,:) & (flee_interactions | both_interactions))/total_danger_response_ori(i);
    both_percentage_ori(i) = sum(ori(i,:) & both_interactions)/total_danger_response_ori(i);
    neither_percentage_ori(i) = sum(ori(i,:) & neither_interactions)/total_ori(i);
    danger_percentage_ori(i) = sum(ori(i,:) & ~neither_interactions)/total_ori(i);
    flexes_by_ori(i) = sum(ori(i,:) & flex_interactions);
    flees_by_ori(i) = sum(ori(i,:) & flee_interactions);
    boths_by_ori(i) = sum(ori(i,:) & both_interactions);
    neithers_by_ori(i) = sum(ori(i,:) & neither_interactions);
    
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
fig = figure('units','inch','position',[0,0,15,10]);
% danger_percentage_app_pos(isnan(danger_percentage_app_pos)) = 0;
% danger_percentage_app_neg(isnan(danger_percentage_app_neg)) = 0;
% subplot(1,2,1)
% scatter(approach_divs(1:29),danger_percentage_app_pos, 50,'MarkerEdgeColor', 'red', 'MarkerFaceColor','red')
% coeffs = polyfit(approach_divs(1:29), danger_percentage_app_pos,1);
% fit = polyval(coeffs,[approach_divs(1),approach_divs(29)]);
% grid on
% hold on
% plot([approach_divs(1),approach_divs(29)], fit, 'LineWidth' ,2,'Color','black')
% title('Positive Orientation')
% xlabel('Ant Approach Speed (pixels/minute)')
% ylabel('Percentage Danger Response')
% 
% subplot(1,2,2)
% scatter(approach_divs(1:29), danger_percentage_app_neg, 50,'MarkerEdgeColor', 'blue',"MarkerFaceColor",'blue')
% coeffs = polyfit(approach_divs(1:29), danger_percentage_app_neg,1);
% fit = polyval(coeffs,[approach_divs(1),approach_divs(29)])
% grid on
% hold on
% plot([approach_divs(1),approach_divs(29)], fit, 'LineWidth' ,2,'Color','black')
% title('Negative Orientation')
% xlabel('Ant Approach Speed (pixels/minute)')
% ylabel('Percentage Danger Response')
% 
% 
% titles = "Proportion of Danger Responses by Ant Approach Speed (dist < 45), Divided by Orientation (Ants)"
% sgtitle(titles,'FontSize',20)


scatter(approach_divs(1:29),danger_percentage_app,50,'filled')


[coeffs,S] = polyfit(approach_divs(1:29), danger_percentage_app,1);
fit = polyval(coeffs,approach_divs(1:29));
SStot = sum((danger_percentage_app-mean(danger_percentage_app)).^2);                   
SSres = sum((danger_percentage_app-fit).^2);                    
Rsq = 1-SSres/SStot; 

hold on
plot(approach_divs(1:29), fit, 'LineWidth' ,2,'Color','black')
L = legend('',['R^2: ' , num2str(Rsq)], 'Location','northwest', 'FontSize', 15);
L.AutoUpdate = 'off';
hold off

[phat, pci] = binofit(total_danger_response_app, total_app,0.05)
CI_max = pci(:,2) - danger_percentage_app';
CI_min =  danger_percentage_app' - pci(:,1);


hold on
errorbar(approach_divs(1:29),danger_percentage_app,CI_min,CI_max,'LineStyle','none')
hold off

titles = "Proportion of Responses that are Danger Responses by Approach Speed (50 < dist < 125) (Ants)"
title(titles,newline,'FontSize',20)


 %pretty figure settings
    offsetAxes(gca);
    set(gca, ...
        'LineWidth', 2,...
        'XColor', 'k',...
        'YColor', 'k',...
        'FontName', 'Arial',...
        'FontSize', 16,...
        'Box', 'off');
    xlabel('Flex Percentage', 'FontSize', 14);
    ylabel('Orientation', 'FontSize', 14);
    whitebg('white')

% saveas(gcf,'/Users/jasonwong/Projects/neuroetho/Ant Graphs/'+ titles + '.png')