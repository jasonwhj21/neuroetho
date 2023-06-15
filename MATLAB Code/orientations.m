%% inputs: rawDatafiltInteractionType
% a column cell array with the same number of rows as number of experiments,
% where each cell is a table containing 2 columns. The first column is 
% the time of each frame, the second column is the type of interaction (0
% if there's no interaction during that frame

% ex: otherOrg = 'Dmel';

%% outputs:rawDatafilt
%% Explanation
% Based on their relative velocities at the moment of contact, sorts the
% interaction into 5 categories. 
% Mutual approach: both orgs moved towards each other
% Dal chase: Dal chased and other ran away
% Other chase: Other chased and dal ran away
% Dal approach: Dal chased but other didn't run away
% Other appraoch: Other chased but dal didn't run away
% The velocity at time of contact is based on the average velocity of the 5
% previous frames to ensure that slight jitters don't throw off the
% categorization. Additionally, if a bout stops for 5 frames or less and continues
% after, it's counted as one continuous bout
%% Problem
% Might just stick with 3 types of interactions, since the most
% important thing is to determine who was the "aggressor" in each
% interaction, and simplifying things is almost always good.
% The classification itself still needs a little tweaking

function rawDatafiltInteractionType = orientations(rawDatafilt, rawDatafiltCollisions)
%% Function Start

expnum = size(rawDatafilt, 1);


rawDatafiltInteractionType = cell(expnum, 1);   % cell array to return
% frame to min conversion: eg, (1 sec/60 frames)*(1 min/60 sec)=time in min
fps = 60;
frame2time = (1/fps) * (1/60); %
for i = 1:expnum
    data = rawDatafilt{i, 1};
    col_index = ceil(i/2);
    collisions = rawDatafiltCollisions{col_index,1}.final_collisions;
    rows = size(data, 1);
    frame_nums = [1:rows]';
    time_col = frame_nums * frame2time;     % time column
   
    interaction_type = zeros(rows,1);
    
    dal_positions_x = data.DalotiaAbdomen1_x;
    dal_positions_y = data.DalotiaAbdomen1_y;
    other_positions_x = data.AntThorax_x;
    other_positions_y = data.AntThorax_y;
    interaction_starts = [];
    interaction_ends = [];
    for j = 1:rows
        if collisions(j) == 1 && any(collisions(j-min(j,5):j-1)) == false 
            interaction_starts(end+1) = j; %If a time point has a collision but no collision within 5 frames before, then it's the start of a bout
        end
        if collisions(j) == 1 && any(collisions(j+1:j+min(5, rows-1-j))) == false
            interaction_ends(end+1) = j; %If a time point has a collision but no collision within 5 frames after, then it's the end of a bout
        end
    end
    
   
    for x = 1:size(interaction_starts,1)
        start = interaction_starts(x);
        finish = interaction_ends(x);
        dal_pos1 = [dal_positions_x(start - 5), dal_positions_y(start-5)];
        dal_pos2 = [dal_positions_x(start), dal_positions_y(start)];
        
        other_pos1 = [other_positions_x(start - 5) other_positions_y(start - 5)];
        other_pos2 = [other_positions_x(start) other_positions_y(start)];
        
        dal_disp = dal_pos2 - dal_pos1; 
        other_disp = other_pos2 - other_pos1;
    
        time_elapsed = time_col(j, 1) - time_col(j - 5, 1);
        
        dal_velocity = dal_disp ./ time_elapsed; %Unlike with velocities2, velocity is 2D vector
        other_velocity = other_disp ./ time_elapsed;

        dal_speed = vecnorm(dal_velocity);
        other_speed = vecnorm(other_velocity);

        norm_dot_product = dot(dal_velocity./dal_speed, other_velocity./other_speed); %Take the normalized dot product between the velocities
        
        if norm_dot_product < 0 
            interaction_type(start:finish,1) = 1;
        elseif norm_dot_product > 0 && other_speed > dal_speed
            interaction_type(start:finish,1) = 2;
        elseif norm_dot_product > 0 && dal_speed > other_speed   
            interaction_type(start:finish,1) = 3;
        end
   
    end
    
    rawDatafiltInteractionType{i,1} = table(time_col,interaction_type);
end