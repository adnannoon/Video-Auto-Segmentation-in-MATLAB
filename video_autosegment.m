%video=aviread('MOV003.avi',[10:4:1000]);
 vid = mmreader('MOV003.avi');
% % mov(k).cdata = read(video, 1);
% count = 1;
 for i = 5 :20:9001 
     video(i).cdata = read(vid, i);
 
     %imshow(video(i).cdata,[]);
     %pause(.01);
     [window detected_scale] = auto_segment(im2double(rgb2gray(video(i).cdata)),avg);
     
     pause(0.025);
 end
 
%bg_gray=rgb2gray(video(1).cdata); % converting RGB to gray
%frame_size=size(bg_gray);
%height=frame_size(1); 
%width=frame_size(2);
%length=size(video,2);
