%% Plot Dal and Other Organism Spatial Occupancy Maps
% 220526

function [il_B, il_nameB, il_M, il_nameM] = occupancyMaps(rawDatafilt, files, dalotiaAb1x, dalotiaAb1y, otherMidx, otherMidy, frameNum, otherOrg, outputPath)

%% Inputs

%number of experiments
expnum = size(rawDatafilt,1);

%histogram edges and bin width
sigma = 0.9;
binwidth= 10;

%histogram edges: actual dimensions width=340, height=850
Xedges = 0:binwidth:400;
Yedges = 0:binwidth:1000;

%histogram title font size
tFtSz = 10;

%rows and cols for subplots
r = 1;
c = 6;

% % Decide which bodypart to plot and simplify filename
% % col index of desired bodypart for Dal and larva
% dalotiaAb1x = 17;
% dalotiaAb1y = 18;
% otherMidx = 29;
% otherMidy = 30;
% frameNum = 1;

%colorbar colormap
cruzbay = interp1([1 51 102 153 204 256],...
    [0 0 0; 0 0 .75; 0 .6 .8; 0 .95 0; .85 1 0; 1 1 1],1:256);
colorspectrum = cruzbay;

% Normalization type of plots
normType = 'probability';

% simplified filenames
for i = 1:length(files)
    fileNames{i,1} = extractBefore(files(i).name,"DLC");
end

%% Plot Spatial Occupancy Maps

% setup vectors to calculate interaction level metric
% D = dal, X = otherOrg, B = base view, M = mirror view
il_DB = cell(expnum,1);
il_DM = cell(expnum,1);
il_XB = cell(expnum,1);
il_XM = cell(expnum,1);

