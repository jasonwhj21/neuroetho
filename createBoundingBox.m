%% inputs: rawDatafilt 
%% outputs: rawDataFiltBoxes
% A cell array of tables, the first column of which is the frame numbers,
% and the second being dal_vertices which define the beetle's bounding box
% on that frame
% Dal_verticies is itself a 3 column cell array. Within each columnm is a
% rectangle represented by a 4 row, 2 column array, which looks like 
% {[x,y]; [x,y]; [x,y]; [x,y]}
%% Explanation 
% How are each of the 4 vertices found? The first set is found by taking
% the vector from abd3 pointing to abd2. Then, take the normalized,
% perpendicular vector. Lets call that the "axis". Then, extend abd2 in the
% positive axis and negative axis direction by dal_width/2. Repeat with
% abd3 to get 4 points. Repeat the entire process with a vector poiting
% from abd2 to abd 1, then abd1 to head. I reasoned that there isn't as
% much flexion from abd1 to head, meaning it can be reasonably approximated
% by 1 rectangle. The only difference is that I made the rectangle slightly
% longer to account for the antenna as seen on 118-119.
%% Problems
% There are a few problems: at the moment, dal width is defined by a ratio
% with dal length, which is itself defined by taking the euclidean distance
% between the head and abd3. If the beetle is curled up, the accuracy of
% the length suffers, and the width will consequently suffer as well.
% Please correct me if I'm misunderstanding the length part.
% The other problem is that I haven't done this for the other organism yet,
% since it's a much more variable organism. Might just keep using ellipses.




function rawDataFiltBoxes = createBoundingBox(rawDatafilt, rawDatafiltSizes)

expnum = size(rawDatafilt, 1);
header = rawDatafilt{1,1}.Properties.VariableNames;


rawDatafiltBoxes = cell(expnum, 1);


% extract dalotia center indices
dalCenterXIdx = contains(header, 'DalotiaElytra_x');
dalCenterYIdx = contains(header, 'DalotiaElytra_y');

% extract dalotia head and tail indices
dalAbd1XIdx = contains(header, 'DalotiaAbdomen1_x');
dalAbd1YIdx = contains(header, 'DalotiaAbdomen1_y');
dalAbd2XIdx = contains(header, 'DalotiaAbdomen2_x');
dalAbd2YIdx = contains(header, 'DalotiaAbdomen2_y');
dalAbd3XIdx = contains(header, 'DalotiaAbdomen3_x');
dalAbd3YIdx = contains(header, 'DalotiaAbdomen3_y');

dalAntennaLXIdx = contains(header, 'DalotiaAntennaL_x');
dalAntennaLYIdx = contains(header, 'DalotiaAntennaL_y');
dalAntennaRXIdx = contains(header, 'DalotiaAntennaR_x');
dalAntennaRYIdx = contains(header, 'DalotiaAntennaR_y');

dalHeadXIdx = contains(header, 'DalotiaHead_x');
dalHeadYIdx = contains(header, 'DalotiaHead_y');

