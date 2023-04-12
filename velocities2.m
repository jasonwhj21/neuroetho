
%% inputs: rawDatafilt 
% a column cell array, where each cell is a table containing frame
% nums, and x,y coordinates of each body part and their likelihoods for both organisms

% ex: otherOrg = 'Dmel';

%% outputs:rawDatafiltVelocities, medianVelocities
% a cell array with same format as rawDatafiltVelocities but each cell is a
% table with one column as the frame nums, the second column as the current
% time in the frame and the next two columns as the instantaneous velocities 
% of both insects in each frame. First row is padded with NaNs for
% velocities (columns 3 and 4)

% time_col(array)   dalotia_velocities(arr)    other_velocities(arr)

% medianVelocities is a table with expnum rows, second column is the median
% velocity at each experiment for dalotia, and third column is for other,
% rows are alternating between top and mirror experiments. first col is
% experiment number

% medianVelocities
% experiment_num(array)     dal_median_velocities(arr)     other_median_velocities(arr)


function [rawDatafiltVelocities, medianVelocities, otherVel] = velocities(rawDatafilt, otherOrg)

expnum = size(rawDatafilt, 1);
header = rawDatafilt{1,1}.Properties.VariableNames;

experiment_num = [1:expnum]';          % for medianVelocities table

dalAbdXIdx = contains(header, 'DalotiaAbdomen1_x');
dalAbdYIdx = contains(header, 'DalotiaAbdomen1_y');

otherMidXIdx = contains(header, 'AntThorax_x');
otherMidYIdx = contains(header, 'AntThorax_y');

rawDatafiltVelocities = cell(expnum, 1);    % cell array to return

% frame to min conversion: eg, (1 sec/60 frames)*(1 min/60 sec)=time in min
fps = 60;
frame2time = (1/fps) * (1/60); %


for i = 1:expnum
    data = rawDatafilt{i, 1};
    rows = size(data, 1);
    frame_nums = [1:rows]';
    time_col = frame_nums * frame2time;     % time column
    
    dalotia_velocities(rows,1) = 0; % padding last row with 0s
    other_velocities(rows,1) = 0;
    

%     sprintf('Line 54: %u', i)
    
    % cell indexing all at once bc cell indexing takes time (in for loop)
    dal_positions_x = data{:, dalAbdXIdx};
    dal_positions_y = data{:, dalAbdYIdx};
    other_positions_x = data{:, otherMidXIdx};
    other_positions_y = data{:, otherMidYIdx};

    for j = 1:rows-1
        
        dal_pos1 = [dal_positions_x(j) dal_positions_y(j)];
        dal_pos2 = [dal_positions_x(j + 1) dal_positions_y(j+1)];
        
        other_pos1 = [other_positions_x(j) other_positions_y(j)];
        other_pos2 = [other_positions_x(j + 1) other_positions_y(j+1)];
        
        dal_disp = sqrt( (dal_pos2(1,1) - dal_pos1(1,1))^2 + (dal_pos2(1,2) - dal_pos1(1,2))^2);
        other_disp = sqrt( (other_pos2(1,1) - other_pos1(1,1))^2 + (other_pos2(1,2) - other_pos1(1,2))^2);
    
        time_elapsed = time_col(j + 1, 1) - time_col(j, 1);
        
        dal_velocity = dal_disp / time_elapsed;
        other_velocity = other_disp / time_elapsed;
        
        dalotia_velocities(j, 1) = dal_velocity;
        other_velocities(j, 1) = other_velocity;
    end
    
    dal_median_velocities(i, 1) = median(dalotia_velocities, 'omitnan');
    other_median_velocities(i, 1) = median(other_velocities, 'omitnan');
    
    rawDatafiltVelocities{i, 1} = table(time_col, dalotia_velocities, other_velocities);

    clear dalotia_velocities
    clear other_velocities
end
% disp('Line 91')
% medianVelocities has, for each experiment, the average/median velocity of
% the organisms
medianVelocities = table(experiment_num, dal_median_velocities, other_median_velocities);

% %% Calculate average of median velocities for insect features plot
% 
% extractedotherVels = medianVelocities{:, 3};
% otherVel = mean(extractedotherVels, 'omitnan');
% 
% 
% %%  Plot histogram of velocities
% 
% % extract median velocities
% 
% velHeader = medianVelocities.Properties.VariableNames;
% dalMedVelIDX = contains(velHeader, 'dal_median_velocities');
% otherMedVelIDX = contains(velHeader, 'other_median_velocities');
% 
% % plot histograms
% f = figure;
% nbins = 24;
% subplot(1,2,1)
% % b1 = bar(medianVelocities{:, dalMedVelIDX},'EdgeColor','k','LineWidth',3);
% b1 = histogram(medianVelocities{:, dalMedVelIDX},nbins,'EdgeColor','k','LineWidth',1,...
%  'FaceColor', [0.1 0.1 0.1],'FaceAlpha',.4);
% %'FaceColor', [1 0 0],'FaceAlpha',.4);
%   
% title(['Dalotia + ', otherOrg, ' : Dalotia Median Velocities Across Experiments']);
% 
% 
% %pretty figure settings
%     %offsetAxes(gca);
%     set(gca, ...
%         'LineWidth', 3,...
%         'XColor', 'k',...
%         'YColor', 'k',...
%         'FontName', 'Arial',...
%         'FontSize', 14,...
%         'Box', 'off');
%     set(gca, 'Color', 'w');
%     set(gcf, 'Color', 'w');
% 
% %     xlim([0 2600]);
% %     ylim([0 14]);
% 
%           
% subplot(1,2,2)
% % b2 = bar(medianVelocities{:, otherMedVelIDX},'EdgeColor','k','LineWidth',3); 
% b2 = histogram(medianVelocities{:, otherMedVelIDX}, nbins,'EdgeColor','k','LineWidth',1,... ...
%  'FaceColor', [0.1 0.1 0.1],'FaceAlpha',.4 );
% %'FaceColor', [1 0 0],'FaceAlpha',.4);
%   
% title(['Dalotia + ', otherOrg, ' : ', otherOrg, ' Median Velocities Across Experiments']);    
% 
% 
% %pretty figure settings
%     %offsetAxes(gca);
%     set(gca, ...
%         'LineWidth', 3,...
%         'XColor', 'k',...
%         'YColor', 'k',...
%         'FontName', 'Arial',...
%         'FontSize', 14,...
%         'Box', 'off');
%     set(gca, 'Color', 'w');
%     set(gcf, 'Color', 'w');
% 
% %     xlim([0 6500]);
% %     ylim([0 14]);
% 
% ax (1) = subplot(1,2,1);
% ax (2) = subplot(1,2,2);
% %linkaxes(ax, 'xy');
% linkaxes(ax, 'y');
% 
% 
% filename = ['Dalotia and',' ', otherOrg, ' Median Velocities'];
% % saveas(f, fullfile(outputPath, filename),'fig');
% end
% 
% % if speed of program becomes a problem, then preallocate arrays and cell
% % arrays