% loop through all experiments and create occupancy maps for each
for i = 1:2:expnum

    % set-up fig. Pos = [left bottom width height]
    f = figure;
    f.Position = [800 300 1000 400];

    %% Dal Base (DB) subplot
    ax1 = subplot(r,c,1);

    % data to plot
    x_DB = rawDatafilt{i,1}{:,dalotiaAb1x};
    y_DB = rawDatafilt{i,1}{:,dalotiaAb1y};

    % occupancy map = histogram across space showing where Dal spent time
    % across duration of entire expt
    raw_om_DB = (flipud(histcounts2(y_DB, x_DB, Yedges, Xedges, 'Normalization', normType)));
    om_DB = imgaussfilt(raw_om_DB, sigma);
    il_DB{i} = om_DB(:);
    imagesc(om_DB); axis image;

    % colorbar
    ax = gca;
    colormap(ax,colorspectrum);
    %     colorbar

    % plot labels
    % set(gca, 'Color', 'w');
    xlabel('x-position', 'FontSize', tFtSz,'Color', 'w');
    ylabel('y-position', 'FontSize', tFtSz,'Color', 'w');
    title ({'Dalotia';'Top View'},'FontSize',tFtSz,'FontWeight','normal','Color', 'w');
    %     pbaspect([1 5 1]);

    set(gca, ...
        'LineWidth', 0.5,...
        'FontName', 'Arial',...
        'FontSize', tFtSz, ...
        'Box', 'on', ...
        'XTick', [], ...
        'YTick', []);
    % ax is axis handle
    ax.XRuler.Axle.Visible = 'off';
    ax.YRuler.Axle.Visible = 'off';


    %% Dal Mirror (DM) subplot
    ax4 = subplot(r,c,4);

    % data to plot
    z_DM = rawDatafilt{i+1,1}{:,dalotiaAb1x};
    y_DM = rawDatafilt{i+1,1}{:,dalotiaAb1y};

    % occupancy map
    raw_om_DM = (flipud(histcounts2(y_DM, z_DM, Yedges, Xedges, 'Normalization',normType)));
    om_DM = imgaussfilt(raw_om_DM, sigma);
    il_DM{i} = om_DM(:);
    imagesc(om_DM); axis image;

    % colorbar
    ax = gca;
    colormap(ax,colorspectrum);
    %     colorbar

    % plot labels
    % set(gca, 'Color', 'w');
    xlabel('z-position', 'FontSize', tFtSz,'Color', 'w');
    title ({'Dalotia';'Side View'},'FontSize',tFtSz,'FontWeight','normal','Color', 'w');
    %     pbaspect([1 5 1]);

    set(gca, ...
        'LineWidth', 0.5,...
        'FontName', 'Arial',...
        'FontSize', tFtSz, ...
        'Box', 'on', ...
        'XTick', [], ...
        'YTick', []);
    % ax is axis handle
    ax.XRuler.Axle.Visible = 'off';
    ax.YRuler.Axle.Visible = 'off';

    %% Other Organism (organism X) Base (XB) subplot
    ax2 = subplot(r,c,2);

    % data to plot
    x_XB = rawDatafilt{i,1}{:,otherMidx};
    y_XB = rawDatafilt{i,1}{:,otherMidy};

    % occupancy map
    raw_om_XB =(flipud(histcounts2(y_XB, x_XB, Yedges, Xedges, 'Normalization',normType)));
    om_XB = imgaussfilt(raw_om_XB, sigma);
    il_XB{i} = om_XB(:);
    imagesc(om_XB); axis image;

    % colorbar
    ax = gca;
    colormap(ax,colorspectrum);
    %     colorbar


    % plot labels
    % set(gca, 'Color', 'w');
    xlabel('x-position', 'FontSize', tFtSz,'Color', 'w');
    title ({otherOrg;'Top View'},'FontSize',tFtSz,'FontWeight','normal','Color', 'w');
    %     pbaspect([1 5 1]);

    set(gca, ...
        'LineWidth', 0.5,...
        'FontName', 'Arial',...
        'FontSize', tFtSz, ...
        'Box', 'on', ...
        'XTick', [], ...
        'YTick', []);
    % ax is axis handle
    ax.XRuler.Axle.Visible = 'off';
    ax.YRuler.Axle.Visible = 'off';

    %% Other Organism (organism X) Mirror (XM) subplot
    ax5 = subplot(r,c,5);

    % data to plot
    z_XM = rawDatafilt{i+1,1}{:,otherMidx};
    y_XM = rawDatafilt{i+1,1}{:,otherMidy};

    % occupancy map
    raw_om_XM =(flipud(histcounts2(y_XM, z_XM, Yedges, Xedges, 'Normalization',normType)));
    om_XM = imgaussfilt(raw_om_XM, sigma);
    il_XM{i} = om_XM(:);
    imagesc(om_XM); axis image;

    % colorbar
    ax = gca;
    colormap(ax,colorspectrum);
    %     colorbar

    % plot labels
    % set(gca, 'Color', 'k');
    xlabel('z-position', 'FontSize', tFtSz,'Color', 'w');
    title ({otherOrg;'Side View'},'FontSize',tFtSz,'FontWeight','normal','Color', 'w');
    % pbaspect([1 5 1]);

    set(gca, ...
        'LineWidth', 0.5,...
        'FontName', 'Arial',...
        'FontSize', tFtSz, ...
        'Box', 'on', ...
        'XTick', [], ...
        'YTick', []);
    % ax is axis handle
    ax.XRuler.Axle.Visible = 'off';
    ax.YRuler.Axle.Visible = 'off';


    %% Time Occupancy Maps: Dal*Other Base/Top Plot
    ax3 = subplot(r,c,3);

    % calculate scaler = 1/bin width
    % "-1" included to deal with an edge case where bin # exceeds max # of
    % bins after remapping. Note this makes edge bins 0.5 width of others,
    % so revisit and make better in future
    x_scaler = (length(Xedges)-1)/max(Xedges);
    y_scaler = (length(Yedges)-1)/max(Yedges);

    % dalotia data 
    x_dal = rawDatafilt{i,1}{:,dalotiaAb1x};
    y_dal = rawDatafilt{i,1}{:,dalotiaAb1y};

    % filter dal data such that values outside of X- or Y- edges range = nan
    filter_condition = (round(x_dal) <= 0) |...
        (round(y_dal) <= 0) | (round(x_dal) >= max(Xedges))...
        | (round(y_dal) >= max(Yedges));
    x_dal(filter_condition) = nan;
    y_dal(filter_condition) = nan;

    % rounding to get integar values that correspond to bin number
    x_remapped_dal = round(x_dal * x_scaler);
    y_remapped_dal = round(y_dal * y_scaler);

    % other organism data
    x_other = rawDatafilt{i,1}{:,otherMidx};
    y_other = rawDatafilt{i,1}{:,otherMidy};

    % filter other data such that values outside of X- or Y- edges range = nan
    filter_condition = (round(x_other) <= 0) |...
        (round(y_other) <= 0) | (round(x_other) >= max(Xedges))...
        | (round(y_other) >= max(Yedges));
    x_other(filter_condition) = nan;
    y_other(filter_condition) = nan;

    % rounding to get integar values that correspond to bin number
    x_remapped_other = round(x_other * x_scaler);
    y_remapped_other = round(y_other * y_scaler);

    % create matrix with # of bins along x and y, and time along z
    mat = zeros(length(Yedges), length(Xedges), length(x_dal));
    
    for jj = 1:length(x_dal)
        if mod(jj,1000) == 0
            disp(jj)
        end

        if ~isnan(x_remapped_dal(jj)) && ~isnan(x_remapped_other(jj))
            mat_temp = mat(:,:,jj);
            mat_temp(y_remapped_dal(jj)+1,x_remapped_dal(jj)+1) = 1;
            mat_dal = imgaussfilt(mat_temp,sigma);

            mat_temp = mat(:,:,jj);
            mat_temp(y_remapped_other(jj)+1,x_remapped_other(jj)+1) = 1;
            mat_other = imgaussfilt(mat_temp,sigma);

            mat(:,:,jj) = flipud(mat_dal .* mat_other);
        else
            continue
        end
    end

    final_map = mean(mat,3);
    imagesc(final_map); axis image;

    %colorbar, set min displayed color = 0
    ax = gca;
    colormap(ax,colorspectrum);
    lim = caxis;
    caxis([0 lim(2)]);
    %     colorbar

    % plot labels
    xlabel('x-position', 'FontSize', tFtSz,'Color', 'w');
    title ({['Dal*',otherOrg];'Top View'},'FontSize',tFtSz,'FontWeight','normal','Color', 'w');
    % pbaspect([1 5 1]);

    set(gca, ...
        'LineWidth', 0.5,...
        'FontName', 'Arial',...
        'FontSize', tFtSz, ...
        'Box', 'on', ...
        'XTick', [], ...
        'YTick', []);


    %% Time Occupancy Maps: Dal*Other Mirror/Side Plot
    ax6 = subplot(r,c,6);

    % calculate scaler = 1/bin width
    x_scaler = (length(Xedges)-1)/max(Xedges);
    y_scaler = (length(Yedges)-1)/max(Yedges);

    % dalotia data
    x_dal = rawDatafilt{i+1,1}{:,dalotiaAb1x};
    y_dal = rawDatafilt{i+1,1}{:,dalotiaAb1y};

    % filter dal data such that values outside of X- or Y- edges range = nan
    filter_condition = (round(x_dal) <= 0) |...
        (round(y_dal) <= 0) | (round(x_dal) >= max(Xedges))...
        | (round(y_dal) >= max(Yedges));
    x_dal(filter_condition) = nan;
    y_dal(filter_condition) = nan;

    % rounding to get integar values that correspond to bin number
    x_remapped_dal = round(x_dal * x_scaler);
    y_remapped_dal = round(y_dal * y_scaler);
 
    % other organism data
    x_other = rawDatafilt{i+1,1}{:,otherMidx};
    y_other = rawDatafilt{i+1,1}{:,otherMidy};

    % filter other data such that values outside of X- or Y- edges range = nan
    filter_condition = (round(x_other) <= 0) |...
        (round(y_other) <= 0) | (round(x_other) >= max(Xedges))...
        | (round(y_other) >= max(Yedges));
    x_other(filter_condition) = nan;
    y_other(filter_condition) = nan;

    % rounding to get integar values that correspond to bin number
    x_remapped_other = round(x_other * x_scaler);
    y_remapped_other = round(y_other * y_scaler);

    % create matrix with # of bins along x and y, and time along z
    mat = zeros(length(Yedges), length(Xedges), length(x_dal));

    % for every timepoint, determine overlap in Dal & otherOrg position
    for jj = 1:length(x_dal)

        % display timer as processing
        if mod(jj,10000) == 0
            disp(jj)
        end

        if ~isnan(x_remapped_dal(jj)) && ~isnan(x_remapped_other(jj))
            mat_temp = mat(:,:,jj);
            mat_temp(y_remapped_dal(jj)+1, x_remapped_dal(jj)+1) = 1;
            mat_dal = imgaussfilt(mat_temp, sigma);

            mat_temp = mat(:,:,jj);
            mat_temp(y_remapped_other(jj)+1, x_remapped_other(jj)+1) = 1;
            mat_other = imgaussfilt(mat_temp, sigma);

            mat(:,:,jj) = flipud(mat_dal .* mat_other);
        else
            continue
        end
    end

    final_map = mean(mat,3);
    imagesc(final_map); axis image;

    %colorbar, set min displayed color = 0
    ax = gca;
    colormap(ax,colorspectrum);
    lim = caxis;
    caxis([0 lim(2)]);
    %     colorbar

    % plot labels
    xlabel('z-position', 'FontSize', tFtSz,'Color', 'w');
    title ({['Dal*',otherOrg];'Side View'},'FontSize',tFtSz,'FontWeight','normal','Color', 'w');
    % pbaspect([1 5 1]);

    set(gca, ...
        'LineWidth', 0.5,...
        'FontName', 'Arial',...
        'FontSize', tFtSz, ...
        'Box', 'on', ...
        'XTick', [], ...
        'YTick', []);


    %% final plot settings: add filename title & set black background
    sgtitle([fileNames{i},'  &  ', fileNames{i+1}],...
        'FontSize',8,'FontWeight','normal','Interpreter', 'none');
    whitebg('black');
    set(gcf, 'InvertHardCopy', 'off');
    set(gcf, 'Color', 'k');

    % save as tif and fig
    filename = [fileNames{i},['_DalAb1_', otherOrg,'Mid_OM']];
    saveas(gcf,fullfile(outputPath, filename),'tif');
    saveas(gcf,fullfile(outputPath, filename),'fig');

end



%% Quantify "interaction level" metric distributions

% remove empty cells from each array
il_DB =il_DB(~cellfun(@isempty,il_DB));
il_DM =il_DM(~cellfun(@isempty,il_DM));
il_XB =il_XB(~cellfun(@isempty,il_XB));
il_XM =il_XM(~cellfun(@isempty,il_XM));

% calculate "interaction level" metric each expt.
%interaction level (il) = sum of [multiplication of linearized Dal and Lar
%matrices]
for j = 1:length(il_DB)
    il_B(j,1) = sum(il_DB{j,1} .* il_XB{j,1});
    il_M(j,1) = sum(il_DM{j,1} .* il_XM{j,1});
end

il_nameB = ['il_Dal',otherOrg, '_B'];
il_nameM = ['il_Dal',otherOrg, '_M'];

end
