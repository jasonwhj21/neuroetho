function app_angle = approach_angle(rawDatafilt)
expnum = size(rawDatafilt, 1);

dalFlexAngles = cell(expnum/2, 1);   % cell array to return
fps = 60;
frame2time = (1/fps); %Time conversion from frames to seconds
for i = 1:2:expnum
    data = rawDatafilt{i, 1};
    rows = size(data, 1);
    frame_nums = [1:rows]';
    time_col = frame_nums * frame2time;     % time column
    app_angles_mid = zeros(rows,1);
    app_angles_head = zeros(rows,1);
    Head = [rawDatafilt{i,1}.DalotiaHead_x, rawDatafilt{i,1}.DalotiaHead_y, rawDatafilt{i+1,1}.DalotiaHead_x];
    Ely = [rawDatafilt{i,1}.DalotiaElytra_x, rawDatafilt{i,1}.DalotiaElytra_y, rawDatafilt{i+1,1}.DalotiaElytra_x];
    Other_mid = [rawDatafilt{i,1}.OtherMid_x, rawDatafilt{i,1}.OtherMid_y, rawDatafilt{i+1,1}.OtherMid_x];
    Other_head = [rawDatafilt{i,1}.OtherHead_x, rawDatafilt{i,1}.OtherHead_y, rawDatafilt{i+1,1}.OtherHead_x];
      %calculate abdomen flexion angle
    vDB = Head - Ely;
    uDB = Other_mid - Ely;
    uDB2 = Other_head - Ely;
%     vDB(isnan(vDB)) = 0;
%     uDB(isnan(uDB)) = 0;
    for j = 1:rows
        dotted = dot(vDB(j,:), uDB(j,:))/(vecnorm(vDB(j,:))* vecnorm(uDB(j,:)));
        dotted2 = dot(vDB(j,:), uDB2(j,:))/(vecnorm(vDB(j,:))* vecnorm(uDB2(j,:)));
        app_angles_mid(j) = acos(dotted);
        app_angles_head(j) = acos(dotted2);
        %if any(isnan([Abd1(j,:),Ely(j,:),Abd3(j,:)]))
        %    angles(j) = NaN;
        %end
    end
    
    app_angle{ceil(i/2),1} = table(time_col, app_angles_mid,app_angles_head, Head, Ely, Other_mid, Other_head);
end
