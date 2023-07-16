ant = ('Ant_long_long_interactions');
other = ('Other_long_long_interactions')
%pretty figure settings
 

flex_interactions = ((flex_during < 1.75  | min_flex<1.75) & dal_velocity_after <= 20000);
flee_interactions = (dal_velocity_after > 20000 & (flex_during >= 1.75 & flex_after >= 1.75 & min_flex >= 1.75));
both_interactions = ((flex_during < 1.75  | min_flex < 1.75) & dal_velocity_after>20000);
neither_interactions = ~(flex_interactions | flee_interactions | both_interactions);


approach_divs = linspace(0,40000,30);
orientation_divs = linspace(-30,30,30);

labels = ['Flex', 'Flee', 'Both', 'Neither'];
% labels = [1:4];

for i = 1:29
%     app(i,:) = approach_speed > approach_divs(i) & approach_speed <= approach_divs(i+1);
     ori(i,:) = orientation > orientation_divs(i) & orientation <= orientation_divs(i+1);
%     total_danger_response_app(i) = sum(flex_interactions & app(i,:)) + sum(flee_interactions & app(i,:)) + sum(both_interactions & app(i,:));
%     total_app(i) = sum(app(i,:));
%     total_pos(i) = sum(app(i,:) & orientation > 0);
%     total_neg(i) = sum(app(i,:) & orientation <= 0);
%     flex_percentage_app(i) = sum(app(i,:) & (flex_interactions | both_interactions))/total_danger_response_app(i);
%     flee_percentage_app(i) = sum(app(i,:)  &  (flee_interactions | both_interactions))/total_danger_response_app(i);
%     both_percentage_app(i) = sum(app(i,:) & both_interactions)/total_danger_response_app(i);
%     neither_percentage_app(i) = sum(app(i,:) & neither_interactions)/total_app(i);
%     danger_percentage_app(i) = sum(app(i,:)  & ~neither_interactions)/total_app(i);
%     danger_percentage_app_pos(i) = sum(app(i,:)  & ~neither_interactions & orientation > 0)/total_pos(i);
%     danger_percentage_app_neg(i) = sum(app(i,:)  & ~neither_interactions & orientation <= 0)/total_neg(i);
%     flexes_by_app(i) = sum(app(i,:) & flex_interactions);
%     flees_by_app(i) = sum(app(i,:) & flee_interactions);
%     boths_by_app(i) = sum(app(i,:) & both_interactions);
%     neithers_by_app(i) = sum(app(i,:) & neither_interactions);


    total_danger_response_ori(i) = sum(flex_interactions & ori(i,:)) + sum(flee_interactions & ori(i,:)) + sum(both_interactions & ori(i,:));
    total_ori(i) = sum(ori(i,:));
    flex_percentage_ori(i) = sum(ori(i,:) & (flex_interactions))/total_danger_response_ori(i);
    flee_percentage_ori(i) = sum(ori(i,:) & (flee_interactions))/total_danger_response_ori(i);
    both_percentage_ori(i) = sum(ori(i,:) & both_interactions)/total_danger_response_ori(i);
    neither_percentage_ori(i) = sum(ori(i,:) & neither_interactions)/total_ori(i);
    danger_percentage_ori(i) = sum(ori(i,:) & ~neither_interactions)/total_ori(i);
    flexes_by_ori(i) = sum(ori(i,:) & flex_interactions);
    flees_by_ori(i) = sum(ori(i,:) & flee_interactions);
    boths_by_ori(i) = sum(ori(i,:) & both_interactions);
    neithers_by_ori(i) = sum(ori(i,:) & neither_interactions);
    
end
% all_by_app = [flex_percentage_app; flee_percentage_app; both_percentage_app; neither_percentage_app];

fig = figure('units','inch','position',[0,0,20,10]);

subplot(1,2,1)
% danger_percentage_app_pos([18,26]) = NaN
scatter(orientation_divs(1:29),flex_percentage_ori, 60,'MarkerEdgeColor', 'magenta', 'MarkerFaceColor','magenta')
coeffs = polyfit(orientation_divs(1:29),flex_percentage_ori,1);
fit = polyval(coeffs,orientation_divs(1:29));
SStot = sum((flex_percentage_ori-mean(flex_percentage_ori)).^2);                   
SSres = sum((flex_percentage_ori-fit).^2);                    
Rsq = 1-SSres/SStot; 
L = legend(['R^2: ' , num2str(Rsq)], 'Location','northwest', 'FontSize', 15);
L.AutoUpdate = 'off';

grid on
hold on
plot(orientation_divs(1:29), fit, 'LineWidth' ,2,'Color','black')
title('Flex Percentage')


   offsetAxes(gca);
    set(gca, ...
        'LineWidth', 2,...
        'XColor', 'k',...
        'YColor', 'k',...
        'FontName', 'Arial',...
        'FontSize', 16,...
        'Box', 'off');
    xlabel('Orientation', 'FontSize', 14);
    ylabel('Propotion Flex Response', 'FontSize', 14);
    whitebg('white')
    
subplot(1,2,2)
scatter(orientation_divs(1:29),flee_percentage_ori, 60,'MarkerEdgeColor', [0 0.4470 0.7410], 'MarkerFaceColor',[0 0.4470 0.7410])
coeffs = polyfit(orientation_divs(1:29),flee_percentage_ori,1);
fit = polyval(coeffs,orientation_divs(1:29));
SStot = sum((flee_percentage_ori-mean(flee_percentage_ori)).^2);                   
SSres = sum((flee_percentage_ori-fit).^2);                    
Rsq = 1-SSres/SStot; 
L = legend(['R^2: ' , num2str(Rsq)], 'Location','northwest', 'FontSize', 15);
L.AutoUpdate = 'off';

grid on
hold on
plot(orientation_divs(1:29), fit, 'LineWidth' ,2,'Color','black')
title('Flee Percentage')


   offsetAxes(gca);
    set(gca, ...
        'LineWidth', 2,...
        'XColor', 'k',...
        'YColor', 'k',...
        'FontName', 'Arial',...
        'FontSize', 16,...
        'Box', 'off');
    xlabel('Orientation', 'FontSize', 14);
    ylabel('Percentage Flee Response', 'FontSize', 14);
    whitebg('white')
    

titles = "Proportion of Flex and Flee Responses by Orientation (Ants)"
sgtitle(titles,'FontSize',20)

saveas(gcf,'/Users/jasonwong/Projects/neuroetho/Ant Graphs/'+ titles + '.png')