%% inputs: rawDatafilt and rawDatafiltSizes (output of getSizes)


%% outputs: rawDatafiltEllipses
% a cell array of tables, the tables have first column for the frame #,
% second column where each value of the column is a matrix that contains 20 [x
% y] vertices for parametrizaiton of an ellipse centered on Dalotia, and third
% column which is same as second column but for other organism
%   frame_nums(array)   dal_vertices(cell arr)    other_vertices(cell arr)
%                        {[x y]; [x y]; ... }
%% We will be using a horizontal ellipse, where the semi major axis is on the x axis,
%% the magnitude of which is the length of the organism. Right after each vertex of the
%% horizontal ellipse is obtained, the vector will be transformed by the rotation matrix,
%% the angle will be obtained by using the definition of the dot product to get the 
%% angle between a horizontal line vector placed on the y coordinate of the center of the 
%% organism and the vector obtained from subtracting the head and tail of the organism.
%% If the y coordinate of the head of the organism is greater than the y coordinate of
%% the horizontal line then the angle is positive, if it is less, then the angle is 
%% negative when placed in rotation matrix. This will be done for dalotia and other.


%% Current version of this function takes median lengths and widths as arguments, but later
%% could have rawDatafiltSizes (output of getSizes) as an argument and use the lengths and
%% widths from each frame
function rawDatafiltEllipses = createEllipses2(rawDatafilt, rawDatafiltSizes)

expnum = size(rawDatafilt, 1);
header = rawDatafilt{1,1}.Properties.VariableNames;

rawDatafiltEllipses = cell(expnum, 1);

% stores 20 ellipse vertices at a time
vertices = cell(1, 20);   

% extract dalotia center indices
dalCenterXIdx = contains(header, 'DalotiaElytra_x');
dalCenterYIdx = contains(header, 'DalotiaElytra_y');

% extract dalotia head and tail indices
dalHeadXIdx = contains(header, 'DalotiaHead_x');
dalHeadYIdx = contains(header, 'DalotiaHead_y');
dalAbd3XIdx = contains(header, 'DalotiaAbdomen3_x');
dalAbd3YIdx = contains(header, 'DalotiaAbdomen3_y');

% extract other center indices
% otherCenterXIdx = contains(header, 'OtherMid_x');
% otherCenterYIdx = contains(header, 'OtherMid_y');
otherCenterXIdx = contains(header, 'AntThorax_x');
otherCenterYIdx = contains(header, 'AntThorax_y');

% extract other head and tail indices
otherHeadXIdx = contains(header, 'AntHead_x');
otherHeadYIdx = contains(header, 'AntHead_y');
otherTailXIdx = contains(header, 'AntAbdomen_x');
otherTailYIdx = contains(header, 'AntAbdomen_y');

% extract Dalotia abdomen 2 indices
dalAbd2XIdx = contains(header, 'DalotiaAbdomen2_x');
dalAbd2YIdx = contains(header, 'DalotiaAbdomen2_x');

