%% Plot Dal abdomen flexion
%  220618

function abdflexBall(rawData, files, outputPath)

%% Inputs

%number of experiments
expnum = size(rawData,1);

% columns of bodyparts
dalotiaElyx = 14;
dalotiaElyy = 15;
dalotiaAb1x = 17;
dalotiaAb1y = 18;
dalotiaAb3x = 23;
dalotiaAb3y = 24;
frameNum = 1;

% %rows = # of parameters, %cols = 1
% r = 2;
% c = 1;

% %subplot number
% plotNum = r*c;
%
% if fps = 60
% frame2time = (1/60) * (1/60); %(1 sec/60 frames)*(1 min/60 sec)=time in min

%simplified filenames
for i = 1:length(files)
    fileNames{i,1} = extractBefore(files(i).name,"DLC");
end

% how much to smooth, how much t offset the plot (beta)
% k = 31;
% beta = 20;

% temp solution to plotting stim delivery time
%percent of expt duration at which stim onsets occurred (manualy determined
%from o_loop_motor files)
%below used for data prior to 6/27
% stim_onset_percent = [0.083; 0.333; 0.583; 0.833];
% stim_offset_percent = [0.167; 0.417; 0.667; 0.917];

% %used for 6/27 data set 1
% stim_onset_percent = [0.334];
% stim_offset_percent = [0.665];

% %used for 6/27 all other data dets
% stim_onset_percent = [0.167; 0.666];
% stim_offset_percent = [0.333; 0.833];

%used for 6/29
stim_onset_percent = [0.167; 0.500; 0.834];
stim_offset_percent = [0.250; 0.584; 0.917];

%% Plot Abdomen Flexion

for i = 21:26%expnum
    fig = figure;

    %position = [left bottom width height]
    fig.Position = [300 300 1400 400];

    % group x,y coordinates for relevant body parts
    Ely = [rawData{i,1}{:,dalotiaElyx}, rawData{i,1}{:,dalotiaElyy}];
    Abd1 = [rawData{i,1}{:,dalotiaAb1x}, rawData{i,1}{:,dalotiaAb1y}];
    Abd3 = [rawData{i,1}{:,dalotiaAb3x}, rawData{i,1}{:,dalotiaAb3y}];

    %calculate abdomen flexion angle
    vDB = Ely - Abd1;
    uDB = Abd3 - Abd1;

    % thetaDB = atan2(norm(cross(vDB,uDB)), dot(vDB,uDB));
    thetaDB = acosd(dot(vDB, uDB,2) ./ (vecnorm(vDB,2,2) .* vecnorm(uDB,2,2)));
    % tDB = rawData{i,1}{:,frameNum} * frame2time;
    tDB = rawData{i,1}{:,frameNum};

    % k  = window length for filtering, filter data and time vectors
