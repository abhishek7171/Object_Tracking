function VERSION_2_main
clc;
clear all;
close all;
%% read the video frames%%
vid=VideoReader('test.mp4');
numFrames = vid.NumberOfFrames;
n=numFrames
pause
%% select the first video frame%%
frame1 = read(vid,1);
im1=imresize(rgb2gray(frame1),1/5);%% resize and convert into gray scale
im1=im1.';
%% taking the bottom-part of the image which has high probability of being an navigable (meaning, obstacle free)
bot=im1(round(size(im1,1)/2):size(im1,1),:);
%% select a patch which is a region of interest
patch=imcrop(bot);
size(patch)
%% computing and normalizing the histogram from the patch (roi)
h=imhist(patch,256).';
h=h./(size(patch,1)*size(patch,2));
count=1;
%% now search the similar patch in the bottom-part of each frame (from second frame onwords)
for i = 2:10:n
    i
    frame1 = read(vid,i);
    im1=imresize(rgb2gray(frame1),1/5);
    im1=im1.';
    bot=im1(round(size(im1,1)/2):size(im1,1),:);
    im1=TEST_SCORE_V2(im1,bot,patch,h);
    imwrite(im1,['./RESULTS/','Img_',num2str(count),'.jpg']);
    count=count+1;
    pause(.5)
end
end

function im1=TEST_SCORE_V2(im1,bot,patch,h)
%% In this function
%% Inputs: im1: Input frame in which we have to search the patch
%%         bot: The bottom part of im1
%%         patch: region-of-interest in bot
%%         h: histogram of patch
%% Output: The image containing the next position of the robot 
mat=im2col(bot,[size(patch,1),size(patch,2)],'distinct');%% Obtaining distinct patches from bottom-part of im1
size(mat)
%% From each patch compute histogram and normalize it.
for j=1:size(mat,2)
    test=reshape(mat(:,j),[size(patch,1),size(patch,2)]);
    h2=imhist(test,256).';
    h2=h2./(size(test,1)*size(test,2));
    d(j)=hcompare_EMD(h,h2);%% similarity analysis between two histograms using earth's movers distance
end
%% finding the most similar patch
index=find(d==min(d));
mat(:,index(1))=0;
A = col2im(mat,[size(patch,1),size(patch,2)],[size(bot,1) size(bot,2)],'distinct');
%% reflecting the position of most similar patch in the image.
im1(round(size(im1,1)/2):size(im1,1),:)=A;
figure;imshow(im1);
end

