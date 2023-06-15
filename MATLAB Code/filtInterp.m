%% Filter and linearly interpolate all loc data based on likelihood cut-off 
% 220526

% outputs: rawDatafilt and rawDatafiltlin


function [rawDatafilt, rawDatafiltlin] = filtInterp(rawData, files, lhcut)

%% Inputs
%make a new filtered (and a lin interpolated) rawData cell array
rawDatafilt = rawData;
rawDatafiltlin = rawData;

%number of experiments
expnum = size(rawData,1);

%number of bodyparts (bp) -- assumes every expt has same # of bp
% works by finding the # of bodyparts that include "_likelihood"
header = rawData{1,1}.Properties.VariableNames';
index = find(contains(header,'_likelihood'));
bpnum = length(index);

%calculate number of cols within a table
colNum = size(header,1);

%% replace (x,y) with LH<cutoff with NaN and linearly interpolate to fill NaN
%create two versions with NaN and one with linear interpolation

for i = 1:expnum
    %assumes organized as bp_x, bp_y,bp_likelihood
    for j = 2:3:colNum        
        %replace x(@j pos),y(@j+1 pos) values below lhcut(@j+2 pos) with NaN
        rawDatafilt{i,1}(rawDatafilt{i,1}{:, (j+2)} < lhcut, j) = {NaN};
        rawDatafilt{i,1}(rawDatafilt{i,1}{:, (j+2)} < lhcut, (j+1)) = {NaN};
    end
    
        %linearly interpolate to fill NaNs
        % automatically interpolates along col for tables
        rawDatafiltlin{i,1} = fillmissing(rawDatafilt{i,1},'linear');    
end

end

