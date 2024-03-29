%% Input
%Filtered positional data
%% Output
% Cell array with rows = number of experiments. In each cell are 3 columns:
% time, distance from other middle to dalotia head (headDist) and other middle to
% dalotia middle (midDist. The head distance is useful for taking heading
% into account, whereas middle distance is good for ignoring beetle
% rotation.

function [rawDatafiltdistance, closeBouts] = distance(rawDatafilt,minDist,maxDist)

expnum = size(rawDatafilt, 1) ;

rawDatafiltdistance = cell(expnum/2, 1);   % cell array to return
fps = 60;
frame2time = (1/fps); %Time conversion from frames to seconds

for i = 1:2:expnum
    data = rawDatafilt{i, 1};
    rows = size(data, 1);
    frame_nums = [1:rows]';
    time_col = frame_nums * frame2time;     % time column
    % Dal-Other Euclidean Dist,
    % x- and y- are from base and z- position is from mirror
    dalAbd1T = [rawDatafilt{i,1}.DalotiaAbdomen1_x, rawDatafilt{i,1}.DalotiaAbdomen1_y, rawDatafilt{i+1,1}.DalotiaAbdomen1_x];
    dalHead = [rawDatafilt{i,1}.DalotiaHead_x, rawDatafilt{i,1}.DalotiaHead_y, rawDatafilt{i+1,1}.DalotiaHead_x];
    AntThoraxT = [rawDatafilt{i,1}.AntThorax_x, rawDatafilt{i,1}.AntThorax_y, rawDatafilt{i+1,1}.AntThorax_x];
    AntHeadT = [rawDatafilt{i,1}.AntHead_x, rawDatafilt{i,1}.AntHead_y, rawDatafilt{i+1,1}.AntHead_x];
    midDist = vecnorm(dalAbd1T' - AntThoraxT')';
    headDist = vecnorm(dalHead' - AntThoraxT')';
    midHead = vecnorm(dalAbd1T' - AntHeadT')';
    headHead = vecnorm(dalHead' - AntHeadT')';
    collision = [min([midDist,headDist,midHead,headHead,midHead],[],2)<maxDist & min([midDist,headDist,headHead,midHead],[],2)>minDist];
    collision = [0;0;0;0;0;collision;0;0;0;0;0];
    interaction_starts = [];
    interaction_ends = [];
    for j = 6:rows+5
        if collision(j) == 1 && any(collision(j-5:j-1)) == false 
            interaction_starts(end+1) = j-5; %If a time point has a collision but no collision within 5 frames before, then it's the start of a bout
        end
        if collision(j) == 1 && any(collision(j+1:j+5)) == false
            interaction_ends(end+1) = j-5; %If a time point has a collision but no collision within 5 frames after, then it's the end of a bout
        end
    end
    closeBouts{ceil(i/2),1} = table(interaction_starts',interaction_ends');
    rawDatafiltdistance{ceil(i/2),1} = table(time_col,midDist,headDist,midHead,headHead);
end
