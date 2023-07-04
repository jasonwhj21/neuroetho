str = '_filtered.csv';
path = '/Users/jasonwong/Projects/Beetle_Learning_MATLAB/Non_Ant_CSVs'
folders = dir([path,'/','Dal_*']);
% load('/Users/jasonwong/Projects/Beetle_Learning_BENTO/Annotations_to_match_with_Jess/Dal_Solenopsis_2/Solenopsis_2Filt.mat');
% curves = curvature_circles(rawDatafilt);
% distances = distance(rawDatafilt);
% velocity = velocities2(rawDatafilt);
% interactions = readmatrix([path, '/Dal_Solepnosis/Test_Experiment_DalFormica2.annot'], 'FileType','text');
% save(outputpath,'curves','distances','velocity','-v7.3')
% which = [1];
num_folders = size(folders,1);
for i = 1:num_folders
    
     organism = folders(i).name
     org_folder = [folders(i).folder,'/',organism];
    
%       [rawData,files] = concatinate(org_folder, str);
     load([org_folder,'/',organism,'XY'])
     load([org_folder,'/',organism,'XYLin'])
%          [rawDatafilt, rawDatafiltlin] = filtInterp(rawData, files, 0.7);
  
     app_angle = approach_angle(rawDatafilt);
     app_anglelin = approach_angle(rawDatafiltlin);


%     outputpath = [path,'/',organism,'/',organism,'XY'];
%     save(outputpath,'rawDatafilt','-v7.3');
%     outputpath1 = [path,'/',organism,'/',organism,'XYLin'];
%     save(outputpath1,'rawDatafiltlin','-v7.3');
    outputpath2 = [path,'/',organism,'/',organism,'app_angle'];
    save(outputpath2,'app_angle','app_anglelin','-v7.3');
    
end
