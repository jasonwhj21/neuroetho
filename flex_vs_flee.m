flex_interactions = ((flex_during < 1.75 | flex_after < 1.75) & dal_velocity_after <= 20000);
flee_interactions = (dal_velocity_after > 20000 & (flex_during >= 1.75 & flex_after >= 1.75));
both_interactions = ((flex_during < 1.75 | flex_after < 1.75) & dal_velocity_after>20000);
neither_interactions = ~(flex_interactions | flee_interactions | both_interactions);

set(0,'defaultAxesFontSize',15)
types = categorical({'Flex','Flee','Both','Neither', 'All'});
types = reordercats(types, {'Flex','Flee','Both','Neither', 'All'});
cat_approach_speeds_other = [mean(approach_speed(flex_interactions),"omitnan"),mean(approach_speed(flee_interactions),"omitnan"),mean(approach_speed(both_interactions),"omitnan"),mean(approach_speed(neither_interactions),"omitnan"),mean(approach_speed, "omitnan")];

cat_approach_speeds = [cat_approach_speeds_other;cat_approach_speeds_ants]';
b = bar(types,cat_approach_speeds)
title("Average approach speed By Type of Bout (Both)")
legend('Ants','Other')

SEM_other= [std(approach_speed(flex_interactions),"omitnan")/sqrt(size(approach_speed(flex_interactions),2)),
    std(approach_speed(flee_interactions),"omitnan")/sqrt(size(approach_speed(flee_interactions),2)),
    std(approach_speed(both_interactions),"omitnan")/sqrt(size(approach_speed(both_interactions),2)),
    std(approach_speed(neither_interactions),"omitnan")/sqrt(size(approach_speed(neither_interactions),2)),
    std(approach_speed,"omitnan")/sqrt(size(approach_speed,2))];

[ngroups,nbars] = size(cat_approach_speeds);
% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
hold on
model_error = [SEM_ants,SEM_other];
% Plot the errorbars
errorbar(x',cat_approach_speeds,model_error,'k','linestyle','none');
hold off