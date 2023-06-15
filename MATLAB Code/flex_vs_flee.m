flex_interactions = ((flex_during < 1.75 | flex_after < 1.75) & dal_velocity_after <= 20000);
flee_interactions = (dal_velocity_after > 20000 & (flex_during >= 1.75 & flex_after >= 1.75));
both_interactions = ((flex_during < 1.75 | flex_after < 1.75) & dal_velocity_after>20000);
neither_interactions = ~(flex_interactions | flee_interactions | both_interactions);
% facing = isnan(orientation) | ~isnan(orientation);
% facing = (orientation < 0);

set(0,'defaultAxesFontSize',15)
types = categorical({'Flex','Flee','Both','Neither', 'All'});
types = reordercats(types, {'Flex','Flee','Both','Neither', 'All'});
cat_orientation = [mean(orientation(flex_interactions ),"omitnan"),mean(orientation(flee_interactions ),"omitnan"),mean(orientation(both_interactions ),"omitnan"),mean(orientation(neither_interactions ),"omitnan"),mean(orientation(facing), "omitnan")];

% cat_orientation = [cat_orientation_other;cat_orientation_ants]';
fig = figure('units','inch','position',[0,0,10,10]);
b = bar(types,cat_orientation)
titles = "Average Orientation By Type of Bout (Other)"
title(titles)

SEM_other= [std(orientation(flex_interactions ),"omitnan")/sqrt(size(orientation(flex_interactions ),2)),
    std(orientation(flee_interactions ),"omitnan")/sqrt(size(orientation(flee_interactions ),2)),
    std(orientation(both_interactions ),"omitnan")/sqrt(size(orientation(both_interactions ),2)),
    std(orientation(neither_interactions ),"omitnan")/sqrt(size(orientation(neither_interactions ),2)),
    std(orientation,"omitnan")/sqrt(size(orientation(facing),2))];

[nbars,ngroups] = size(cat_orientation);
% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
hold on
model_error = SEM_other;
% Plot the errorbars
errorbar(x',cat_orientation,model_error,'k','linestyle','none');
hold off
saveas(gcf,'./Ant Graphs/'+ titles + '.png')