%     k = 31;
    k = 10;
    thetaDBfilt = movmedian(thetaDB,k,1);
    tDBfilt = movmedian(tDB,k,1);


    %get axis limits
    beta = 20;
    ylim([(min(thetaDBfilt)- beta) 190]);
    yLimits = get(gca,'YLim');


    % plot patch of interaction times
    for j = 1:length(stim_onset_percent)
        stim_on = length(tDB) * stim_onset_percent(j);
        stim_off = length(tDB) * stim_offset_percent(j);
        v = [stim_on 0; stim_off 0; stim_off yLimits(2); stim_on yLimits(2)];
        f = [1 2 3 4];
        patch('Faces',f,'Vertices',v,'FaceColor','red', 'FaceAlpha',0.25, 'LineStyle', 'none');
        hold on;
    end

    % plot Dalotia abdomen flexion
    %   ax1 = subplot(r,c,1);
    alpha = .2; sz = 2;
    fDB = scatter(tDB, thetaDB, sz, 'filled','MarkerFaceColor', [.5,.5,.5],'MarkerFaceAlpha', alpha);
    hold on
    plot(tDBfilt, thetaDBfilt,'-','color','k','LineWidth', 1.5);
    ylim([(min(thetaDBfilt)- beta) 190]);

    %     ax2 = subplot(r,c,2);
    %     alpha = .2; sz = 2;
    %     fDB = scatter(tDB, thetaDB, sz, 'filled','MarkerFaceColor', [.5,.5,.5],'MarkerFaceAlpha', alpha);
    %     hold on
    %     plot(tDB, thetaDB,'-','color','r','LineWidth', 1);
    %     beta = 20;
    %     ylim([(min(thetaDBfilt)- beta) 190]);


    % plot labels
    set(gca, 'Color', 'w');
    % xlabel('Time(min)', 'FontSize', 14);
    xlabel('Frame Number', 'FontSize', 14);
    ylabel({'Abdomen Flexion', '(deg)'}, 'FontSize', 10);
    xlim([0 max(tDB)]);
    ylim([0 190]);
    offsetAxes(gca);
    set(gca, ...
        'LineWidth', 1.5,...
        'XColor', 'k',...
        'YColor', 'k',...
        'FontSize', 10,...
        'Box', 'off',...
        'FontName', 'Arial');

    % add filename title
    sgtitle([fileNames{i}],'FontSize',12,'FontWeight','normal','Interpreter', 'none');

    clear Ely Abd1 Ab3

    %save as tiff and fig formats
    filename = [fileNames{i},'_abdflx'];
    saveas(fig,fullfile(outputPath, filename),'tif');
    saveas(fig,fullfile(outputPath, filename),'fig');

end

end







%% how I calculated stim_onsett and offset from o_loop_motor_ file
% a = logical(servoData{i,1}.servo_0Position_deg_);
% ind = find(diff(a) == 1);
% stim_onset = ind/length(a);
% 
% ind = find(diff(a) == -1);
% stim_offset = ind/length(a);

%%another approach i had started messing around with for fixing timing
% issue...note, not fucntional
% dt = caldiff(servoData{1,1}{:,1}) %sec/frame
% a = time(dt);
% sec = seconds(a);
% avg_sec_per_frame = mean(frame_diff); %avergae sec per frame
% frame_num * sec_per_frame
% 
% expt_time = time(servoData{i,1}{:,1});
% plot(, servoData{i,1}.servo_0Position_deg_)



%%


