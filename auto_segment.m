function [window detected_scale] = auto_segment(image,mean_image)

orig_image = image;
scales = 5;

% [340 460]
ff = [1.01:0.1:1.1];
%kk = [0.9:-0.02:0.1];

img = cell(1,scales);
temp = cell(1,length(ff));
dist_rec = zeros(1,3);
img_points = zeros(1,5);
%%%%%%%%%%%%%%%%%%Generation of scale-space%%%%%%%%%%%%%%%%%%%%%%

for jj = 1 : scales

    sigma0 = 0.7 * jj;

%img{jj} = imresize(image,1/ff(jj));

img{jj} =  smooth(image,sigma0);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for tmpl = 1 : length(ff)

    temp{tmpl} = imresize(mean_image,1/ff(tmpl),'bicubic');
    
 
[r2 c2] = size(temp{tmpl});
%r2 = 300 ; c2 = 400;
r_slide = 50 ; c_slide = 50;
[imheight imwidth]=size(img{jj});
R = floor((imheight-(r2-r_slide))/r_slide);%FOR THE CALCULATION OF NUMBER OF SLIDING ROWS
C = floor((imwidth-(c2-c_slide))/c_slide);%FOR THE CALCULATION OF NUMBER OF SLIDING COLUMNS

for kk = 1 : length(img)

    
for i=1:R
    for j=1:C
        r_start=((i-1)*r_slide)+1;%START ROW POINT OF WINDOW
        r_end=i*r_slide+(r2-r_slide);%END POINT OF ROW
        c_start=((j-1)*c_slide)+1;%START COLUMN POINT OF WINDOW
        c_end=j*c_slide+(c2-c_slide);%END POINT OF COLUMN
        H = img{kk}(r_start:r_end,c_start:c_end);
       %pos_dist=ncc_dis(temp{jj}(:),double(H(:)));
        pos_dist=corr2(temp{tmpl},H);
        

 V = (i - 1) * C + j;
 
 
 dist_rec(V,1) = pos_dist;
 dist_rec(V,2) = c_start;
 dist_rec(V,3) = r_start;
 
    end
end

 [val(kk),loc(kk)] = max(dist_rec(:,1));
 img_points(kk,1) = dist_rec(loc(kk),2);
 img_points(kk,2) = dist_rec(loc(kk),3);
 img_points(kk,3) = r2;
 img_points(kk,4) = c2;
 img_points(kk,5) = kk;
 clear dist_rec;
end
   [dd img_nos]  = max(val);
   image = img{img_nos}; 
   candidate_window(tmpl,1) = img_points(img_nos,1);        
   candidate_window(tmpl,2) = img_points(img_nos,2);
   candidate_window(tmpl,3) = img_points(img_nos,3);
   candidate_window(tmpl,4) = img_points(img_nos,4);
   candidate_window(tmpl,5) = dd;
   candidate_window(tmpl,6) = img_points(img_nos,5); 
clear img_points;
end
    [max_val max_win_loc] = max(candidate_window(:,5));
   
%    window = orig_image(candidate_window(max_win_loc,1) : candidate_window(max_win_loc,1) + candidate_window(max_win_loc,4),candidate_window(max_win_loc,2)...
%       : candidate_window(max_win_loc,2) + candidate_window(max_win_loc,3));
%   detected_scale = candidate_window(max_win_loc,6);
   
window = orig_image(candidate_window(max_win_loc,2): candidate_window(max_win_loc,2) + candidate_window(max_win_loc,3),...
    candidate_window(max_win_loc,1) : candidate_window(max_win_loc,1) + candidate_window(max_win_loc,4));
   detected_scale = candidate_window(max_win_loc,6);

   
   %    window = orig_image(candidate_window(7,1) : candidate_window(7,1) + candidate_window(7,4),candidate_window(7,2)...
%        : candidate_window(7,2) + candidate_window(7,3));
%    detected_scale = candidate_window(max_win_loc,6);
   imshow(window,[]);