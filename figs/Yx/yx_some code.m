
% imageDtabase= imageSet('',recursive);

%% try
chicken = imread('image_0001.jpg');
chicken = imresize(chicken, [480 NaN]);
chicken2 = imadjust(chicken,stretchlim(chicken));
chicken3 = decorrstretch(chicken,'Tol',0.01);

level = 0.44;
bwchicken = im2bw(chicken3,level);
chicken_single = single(chicken3);

chickenb = imread('image_0002.jpg');
chickenb = imresize(chickenb, [480 NaN]);
chicken2b = imadjust(chickenb,stretchlim(chicken));

chicken3b = decorrstretch(chickenb,'Tol',0.01);

level = 0.44;
bwchickenb = im2bw(chicken3b,level);
chicken_singleb = single(chicken3b);

[fa,da] = vl_sift(chicken_single);
[fb,db] = vl_sift(chicken_singleb);
[matches, scores] = vl_ubcmatch(da, db) ;

figure,imshow(chicken3);

perm = randperm(size(fa,2)) ;
sel = perm(1:50) ;
h1 = vl_plotframe(fa(:,sel)) ;
h2 = vl_plotframe(fa(:,sel)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;
h3 = vl_plotsiftdescriptor(da(:,sel),fa(:,sel)) ;
set(h3,'color','g') ;

figure,imshow(chicken3b);
permb = randperm(size(fb,2)) ;
selb = permb(1:50) ;
h1b = vl_plotframe(fb(:,selb)) ;
h2b = vl_plotframe(fb(:,selb)) ;
set(h1b,'color','k','linewidth',3) ;
set(h2b,'color','y','linewidth',2) ;
h3b = vl_plotsiftdescriptor(db(:,selb),fb(:,selb)) ;
set(h3b,'color','g') ;

 %% Gaussian noise and filter 
 a = imread('image_0001.jpg');
 a = decorrstretch(a,'Tol',0.01);
 an = imnoise(a,'gaussian',0.01);
 figure,imshow(a);
 % figure,imshow(an);
 
 sigma =4 ;
 cutoff = ceil(3*sigma);
 h = fspecial('gaussian',2*cutoff+1,sigma);
 out = conv2(an,h,'same');
 % figure,imshow(out/256);
 w = wiener2(an,[5,5]);
 figure,imshow(w);
 % surf(1:2*cutoff+1,1:2*cutoff+1,h);
 
%% Detect Feature Points
a = imread('image_0001.jpg');
a = imresize(a, [480 NaN]);
a = decorrstretch(a,'Tol',0.01);
b = imread('image_0002.jpg');
b = imresize(b, [480 NaN]);
b = decorrstretch(b,'Tol',0.01);
boxPoints = detectSURFFeatures(a);
scenePoints = detectSURFFeatures(b);
figure;
imshow(a);
title('100 Strongest Feature Points from Box Image');
hold on;
plot(selectStrongest(boxPoints, 100));
figure;
imshow(b);
title('300 Strongest Feature Points from Scene Image');
hold on;
plot(selectStrongest(scenePoints, 100));
[boxFeatures, boxPoints] = extractFeatures(a, boxPoints);
[sceneFeatures, scenePoints] = extractFeatures(b, scenePoints);
boxPairs = matchFeatures(boxFeatures, sceneFeatures);
matchedBoxPoints = boxPoints(boxPairs(:, 1), :);
matchedScenePoints = scenePoints(boxPairs(:, 2), :);
figure;
showMatchedFeatures(a, b, matchedBoxPoints, ...
    matchedScenePoints, 'montage');
title('Putatively Matched Points (Including Outliers)');

%% Corner point class 
% This object stores information about feature points detected from a 2-D grayscale image.
a = imread('image_0001.jpg');
a = imresize(a, [480 NaN]);
a = decorrstretch(a,'Tol',0.01);
b = imread('image_0002.jpg');
b = imresize(b, [480 NaN]);
b = decorrstretch(b,'Tol',0.01);
c = imread('image_1957.jpg');
c = imresize(c, [480 NaN]);
c = decorrstretch(c,'Tol',0.01);

points = detectHarrisFeatures(a);
strongest = points.selectStrongest(10);
imshow(a); 
hold on;
plot(strongest);
