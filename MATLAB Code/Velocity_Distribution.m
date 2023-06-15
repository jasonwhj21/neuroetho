path = '/Users/jasonwong/Projects/Beetle_Learning_MATLAB/Organism_CSVs';
folders = dir([path,'/','Dal_*']);


organism = folders(1).name;
load([path,'/',organism,'/',organism,'statistics']);
load([path,'/',organism,'/',organism,'statisticslin']);

 all_interaction_velocities = [];

for i = 1:size(interactions,1)
    long_interactions = interactionslin{i}((interactionslin{i}.Var2 - interactionslin{i}.Var1)> 0,:);
    long_long_interactions = long_dist_interactionslin{i}((long_dist_interactionslin{i}.Var2 - long_dist_interactionslin{i}.Var1)>0,:);
        
        
    long_before_interactions = before_interactionslin{i}((before_interactionslin{i}.Var2 - before_interactionslin{i}.Var1)>0,:);
        for j = 1:size(long_long_interactions)
            starts = long_long_interactions.Var1(j,1);
            endings = long_long_interactions.Var2(j,1);
            all_interaction_velocities = vertcat(all_interaction_velocities, velocitylin{2*i-1}(starts:endings,:));
        end
end

histogram(all_interaction_velocities.dalotia_velocities)