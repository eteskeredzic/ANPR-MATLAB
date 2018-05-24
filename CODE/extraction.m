%% Licence plate extraction
clf
% korak 1 - ucitaj sliku
path = input('Unesi naziv slike i format: ', 's');
img = imread(strcat('INPUT/',path));
%figure, imshow(img);

% korak 2 - konvertuj u grayscale
img_gray = rgb2gray(img);
%figure, imshow(img_gray);

% korak 3 - noise removal
img_median=medfilt2(img_gray,[6 6]); 
%figure, imshow(img_median);

% korak 4 - adaptive histogram equalization
img_hist = adapthisteq(img_median);
%figure, imshow(img_hist);

% korak 5 - morphological opening
SE = strel('disk',35,4);
img_opening = imopen(img_hist,SE);
%figure, imshow(img_opening);

% korak 6 - image substraction
img_sub = img_hist - img_opening;
%figure, imshow(img_sub);

% korak 7 - convert to binary using otsu's method
level = graythresh(img_sub);
img_bin = imbinarize(img_sub,level);
%figure, imshow(img_bin);

% korak 8 - sobel vertical edge detection
sobel = edge(img_bin, 'Sobel');
%figure, imshow(sobel);

% korak 9 - dilate & fill
SE = strel('disk',2,4);
dilate = imdilate(sobel, SE);
fill = imfill(dilate,'holes');
%figure, imshow(fill);

% korak 10 - morph opening & erode
SE = strel('disk', 6, 6);
img_opening2 = imopen(fill,SE);
img_opening2 = imerode(img_opening2,SE);
%figure, imshow(img_opening2);

% korak 11 - find connected components
CC = bwconncomp(img_opening2);
numOfPixels = cellfun(@numel,CC.PixelIdxList);
   [unused,indexOfMax] = max(numOfPixels);
   biggest = zeros(size(img_opening2));
   biggest(CC.PixelIdxList{indexOfMax}) = 1;
%figure, imshow(biggest);
   
% korak 12 - cropping
Inew = bsxfun(@times, img, cast(biggest, 'like', img));
%figure, imshow(Inew);
[rows, columns] = find(biggest);
row1 = min(rows);
row2 = max(rows);
col1 = min(columns);
col2 = max(columns);
croppedImage = Inew(row1:row2, col1:col2);
figure, imshow(croppedImage);
imwrite(croppedImage,strcat('OUTPUT/',path));
% moze se crop raditi i preko image processing toolbox


