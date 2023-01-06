%% Plot distributions of length of each animal
%  220526

%% Clear all
clear all; clc; close all

%% Load data
%load relevant data sets
load('xyDataFilt.mat')

%% Inputs

frameNum = 1;

dalotiaHeadx = 8;
dalotiaHeady = 9;
dalotiaElyx = 14;
dalotiaElyy = 15;
dalotiaAb1x = 17;
dalotiaAb1y = 18;
dalotiaAb2x = 20;
dalotiaAb2y = 21;
dalotiaAb3x = 23;
dalotiaAb3y = 24;

otherHeadx = 26;
otherHeady = 27;
otherMidx = 29;
otherMidy = 30;
otherTailx = 32;
otherTaily = 33;

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

    
%% Calculate body length = head-tail distance, for both organisms across all frames

dal_bodylength = cell(expnum,1);
other_bodylength = cell(expnum,1);

for i = 1:2:expnum

    % (x,y,z) for head and tail of Dal and other
    % x- and y- are from base and z- position is from mirror
    dalH = [rawDatafilt{i,1}{:,dalotiaHeadx}, rawDatafilt{i,1}{:,dalotiaHeady}, rawDatafilt{i+1,1}{:,dalotiaHeadx}];
    dalT = [rawDatafilt{i,1}{:,dalotiaAb3x}, rawDatafilt{i,1}{:,dalotiaAb3y}, rawDatafilt{i+1,1}{:,dalotiaAb3x}];
    dal_HTdiff = dalT - dalH;
    dal_HTdiff_sqrd = (dal_HTdiff).^2;
    dal_length = sqrt(sum(dal_HTdiff_sqrd,2));
    dal_bodylength{i} = dal_length;


    otherH = [rawDatafilt{i,1}{:,otherHeadx}, rawDatafilt{i,1}{:,otherHeady}, rawDatafilt{i+1,1}{:,otherHeadx}];
    otherT = [rawDatafilt{i,1}{:,otherTailx}, rawDatafilt{i,1}{:,otherTaily}, rawDatafilt{i+1,1}{:,otherTailx}];
    other_HTdiff = otherT - otherH;
    other_HTdiff_sqrd = (other_HTdiff).^2;
    other_length = sqrt(sum(other_HTdiff_sqrd,2));
    other_bodylength{i} = other_length;

end

%remove empty cell arrays
dal_bl =  dal_bodylength(~cellfun('isempty', dal_bodylength));
other_bl = other_bodylength(~cellfun('isempty', other_bodylength));

%combine all bodylengths into a single array
dal_all_bl = cat(1, dal_bl{:});
other_all_bl = cat(1, other_bl{:});


%% Plot distributions
%calculate the "thresh" percentile to use as estimate for body length of
%each insect

%dalotia
figure
edges = [0:1:100];
nbins = length(edges) - 1;
histogram(dal_all_bl, edges,'FaceColor', [.5,.5,.5],'FaceAlpha',.5)
thresh = 80;
percentile = prctile(dal_all_bl, thresh);
hold on
yl =  ylim;
plot([percentile, percentile], [yl(1),yl(2)] ,'-r', 'LineWidth', 2)
xlabel('Dalotia Body Length (pixels)', 'FontSize', 14);
ylabel({'Frequency'}, 'FontSize', 14);
xlim([0,100]);
text(percentile+5, yl(2) - yl(2)/4,{thresh;'percentile ='; percentile; 'pixels'},...
    'Color','red','FontSize',10)

%pretty figure settings
set(gca, ...
    'LineWidth', 2,...
    'XColor', 'k',...
    'YColor', 'k',...
    'FontName', 'Arial',...
    'FontSize', 16,...
    'Box', 'off');
whitebg('white')
set(gcf, 'Color', 'w');


%other insect
figure
histogram(other_all_bl,edges,'FaceColor', [.5,.5,.5],'FaceAlpha',.5)
thresh = 80;
percentile = prctile(other_all_bl, thresh);
hold on
yl =  ylim;
plot([percentile, percentile], [yl(1),yl(2)] ,'-r', 'LineWidth', 2)
xlabel('Other Body Length (pixels)', 'FontSize', 14);
ylabel({'Frequency'}, 'FontSize', 14);
xlim([0,100]);
text(percentile+5, yl(2) - yl(2)/4,{thresh;'percentile ='; percentile; 'pixels'},...
    'Color','red','FontSize',10)

%pretty figure settings
set(gca, ...
    'LineWidth', 2,...
    'XColor', 'k',...
    'YColor', 'k',...
    'FontName', 'Arial',...
    'FontSize', 16,...
    'Box', 'off');
whitebg('white')
set(gcf, 'Color', 'w');

%% calculate median and MAD
dal_median = nanmedian(dal_all_bl);
dal_mad = mad(dal_all_bl,1);

%% interDist 
% interdist  = 0.5*dal_percentile + 0.5*other_percentile;
% interdist  = 0.5*57 + 0.5*66 = 61.5 ~ 62;


%% Find distribution of delta distance between frames 

diffDist = cell(expnum,1);

for i = 1:2:expnum
    
    % Dal-Other Euclidean Dist,
    % x- and y- are from base and z- position is from mirror
    dalAbd1T = [rawDatafilt{i,1}{:,dalotiaAb1x}, rawDatafilt{i,1}{:,dalotiaAb1y}, rawDatafilt{i+1,1}{:,dalotiaAb1x}];
    otherMidT = [rawDatafilt{i,1}{:,otherMidx}, rawDatafilt{i,1}{:,otherMidy}, rawDatafilt{i+1,1}{:,otherMidx}];
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