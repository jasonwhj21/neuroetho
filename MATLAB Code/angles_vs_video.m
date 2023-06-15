vidObj    = VideoReader('/Users/jasonwong/Projects/Beetle_Learning_BENTO/Annotations_to_match_with_Jess/Dal_Lio/220119_DalAnt_1daystrvd_run101.mp4');
angles = flexion(testSet);
frames = vidObj.NumFrames;
i = 1;
while hasFrame(vidObj)
   frame = readFrame(vidObj);
   imshow(frame)
   pause(0.5);
   disp(rad2deg(angles{1}.angles(i)));
   i = i+1;
end