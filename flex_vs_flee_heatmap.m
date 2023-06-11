%We divide approach speed and orientation into 10 equal subdivisions each. 
%At each combination of approach speed and orientation, how likely is a
%beetle to flex vs flee?

flex_interactions = ((flex_during < 1.75 | flex_after < 1.75) & dal_velocity_after <= 20000);
flee_interactions = (dal_velocity_after > 20000 & (flex_during >= 1.75 & flex_after >= 1.75));
both_interactions = ((flex_during < 1.75 | flex_after < 1.75) & dal_velocity_after>20000);
neither_interactions = ~(flex_interactions | flee_interactions | both_interactions);

approach_divs = linspace(0,max(approach_speed)*0.1,20);
orientation_divs = linspace(min(orientation),max(orientation),20);

labels = ['Flex', 'Flee', 'Both', 'Neither'];
% labels = [1:4];

for i = 1:19
    app(i,:) = approach_speed > approach_divs(i) & approach_speed <= approach_divs(i+1);
    ori(i,:) = orientation > orientation_divs(i) & orientation <= orientation_divs(i+1);
    total = sum(flex_interactions & app(i,:)) + sum(flee_interactions & app(i,:))+ sum(both_interactions & app(i,:))+sum(neither_interactions & app(i,:));
    flex_percentage_app(i) = sum(app(i,:) & flex_interactions)/total;
    flee_percentage_app(i) = sum(app(i,:) & flee_interactions)/total;
    both_percentage_app(i) = sum(app(i,:) & both_interactions)/total;
    neither_percentage_app(i) = sum(app(i,:) & neither_interactions)/total;
    flexes_by_app(i) = sum(app(i,:) & flex_interactions);
    flees_by_app(i) = sum(app(i,:) & flee_interactions);
    boths_by_app(i) = sum(app(i,:) & both_interactions);
    neithers_by_app(i) = sum(app(i,:) & neither_interactions);
end
all_by_app = [flex_percentage_app; flee_percentage_app; both_percentage_app; neither_percentage_app];
for j = 1:9
    for k = 1:9
        all  = sum(app(i,:) & ori(j,:));
        flexes_by_app_ori(j,k) = sum(app(j,:) & ori(k,:) & flex_interactions);
        flees_by_app_ori(j,k) = sum(app(j,:) & ori(k,:) & flee_interactions);
        bothes_by_app_ori(j,k) = sum(app(j,:) & ori(k,:) & both_interactions);
        neithers_by_app_ori(j,k) = sum(app(j,:) & ori(k,:) & neither_interactions);
        flex_percentage_app_ori(j,k) = flexes(j,k)/(flexes(j,k)+flees(j,k));
        flee_percentage_app_ori(j,k) = flees(j,k)/(flexes(j,k)+flees(j,k));
    end
end
% surf(approach_divs(1:9),orientation_divs(1:9),flee_percentage)
% colorbar
plot(approach_divs(1:19),flex_percentage_app,approach_divs(1:19),flee_percentage_app)