for i = 1:expnum
    tic

    data = rawDatafilt{i,1};
    rows = size(data, 1);
    frame_nums = [1:rows]';
    sizes_data = rawDatafiltSizes{i, 1};

    %Grab the indices
    
    dal_abd1_x = data{:,dalAbd1XIdx};
    dal_abd1_y = data{:,dalAbd1YIdx};
    dal_abd2_x = data{:,dalAbd2XIdx};
    dal_abd2_y = data{:,dalAbd2YIdx};
    dal_abd3_x = data{:,dalAbd3XIdx};
    dal_abd3_y = data{:,dalAbd3YIdx};

    dal_antennaR_x = data{:, dalAntennaRXIdx};
    dal_antennaR_y = data{:, dalAntennaRYIdx};
    dal_antennaL_x = data{:, dalAntennaLXIdx};
    dal_antennaL_y = data{:, dalAntennaLYIdx};

    dal_head_x = data{:,dalHeadXIdx};
    dal_head_y = data{:,dalHeadYIdx};

    
    dal_verticies = cell(rows,3);
    for k = 1:rows 
        %Start looping through individual frames
        

        
        dal_abd1_xy = [dal_abd1_x(k, 1), dal_abd1_y(k, 1)];
        dal_abd2_xy = [dal_abd2_x(k, 1), dal_abd2_y(k, 1)];
        dal_abd3_xy = [dal_abd3_x(k, 1), dal_abd3_y(k, 1)];
        dal_head_xy = [dal_head_x(k, 1), dal_head_y(k, 1)];
        dalWidth = sizes_data{k, 3} / 2;
        
        %Vector pointing from abd1 to center and abd3 to abd 2
        edge1 = dal_head_xy - dal_abd1_xy;
        edge2 = dal_abd1_xy - dal_abd2_xy;
        edge3 = dal_abd2_xy - dal_abd3_xy;
        normedge1 = edge1./norm(edge1);
        
        %Vector perpendicular to their respective edges
        axis1 = [edge1(1,2), -edge1(1,1)];
        axis2 = [edge2(1,2), -edge2(1,1)];
        axis3 = [edge3(1,2), -edge3(1,1)];
        
        %Normalize the perpendicular vectors
        normaxis1 = axis1./norm(axis1);
        normaxis2 = axis2./norm(axis2);
        normaxis3 = axis3./norm(axis3);

        

        %Every Beetle is made up of 6 vertices: 2 antenna, 2 perpendicular
        %to the abd1/center edge, 2 perpendicular to the abd2/abd3 edge.
        %The added 8 is to extend the beetle's hitbox slightly further out
        
        rect1_head_vertex1 = (dal_head_xy + (5 * normedge1)) + (normaxis2 * (dalWidth + 2)); %90 degrees clockwise from edge1
        rect1_head_vertex2 = (dal_head_xy + (5 * normedge1)) - (normaxis2 * (dalWidth + 2)); %90 degrees coutnerclockwise from edge1
        rect1_abd1_vertex1 = dal_abd1_xy + (normaxis1 * (dalWidth + 2));
        rect1_abd1_vertex2 = dal_abd1_xy - (normaxis1 * (dalWidth + 2));
        rect1 = [rect1_head_vertex1; rect1_abd1_vertex1;rect1_abd1_vertex2; rect1_head_vertex2];

        rect2_abd1_vertex1 = dal_abd1_xy + (normaxis2 * (dalWidth + 2)); %90 degrees clockwise from edge2
        rect2_abd1_vertex2 = dal_abd1_xy - (normaxis2 * (dalWidth + 2)); %90 degrees coutnerclockwise from edge2
        rect2_abd2_vertex1 = dal_abd2_xy + (normaxis2 * (dalWidth + 2));
        rect2_abd2_vertex2 = dal_abd2_xy - (normaxis2 * (dalWidth + 2));
        rect2 = [rect2_abd1_vertex1; rect2_abd2_vertex1;rect2_abd2_vertex2; rect2_abd1_vertex2];

        rect3_abd2_vertex1 = dal_abd2_xy + (normaxis3 * (dalWidth + 2)); %90 degrees clockwise from edge3
        rect3_abd2_vertex2 = dal_abd2_xy - (normaxis3 * (dalWidth + 2)); %90 degrees coutnerclockwise from edge3
        rect3_abd3_vertex1 = dal_abd3_xy + (normaxis3 * (dalWidth + 2));
        rect3_abd3_vertex2 = dal_abd3_xy - (normaxis3 * (dalWidth + 2));
        rect3 = [rect3_abd2_vertex1; rect3_abd3_vertex1;rect3_abd3_vertex2; rect3_abd2_vertex2];
        
        dal_verticies{k,1} = rect1;
        dal_verticies{k,2} = rect2;
        dal_verticies{k,3} = rect3;
    end
     tableOfVertices = table(frame_nums, dal_verticies);
     rawDatafiltBoxes{i, 1} = tableOfVertices;
end
% end