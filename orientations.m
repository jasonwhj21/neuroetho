%% inputs: rawDatafilt 
% a column cell array, where each cell is a table containing frame
% nums, and x,y coordinates of each body part and their likelihoods for both organisms

% ex: otherOrg = 'Dmel';

%% outputs:rawDatafiltOrientations

function [rawDatafiltVelocityOrientations] = orientations(rawDatafilt, rawDatafiltCollisions)
%% Function Start

expnum = size(rawDatafilt, 1);
header = rawDatafilt{1,1}.Properties.VariableNames;
dalAbdXIdx = contains(header, 'DalotiaAbdomen1_x');
dalAbdYIdx = contains(header, 'DalotiaAbdomen1_y');
dalHdXIdx = contains(header, 'DalotiaHead_x');
dalHdYIdx = contains(header, 'DalotiaHead_x');

otherMidXIdx = contains(header, 'AntThorax_x');
otherMidYIdx = contains(header, 'AntThorax_y');
otherHdXIdx = contains(header, 'AntHead_x');
otherHdYIdx = contains(header, 'AntHead_y');

rawDatafiltVelocityOrientations = cell(expnum, 1);   % cell array to return
% frame to min conversion: eg, (1 sec/60 frames)*(1 min/60 sec)=time in min
fps = 60;
frame2time = (1/fps) * (1/60); %
for i = 1:expnum
    data = rawDatafilt{i, 1};
    rows = size(data, 1);
    frame_nums = [1:rows]';
    time_col = frame_nums * frame2time;     % time column
   
    velocity_orientations(rows,1) = 0;
    
    dal_positions_x = data{:, dalAbdXIdx};
    dal_positions_y = data{:, dalAbdYIdx};
    other_positions_x = data{:, otherMidXIdx};
    other_positions_y = data{:, otherMidYIdx};
    for j = 1:rows-1
        
        dal_pos1 = [dal_positions_x(j), dal_positions_y(j)];
        dal_pos2 = [dal_positions_x(j + 1), dal_positions_y(j+1)];
        
        other_pos1 = [other_positions_x(j) other_positions_y(j)];
        other_pos2 = [other_positions_x(j + 1) other_positions_y(j+1)];
        
        dal_disp = dal_pos2 - dal_pos1; 
        other_disp = other_pos2 - other_pos1;
    
        time_elapsed = time_col(j + 1, 1) - time_col(j, 1);
        
        dal_velocity = dal_disp ./ time_elapsed; %Unlike with velocities2, velocity is 2D vector
        other_velocity = other_disp ./ time_elapsed;

        dal_speed = vecnorm(dal_velocity);
        other_speed = vecnorm(other_velocity);

        norm_dot_product = dot(dal_velocity./dal_speed, other_velocity./other_speed); %Take the normalized dot product between the velocities)
        
        velocity_orientations(j,1) = norm_dot_product;
        if rawDatafiltCollisions{i,1}(2) == 1
            if norm_dot_product < 0 && other_speed > 20 && dal_speed > 20
                velocity_orientations(j,2) = 'Mutual';
            elseif norm_dot_product > 0 && other_speed > dal_speed
                velocity_orientations(j,2) = 'Other_chase';
            elseif norm_dot_product > 0 && dal_speed > other_speed   
                velocity_orientations(j,2) = 'Dal_chase';
            elseif dal_speed >=20 && other_speed <= 20
                velocity_orientations(j,2) = 'Dal_Approach';
            elseif dal_speed <=20 && other_speed >= 20
                velocity_orientations(j,2) = 'Other_Approach';
            end
        else 
            velocity_orientations(j,2) = 'No_Inter';
        end
    end
    rawDatafiltVelocityOrientations{i,1} = array2table(velocity_orientations, "VariableNames", {'Velocities Dotted', 'Interaction Type'});
end