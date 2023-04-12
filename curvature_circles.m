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

function rawDatafiltcurvature = curvature_circles(rawDatafilt)

expnum = size(rawDatafilt, 1);


fps = 60;
frame2time = (1/fps); %Time conversion from frames to seconds
for i = 1:2:expnum
    data = rawDatafilt{i, 1};
    rows = size(data, 1);
    frame_nums = [1:rows]';
    time_col = frame_nums * frame2time;     % time column
   
    
    dal_positions_x = data.DalotiaAbdomen1_x; %x and y positions; can be replaces with the head position later
    dal_positions_y = data.DalotiaAbdomen1_y;
    dal_positions_z = data.DalotiaAbdomen1_x;
    other_positions_x = data.AntThorax_x;
    other_positions_y = data.AntThorax_y;
    other_positions_z = data.AntThorax_x;

   
    dal_curvatures = zeros(rows-2,1); %Curvatures of insect paths
    other_curvatures = zeros(rows-2,1);

    stable_dal_pos = [dal_positions_x(1:3:end),dal_positions_y(1:3:end),dal_positions_z(1:3:end)];
    stable_other_pos = [other_positions_x(1:3:end),other_positions_y(1:3:end),other_positions_z(1:3:end)];

    for j = 2:size(stable_dal_pos,1)-1
        dalSideA = vecnorm(stable_dal_pos(j,:) - stable_dal_pos(j+1,:));
        dalSideB = vecnorm(stable_dal_pos(j-1,:) - stable_dal_pos(j,:));
        dalSideC = vecnorm(stable_dal_pos(j+1,:) - stable_dal_pos(j-1,:));
        otherSideA = vecnorm(stable_other_pos(j,:) - stable_other_pos(j+1,:));
        otherSideB = vecnorm(stable_other_pos(j-1,:) - stable_other_pos(j,:));
        otherSideC = vecnorm(stable_other_pos(j+1,:) - stable_other_pos(j-1,:));

        dal_sp = 0.5*(dalSideA + dalSideB + dalSideC);
        other_sp = 0.5*(otherSideA + otherSideB + otherSideC);

        dal_triangle = sqrt(dal_sp*(dal_sp - dalSideA)*(dal_sp-dalSideB) *(dal_sp - dalSideC));
        other_triangle = sqrt(other_sp*(other_sp - otherSideA)*(other_sp-otherSideB) *(other_sp - otherSideC));

        dal_curvature =  4*dal_triangle/(dalSideA*dalSideB*dalSideC);
        other_curvature = 4*other_triangle/(otherSideA*otherSideB*otherSideC);

        dal_curvatures(j*3-4:j*3-1,1) = dal_curvature;
        other_curvatures(j*3-4:j*3-1,1) = other_curvature;

    end
    

        
    
    rawDatafiltcurvature{ceil(i/2),1} = table(time_col(1:size(dal_curvatures)), dal_curvatures, other_curvatures); %Finally, experiment i is complete and the cell is updated.
end