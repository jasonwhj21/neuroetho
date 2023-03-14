%% Plot inter-animal distance
% Determines the cuttoff for eliminating tracking errors when plotting
% interanimal distance
% overview: plots the dirtibution of delta distances between frames, across
% all expts. (diff of Dist), fits this distibution to guassian and finds
% mean(mu) and sigma
% note: this is more of a "band-aid" solution to fill missing values
% (ideally, would improve dlc tracking)
%
% 220526

%% Clear all
clear all; clc; close all

%% Load data
%load relevant data sets
load('xyDataFilt.mat')

%% Inputs

frameNum = 1;



%number of experiments
expnum = size(rawDatafilt,1);

% fps to min: e.g.(1 sec/60 frames)*(1 min/60 sec)=time in min
fps = 60;
frame2time = (1/fps) * (1/60); 

%number of std dev away from mean for which diffDist is an outlier
beta = 3;

% simplified filenames
for i = 1:length(files)
    fileNames{i,1} = extractBefore(files(i).name,"DLC");   
end

    
%% Find distribution of delta distance between frames 
frameNum = 1;
%number of experiments
expnum = size(rawDatafilt,1);
diffDist = cell(expnum,1);
% fps to min: e.g.(1 sec/60 frames)*(1 min/60 sec)=time in min
fps = 60;
frame2time = (1/fps) * (1/60); 

%number of std dev away from mean for which diffDist is an outlier
beta = 3;


for i = 1:2:expnum
    
    % Dal-Other Euclidean Dist,
    % x- and y- are from base and z- position is from mirror
    dalAbd1T = [rawDatafilt{i,1}.DalotiaAbdomen1_x, rawDatafilt{i,1}.DalotiaAbdomen1_y, rawDatafilt{i+1,1}.DalotiaAbdomen1_x];
    otherMidT = [rawDatafilt{i,1}.AntThorax_x, rawDatafilt{i,1}.AntThorax_y, rawDatafilt{i+1,1}.AntThorax_x];
    distrawT = sqrt(sum(((dalAbd1T - otherMidT).^2), 2));
%     distT = sqrt(sum(((dalAbd1T - larMidT).^2), 2));
    tT = rawDatafilt{i+1,1}{:,frameNum} * frame2time;
    
    %find diff(Distance) across all expts
    diffDist{i,1} = diff(distrawT);
    diffDist = diffDist(~cellfun(@isempty,diffDist));
end

%% combine all diffDist from all expts into a single vector
    diffAllDist = cat(1, diffDist{:});
    
    %plot the distribution of diffDist
    figure
    histogram(diffAllDist,'Normalization', 'probability')
    figure
    histfit(diffAllDist)
    
    fitdist(diffAllDist,'Normal');
    
    %fit hist to normal and find mu(mean) and sigma
    pd = fitdist(diffAllDist,'Normal');
    diffDistmax = pd.mu + beta*(pd.sigma);
    diffDistmin = pd.mu - beta*(pd.sigma);