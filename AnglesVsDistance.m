load('Beetle_Learning_MATLAB/DalAnt_wt/xyDataFilt_wtOrcoDalLioAnt.mat');
testSet = rawDatafilt(1:2);
angles = flexion(testSet);
distance = distance(testSet);
