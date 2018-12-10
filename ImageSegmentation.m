%% Debug tools
clear;
clc;
%% Main body
img_input = double(imread('testinput.jpg'));
img_resized = imresize(img_input, 0.9);
img_info = size(img_resized);

height = img_info(1);
length = img_info(2);

outputImg  = zeros(height,length,3);

iteration = 0;
bandwidth = 3;    
threshold = 0.3;
max_iteration = 5;

for i = 1:height
    for j = 1:length
    red = img_resized(i,j,1);
    green = img_resized(i,j,2);
    blue = img_resized(i,j,3);
    data = [i,j,red,green,blue]; 
    for iteration = 1:max_iteration
        temp1 = 0;
        temp2 = 0;
        for i1 = max(1,round(data(1))-bandwidth):min(round(data(1))+bandwidth,height)
            for j1 = max(1,round(data(2))-bandwidth):min(round(data(2))+bandwidth,length)
                r = img_resized(i1,j1,1);
                g = img_resized(i1,j1,2);
                b = img_resized(i1,j1,3);
                newdata=[i1,j1,r,g,b];
                weight = exp(-1 * (norm(data-newdata))^2/(2*(bandwidth^2)));
                temp1 = temp1 + weight * newdata;
                temp2 = temp2 + weight;
           end
        end
        meanNew = temp1 / temp2;
        meanShift = meanNew - data;
        norm(meanShift);
        if(norm(meanShift)<=threshold)
           break; 
        end
        data = meanNew;
     end
        outputImg (i,j,1:3) = data(3:5);
% Uncomment below will see the percentage of running accomplishment .
%         fprintf('Finished %d percent\n',((i*length)+j)*100/height/length);
    end
end

subplot(1,2,1);
imshow(uint8(img_resized));
title('Input Image');
subplot(1,2,2);
imshow(uint8(outputImg));
title('Output Image');