flex_interactions = ((flex_during < 1.75 | flex_after < 1.75) & dal_velocity_after <= 20000);
flee_interactions = (dal_velocity_after > 20000 & (flex_during >= 1.75 & flex_after >= 1.75));
both_interactions = ((flex_during < 1.75 | flex_after < 1.75) & dal_velocity_after>20000);
neither_interactions = ~(flex_interactions | flee_interactions | both_interactions);

set(0,'defaultAxesFontSize',15)
types = categorical({'Flex','Flee','Both','Neither', 'All'});
types = reordercats(types, {'Flex','Flee','Both','Neither', 'All'});
cat_orientations_other = [mean(orientation(flex_interactions),"omitnan"),mean(orientation(flee_interactions),"omitnan"),mean(orientation(both_interactions),"omitnan"),mean(orientation(neither_interactions),"omitnan"),mean(orientation, "omitnan")];

cat_orientations = [cat_orientations_ants;cat_orientations_other]';
b = bar(types,cat_orientations)
title("Average Orientation By Type of Bout")
legend('Ants','Other')

SEM_other= [std(orientation(flex_interactions),"omitnan")/sqrt(size(orientation(flex_interactions),2)),
    std(orientation(flee_interactions),"omitnan")/sqrt(size(orientation(flee_interactions),2)),
    std(orientation(both_interactions),"omitnan")/sqrt(size(orientation(both_interactions),2)),
    std(orientation(neither_interactions),"omitnan")/sqrt(size(orientation(neither_interactions),2)),
    std(orientation,"omitnan")/sqrt(size(orientation,2))];

[ngroups,nbars] = size(cat_orientations);
% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
hold on
model_error = [SEM_ants,SEM_other];
% Plot the errorbars
errorbar(x',cat_orientations,model_error,'k','linestyle','none');
hold off