%     %%
%     %find times when Dal-larv interact
%     % boolean array of indices when interactions occur(1=interacting, 0=not)
%     intInd = distT;
%     intInd = distT < interDist;
%     
%     % find start and end time of interactions (1=start, -1=end)
%     diffInd = diff(intInd);
%     
%     %insert 0 at beg of array to aligns with time/frame num array
%     diffInd = [0; diffInd];
%     startInd = find(diffInd == 1);
%     endInd = find(diffInd == -1);
%     
%     %if D starts <intInd, will cause endInd to have extra value
%     % add new first element to startInd = 0
%     if(length(endInd) > length(startInd))
%         startInd = [1; startInd]; %adds zero to first element
%     end
%     
%     %if D ends <intInd, will cause startInd to have extra value
%     %add new element to end of endInd = end index of recording
%     if(length(startInd) > length(endInd))
%         endInd = [endInd; length(diffInd)]; %adds last expt indx last value
%     end
%     
%     %duration of interaction times
%     durInt = endInd - startInd;
%     durIntTime = durInt * frame2time;
%     
%     %clean up data: interactions must be at least 3 seconds long
%     %if durInt <18(minIntfrmaes), remove that indx from start and endInd
%     for ii = 1: length(durInt)
%         if(durInt(ii) < minIntFrames)
%             startInd(ii) = NaN;
%             endInd(ii) = NaN;
%         end
%     end
%     
%     %remove nan values in start/endInd
%     startInd(isnan(startInd)) = [];
%     endInd(isnan(endInd)) = [];
%     
%     %recalculate duration of interactin times after clean up
%     %duration of interaction times
%     durInt = endInd - startInd;
%     durIntTime = durInt * frame2time;
%     
%     
%     % Plot distance between animals over time (patches show interaction times)
%     plot(tT, distT,'--.','color','k');
%     yLimits = get(gca,'YLim');
%     
%     hold on
%     
%     % plot patch of interaction times
%     for j = 1:length(startInd)
%         v = [tT(startInd(j)) 0; tT(endInd(j)) 0; tT(endInd(j)) yLimits(2); tT(startInd(j)) yLimits(2)];
%         f = [1 2 3 4];
%         patch('Faces',f,'Vertices',v,'FaceColor','red', 'FaceAlpha',0.3, 'LineStyle', 'none');
%         hold on;
%     end
%     
%     % plot labels
%     set(gca, 'Color', 'w');
%     %     xlabel('Time (min)', 'FontSize', 14);
%     ylabel({'Euclidean Distance', 'Between Insects (pixels)'}, 'FontSize', 10);
%     %     title ('Total Euclidean Distance','FontSize',16,'FontWeight','normal');
%     xlim([0 max(tT)]);
%     offsetAxes(gca);
%     set(gca, ...
%         'LineWidth', 1.5,...
%         'XColor', 'k',...
%         'YColor', 'k',...
%         'FontSize', 10,...
%         'Box', 'off',...
%         'FontName', 'Arial');
%     
%     
%     % Dal-Lar speed subplot
%     ax6 = subplot(r,c,6);
%     deltaDistD = sqrt(sum(((diff(dalAbd1T)).^2),2));
%     deltaDistL = sqrt(sum(((diff(larMidT)).^2),2));
%     deltaT = diff(tT);
%     velD = deltaDistD ./deltaT;
%     velL = deltaDistL ./deltaT;
%     %k  = window length for filtering
%     k = 60;
%     velDfilt = movmedian(velD,k,1);
%     velLfilt = movmedian(velL,k,1);
%     tTfilt = movmedian(tT(2:end),k,1);
%     
%     plot(tTfilt, velDfilt,'.-','color',[5/255, 48/255, 97/255],'LineWidth', 0.5);
%     hold on
%     plot(tTfilt, velLfilt,'.-','color',[202/255, 0/255, 32/255], 'LineWidth', 0.5);
%     %     plot(tT(2:end), velD,'.-','color','blue');
%     %     hold on
%     %     plot(tT(2:end), velL,'.-','color','magenta');
%     
%     % plot labels
%     set(gca, 'Color', 'w');
%     xlabel('Time (min)', 'FontSize', 10);
%     ylabel({'Velocity', '(pixels / min)'}, 'FontSize', 10);
%     legend('Dalotia','Ant');
%     %     title ('Side View','FontSize',16,'FontWeight','normal');
%     xlim([0 max(tT)]);
%     legend boxoff
%     offsetAxes(gca);
%     set(gca, ...
%         'LineWidth', 1.5,...
%         'XColor', 'k',...
%         'YColor', 'k',...
%         'FontSize',10,...
%         'Box', 'off',...
%         'FontName', 'Arial');
%     
%     sgtitle([fileNames{i},'  &  ', fileNames{i+1}],'FontSize',8,'FontWeight','normal','Interpreter', 'none');
%     set(gcf, 'Color', 'w');
%     
%                 %save as tif optional
%                 %fname = '/Volumes/Parker_lab/JessK/Behavior/HungryHallway/DLC Analysis/DalLarvCorridor-Jess-2021-08-31_postAnalysis/Trajectories/';
%                 fname = 'Z:\JessK\Behavior\HungryHallway\DLC Analysis\DalAnt-JessDavid-2022-02-03_postAnalysis\summary_stats';
%                 filename = [fileNames{i},'_SummaryStats'];
%                 saveas(gcf,fullfile(fname, filename),'tif');
%                 saveas(gcf,fullfile(fname, filename),'fig');
%     
% end
