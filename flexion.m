function dalFlexAngles = flexion(rawDatafilt)
expnum = size(rawDatafilt, 1);

dalFlexAngles = cell(expnum/2, 1);   % cell array to return
fps = 60;
frame2time = (1/fps); %Time conversion from frames to seconds
for i = 1:2:expnum
    data = rawDatafilt{i, 1};
    rows = size(data, 1);
    frame_nums = [1:rows]';
    time_col = frame_nums * frame2time;     % time column
    angles = zeros(rows,1);
    Abd1 = [rawDatafilt{i,1}.DalotiaAbdomen1_x, rawDatafilt{i,1}.DalotiaAbdomen1_y, rawDatafilt{i+1,1}.DalotiaAbdomen1_x];
    Ely = [rawDatafilt{i,1}.DalotiaElytra_x, rawDatafilt{i,1}.DalotiaElytra_y, rawDatafilt{i+1,1}.DalotiaElytra_x];
    Abd3 = [rawDatafilt{i,1}.DalotiaAbdomen3_x, rawDatafilt{i,1}.DalotiaAbdomen3_y, rawDatafilt{i+1,1}.DalotiaAbdomen3_x];
      %calculate abdomen flexion angle
    vDB = Ely - Abd1;
    uDB = Abd3 - Abd1;
%     vDB(isnan(vDB)) = 0;
%     uDB(isnan(uDB)) = 0;
    for j = 1:rows
        dotted = dot(vDB(j,:), uDB(j,:))/(vecnorm(vDB(j,:))* vecnorm(uDB(j,:)));
        angles(j) = acos(dotted);
        %if any(isnan([Abd1(j,:),Ely(j,:),Abd3(j,:)]))
        %    angles(j) = NaN;
        %end
    end
    
    dalFlexAngles{ceil(i/2),1} = table(time_col, angles, Ely,Abd1, Abd3);
end