for i = 1:expnum
    tic

    data = rawDatafilt{i,1};
    rows = size(data, 1);
    frame_nums = [1:rows]';
    sizes_data = rawDatafiltSizes{i, 1};
    
    dal_centers_x = data{:, dalCenterXIdx};
    dal_centers_y = data{:, dalCenterYIdx};
    other_centers_x = data{:, otherCenterXIdx};
    other_centers_y = data{:, otherCenterYIdx};
    
    dal_heads_x = data{:, dalHeadXIdx};
    dal_heads_y = data{:, dalHeadYIdx};
    other_heads_x = data{:, otherHeadXIdx};
    other_heads_y = data{:, otherHeadYIdx};
    
    dal_tails_x = data{:, dalAbd3XIdx};
    dal_tails_y = data{:, dalAbd3YIdx};
    other_tails_x = data{:, otherTailXIdx};
    other_tails_y = data{:, otherTailYIdx};
    
    dal_pseudoheads_x = data{:, dalCenterXIdx};
    dal_pseudoheads_y = data{:, dalCenterYIdx};
    dal_pseudotails_x = data{:, dalAbd2XIdx};
    dal_pseudotails_y = data{:, dalAbd2YIdx};
    
    for k = 1:rows
        % get vertices for dalotia

        % extract major and minor axes from size_data
        dalSemiMajor = sizes_data{k, 2} / 2;      % 2 is dal lengths column
        dalSemiMinor = sizes_data{k, 3} / 2;      % 3 is dal widths column
        
        % dal_horz is a vector gotten from subtracting a point slightly to
        % the right of dalotia center from dalotia center, to get a
        % horizontal vector pointing to the right, passing through center
        % of dalotia
        dal_horz = [dal_centers_x(k,1) + 0.001, dal_centers_y(k,1)] - [dal_centers_x(k,1) dal_centers_y(k,1)];
        %dal_vector = [dal_heads_x(k,1) dal_heads_y(k,1)] - [dal_tails_x(k,1) dal_tails_y(k,1)];
        dal_vector = [dal_pseudoheads_x(k,1) dal_pseudoheads_y(k,1)] - [dal_pseudotails_x(k,1) dal_pseudotails_y(k,1)];
        % now we get the angle between dal_horz and dal_vector
        dotprod = dot(dal_horz, dal_vector);
        % magprod = |a||b|, where a and b are dal_hroz and dal_vector
        magprod = abs(sqrt(dal_horz(1,1)^2 + dal_horz(1,2)^2)) * abs(sqrt(dal_vector(1,1)^2 + dal_vector(1,2)^2));
        rotation_angle = acos(dotprod / magprod);   %acos works with radians
        % Note: dot product def is a . b = |a||b|cos(theta)

        % if y of dalotia head is below y of horizontal line through dalotia center
        negation = false;
        if dal_heads_y(k,1) < dal_centers_y(k, 1) 
            negation = true;
        end
        
        if negation == true
            rotation_angle = -rotation_angle;
        end
        
        rotation_matrix = [cos(rotation_angle) -sin(rotation_angle); sin(rotation_angle) cos(rotation_angle)];
            
        for j = 1:20
            angle = 2 * pi * j / 20;
            x = (dalSemiMajor + 8) * cos(angle);
            y = (dalSemiMinor + 8) * sin(angle);
            % rotate the [x y] vertex of the ellipse
            v_rot = (rotation_matrix * [x y]')';
            % center onto the organism
            v_fin = [v_rot(1,1) + dal_centers_x(k, 1)  v_rot(1, 2) + dal_centers_y(k, 1)];
            vertices{1, j} = v_fin;
        end
        dal_vertices{k, 1} = cell2mat(vertices');
        clear vertices

    end

    
    for k = 1:rows
         % get vertices for Other
        
        otherSemiMajor = sizes_data{k, 4} / 2;
        otherSemiMinor = sizes_data{k, 5} / 2;
    
        other_horz = [other_centers_x(k,1) + 0.001, other_centers_y(k,1)] - [other_centers_x(k,1) other_centers_y(k,1)];
        other_vector = [other_heads_x(k,1) other_heads_y(k,1)] - [other_tails_x(k,1) other_tails_y(k,1)];
       
        dotprod = dot(other_horz, other_vector);
        magprod = abs(sqrt(other_horz(1,1)^2 + other_horz(1,2)^2)) * abs(sqrt(other_vector(1,1)^2 + other_vector(1,2)^2));
       
        rotation_angle = acos(dotprod / magprod);   
        
        negation = false;
        if other_heads_y(k,1) < other_centers_y(k,1) 
            negation = true;
        end
        
        if negation == true
            rotation_angle = -rotation_angle;
        end
        
        rotation_matrix = [cos(rotation_angle) -sin(rotation_angle); sin(rotation_angle) cos(rotation_angle)];
        
        for j = 1:20
            angle = 2 * pi * j / 20;
            x = (otherSemiMajor + 8) * cos(angle);
            y = (otherSemiMinor + 8) * sin(angle);
            % rotate the [x y] vertex of the ellipse
            v_rot = (rotation_matrix * [x y]')';
            % center onto the organism
            v_fin = [v_rot(1,1) + other_centers_x(k, 1)  v_rot(1, 2) + other_centers_y(k, 1)];
            vertices{1, j} = v_fin;
        end
        other_vertices{k, 1} = cell2mat(vertices');
        clear vertices

    end

    tableOfEllipsesVertices = table(frame_nums, dal_vertices, other_vertices);
    rawDatafiltEllipses{i, 1} = tableOfEllipsesVertices;

%      sprintf('ExpNum, iter: %u', i)

    clear dal_vertices
    clear other_vertices

    toc
end

clear data
clear sizes_data
% disp('line 170')

end




