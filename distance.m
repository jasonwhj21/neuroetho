%% Input
%Filtered positional data
%% Output
% Cell array with rows = number of experiments. In each cell are 3 columns:
% time, distance from other middle to dalotia head (headDist) and other middle to
% dalotia middle (midDist. The head distance is useful for taking heading
% into account, whereas middle distance is good for ignoring beetle
% rotation.

function rawDatafiltdistance = distance(rawDatafilt)

expnum = size(rawDatafilt, 1);

rawDatafiltdistance = cell(expnum, 1);   % cell array to return
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
    otherMidT = [rawDatafilt{i,1}.AntThorax_x, rawDatafilt{i,1}.AntThorax_y, rawDatafilt{i+1,1}.AntThorax_x];
    midDist = vecnorm(dalAbd1T' - otherMidT')';
    headDist = vecnorm(dalHead' - otherMidT')';
    rawDatafiltdistance{i,1} = table(time_col,midDist,headDist);
    
end
