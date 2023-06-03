flex_interactions = ((flex_during < 1.75 | flex_after < 1.75) & dal_velocity_after <= 20000);
flee_interactions = (dal_velocity_after > 20000 & (flex_during >= 1.75 & flex_after >= 1.75));
both_interactions = ((flex_during < 1.75 | flex_after < 1.75) & dal_velocity_after>20000);
neither_interactions = ~(flex_interactions | flee_interactions | both_interactions);
% facing = isnan(orientation) | ~isnan(orientation);
facing = (orientation < 0);

set(0,'defaultAxesFontSize',15)
types = categorical({'Flex','Flee','Both','Neither', 'All'});
types = reordercats(types, {'Flex','Flee','Both','Neither', 'All'});
cat_approach_speed = [mean(approach_speed(flex_interactions & facing),"omitnan"),mean(approach_speed(flee_interactions & facing),"omitnan"),mean(approach_speed(both_interactions & facing),"omitnan"),mean(approach_speed(neither_interactions & facing),"omitnan"),mean(approach_speed(facing), "omitnan")];

% cat_approach_speed = [cat_approach_speed_other;cat_approach_speed_ants]';
fig = figure('units','inch','position',[0,0,10,10]);
b = bar(types,cat_approach_speed)
titles = "Average approach speed By Type of Bout With Orientation < 0 (Other)"
title(titles)

SEM_other= [std(approach_speed(flex_interactions & facing),"omitnan")/sqrt(size(approach_speed(flex_interactions & facing),2)),
    std(approach_speed(flee_interactions & facing),"omitnan")/sqrt(size(approach_speed(flee_interactions & facing),2)),
    std(approach_speed(both_interactions & facing),"omitnan")/sqrt(size(approach_speed(both_interactions & facing),2)),
    std(approach_speed(neither_interactions & facing),"omitnan")/sqrt(size(approach_speed(neither_interactions & facing),2)),
    std(approach_speed,"omitnan")/sqrt(size(approach_speed(facing),2))];

[nbars,ngroups] = size(cat_approach_speed);
% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
hold on
model_error = [SEM_other];
% Plot the errorbars
errorbar(x',cat_approach_speed,model_error,'k','linestyle','none');
hold off
saveas(gcf,'./Ant Graphs/'+ titles + '.png')