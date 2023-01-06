%% inputs: rawDatafilt 
%% outputs: rawDataFiltBoxes
% A cell array of tables, the first column of which is the frame numbers,
% and the second being dal_vertices which define the beetle's bounding box
% on that frame
% Dal_verticies is itself a 3 column cell array. Within the 
%% Explanation 
% To find the vertices, first find 2 vectors: one pointing from abd 1 to
% pronotum (center) and one pointing from abd 3 to abd 2. Then for each of
% those vectors, find the normalized vector pointing perpendicular to it.
% We will refer to those vectors as the axes.
% Next, locate abd 1 and find the point that is dal_width/2 distance away
% in the axes direction; that is our first vertex. Then repeat in the -axes
% direction. Then, repeat the whole process with abd 3. Finally, take the
% two antenna to get the 6 vertices.
%% Problems
% There are a few problems: at the moment, dal width is defined by a ratio
% with dal length, which is itself defined by taking the euclidean distance
% between the head and abd3. If the beetle is curled up, the accuracy of
% the length suffers, and the width will consequently suffer as well.
% Please correct me if I'm misunderstanding the length part.

% Another problem is whether to extend out the bounding box a little. In
% other words, do we extend the points by dal_width + x, which would create
% some leniency in interactions? createEllipses2 does this (with x = 8),
% but the problem with this bounding box method is that there's no way to
% ensure that the resulting polygon isn't self intersecting if x is too large. This is
% not a big problem; we can simply make x small , <2 or so.

% Finally, we need to make sure the polygon is convex. This is no problem,
% I can just divide it into 2 quatrilaterals, and do the dividing
% separating axis theorem twice. If I decide to change the ant bounding box
% later, then we can do the separating axis theorem 4 times. I haven't
% found a better bounding method for ants quite yet due to their long legs
% and the lack of points on the hind legs.


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
    dal_centers_x = data{:, dalCenterXIdx};
    dal_centers_y = data{:, dalCenterYIdx};

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
        

        dal_center_xy = [dal_centers_x(k, 1), dal_centers_y(k, 1)];
        dal_abd1_xy = [dal_abd1_x(k, 1), dal_abd1_y(k, 1)];
        dal_abd2_xy = [dal_abd2_x(k, 1), dal_abd2_y(k, 1)];
        dal_abd3_xy = [dal_abd3_x(k, 1), dal_abd3_y(k, 1)];
        dal_antennaR_xy = [dal_antennaR_x(k, 1), dal_antennaR_y(k, 1)];
        dal_antennaL_xy = [dal_antennaL_x(k, 1), dal_antennaL_y(k, 1)];
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