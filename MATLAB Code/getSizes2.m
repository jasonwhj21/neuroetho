%% Extract Length/Width Sizes of Dalotia and Other Organism
% This outputs for this function will be used for the createEllipses function

%% Inputs: rawDatafilt (output of filtInterp function)
%% Outputs: med_length, med_width, rawDatafiltSizes
% med_length and med_width are scalar values that take the median length
% and width from all the experiments (both top and mirror view experiments)
% rawDatafiltSizes is what is obtained before the step of getting
% the median, it is a cell column array of expnum rows, and each cell is a
% table with the following format
% frame_num (array) | dal_lengths (arr) | dal_widths (arr) | other_lengths (arr) | other_widths (arr)  
% note: the xlim for histograms are hard-coded to range from [0 100] pixels

%note: this is a modified version of Jonayet's "getSizes.m" code, modified
%by Jess Kanwal on 221021

function [med_dalLength, med_dalWidth, med_otherLength, med_otherWidth, rawDatafiltSizes] =...
    getSizes2(rawDatafilt, dalotiaHeadx, dalotiaHeady, dalotiaAb3x, dalotiaAb3y, ...
    otherHeadx, otherHeady, otherTailx, otherTaily, dal_lw_ratio, other_lw_ratio, otherOrg)


expnum = size(rawDatafilt, 1);
header = rawDatafilt{1,1}.Properties.VariableNames;
rawDatafiltSizes = cell(expnum, 1);

for i = 1:expnum
    
    % extract x,y coordinates of the head and tail position for each
    % organism
    dal_head_xy = [rawDatafilt{i,1}{:,dalotiaHeadx}, rawDatafilt{i,1}{:,dalotiaHeady}];
    dal_tail_xy = [rawDatafilt{i,1}{:,dalotiaAb3x}, rawDatafilt{i,1}{:,dalotiaAb3y}];

    other_head_xy = [rawDatafilt{i,1}{:,otherHeadx}, rawDatafilt{i,1}{:,otherHeady}];
    other_tail_xy = [rawDatafilt{i,1}{:,otherTailx}, rawDatafilt{i,1}{:,otherTaily}];
    
    % calculate length and width of each organism, width =  length * width/length
    dal_lengths = sqrt(sum(((dal_head_xy - dal_tail_xy).^2), 2));
    dal_widths = dal_lengths ./ dal_lw_ratio;

    other_lengths = sqrt(sum(((other_head_xy - other_tail_xy).^2), 2));
    other_widths = other_lengths ./ other_lw_ratio;

    %first col = frame num
    frame_nums = rawDatafilt{i,1}.Frame_Num;
    rawDatafiltSizes{i, 1} = table(frame_nums, dal_lengths, dal_widths, other_lengths, other_widths);

end

% get median size (length and width) values for each organism
sizes_allExpts = vertcat(rawDatafiltSizes{:});
med_dalLength = median(sizes_allExpts.dal_lengths, 1, 'omitnan');
med_dalWidth = median(sizes_allExpts.dal_widths, 1, 'omitnan');
med_otherLength = median(sizes_allExpts.other_lengths, 1, 'omitnan');
med_otherWidth = median(sizes_allExpts.other_widths, 1, 'omitnan');


% histogram plot of dal_lengths, dal_widths, other_lengths, and other_widths
figure
edges = [0:1:100];

subplot(2,2,1)
histogram(sizes_allExpts.dal_lengths, edges);
xlim([0,100]);
title('Dalotia Lengths Across Expts');

subplot(2,2,2)
histogram(sizes_allExpts.dal_widths, edges);
xlim([0,50]);
title('Dalotia Widths Across Expts');

subplot(2,2,3)
histogram(sizes_allExpts.other_lengths, edges);
xlim([0,100]);
titL = [otherOrg, ' Lengths Across Expts'];
title(titL);

subplot(2,2,4)
histogram(sizes_allExpts.other_widths, edges);
xlim([0,50]);
titW = [otherOrg, ' Widths Across Expts'];
title(titW);


