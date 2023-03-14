%% inputs: rawDatafilt 
% a column cell array, where each cell is a table containing frame
% nums, and x,y coordinates of each body part and their likelihoods for both organisms

% ex: otherOrg = 'Dmel';
%% outputs: rawDatafiltcurvature
% cell array of experiments, each expimeriment has "frames-2" number of
% rows. Each row in each cell is the rate of change of the direction at the
% moment. In other words, if each velocity at each time point was a vector,
% each entry represents the angular speed of that vector at that moment.

%% Problems and Plans 
% Might want to swtich body position with head position, which might make
% the heading of the insects more clear.

function rawDatafiltcurvature = curvature(rawDatafilt)




expnum = size(rawDatafilt, 1);

rawDatafiltcurvature = cell(expnum, 1);   % cell array to return
fps = 60;
frame2time = (1/fps); %Time conversion from frames to seconds
for i = 1:expnum
    data = rawDatafilt{i, 1};
    rows = size(data, 1);
    frame_nums = [1:rows]';
    time_col = frame_nums * frame2time;     % time column
   
    
    dal_positions_x = data.DalotiaAbdomen1_x; %x and y positions; can be replaces with the head position later
    dal_positions_y = data.DalotiaAbdomen1_y;
    other_positions_x = data.AntThorax_x;
    other_positions_y = data.AntThorax_y;

    dal_velocities = zeros(rows-1,2); %Velocities of insects
    other_velocities = zeros(rows-1, 2);
    dal_curvatures = zeros(rows-2,1); %Curvatures of insect paths
    other_curvatures = zeros(rows-2,1);

    for j = 1:rows-1
        
        dal_pos1 = [dal_positions_x(j), dal_positions_y(j)];
        dal_pos2 = [dal_positions_x(j + 1), dal_positions_y(j+1)];
        
        other_pos1 = [other_positions_x(j), other_positions_y(j)];
        other_pos2 = [other_positions_x(j + 1), other_positions_y(j+1)];

        dal_disp = dal_pos2 - dal_pos1; 
        other_disp = other_pos2 - other_pos1;
    
        time_elapsed = time_col(j+1, 1) - time_col(j, 1);
        
        dal_velocity = dal_disp ./ time_elapsed; %Unlike with velocities2, velocity is 2D vector. The units here is pixels per second
        other_velocity = other_disp ./ time_elapsed;
        
        dal_velocities(j,:) = dal_velocity; %Store velocities temporarily
        other_velocities(j,:) = other_velocity;
        
    end
    for n = 1:rows-2
        if all(~isnan(dal_velocities(n,:))) && all(~isnan(dal_velocities(n+1,:))) && all(~isnan(other_velocities(n,:))) && all(~isnan(other_velocities(n+1,:)))
            dal_angular_speed = subspace(dal_velocities(n,:)',dal_velocities(n+1,:)')*60; 
            other_angular_speed = subspace(other_velocities(n,:)',other_velocities(n+1,:)')*60;
            dal_curvatures(n,1) = dal_angular_speed;
            other_curvatures(n,1) = other_angular_speed;
        end
    end
    rawDatafiltcurvature{i,1} = table(time_col(1:end-2), dal_curvatures, other_curvatures); %Finally, experiment i is complete and the cell is updated.
end