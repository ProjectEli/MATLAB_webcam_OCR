%% OCR with Webcam
% ProjectEli 2019, MIT license.
% references:
% [1] https://kr.mathworks.com/matlabcentral/fileexchange/45182-matlab-support-package-for-usb-webcams﻿
% [2] https://kr.mathworks.com/help/supportpkg/usbwebcams/ug/acquire-images-from-webcams.html﻿
% [3] https://kr.mathworks.com/help/vision/examples/recognize-text-using-optical-character-recognition-ocr.html﻿

%% Initialize
clear; close all;

%% Webcam settings
% webcamlist;
cam = webcam(1);
cam.Resolution = '1280x720';
cam.Brightness = 180;
cam.Contrast = 0;
cam.Exposure = -2;
cam.Focus = 0;

%% Take image & image process
% image with region of interest
img_cap = snapshot(cam);
figure(1); imshow(img_cap);
roi = [1, 360, 1100, 360];
h = images.roi.Rectangle(gca,'Position',roi,'StripeColor','r');

% post process for OCR
% imbothat: dark word in white background
% imtophat: white word in dark background
Icorr = imbothat(img_cap,strel('disk',15));
BW1 = imbinarize(Icorr);
figure(2);
imshowpair(Icorr,BW1,'montage');

% run OCR
ocr_result = ocr(BW1, roi,'TextLayout','Block');

%% default display
Iocr = insertObjectAnnotation(img_cap,'rectangle', ...
    ocr_result.WordBoundingBoxes, ...
    ocr_result.Words);
figure(3); imshow(Iocr);

%% Reject low confindence
highconfidence = ocr_result.WordConfidences > 0.6;
highconfbox = ocr_result.WordBoundingBoxes(highconfidence,:);
highconfwords = ocr_result.Words(highconfidence);
Iocr = insertObjectAnnotation(img_cap,'rectangle', ...
    highconfbox, ...
    highconfwords);
figure(4); imshow(Iocr);

%% word confidence display
% ocr_result = ocr(img_cap);
% 
% Iocr = insertObjectAnnotation(img_cap, 'rectangle', ...
%     ocr_result.WordBoundingBoxes, ...
%     ocr_result.WordConfidences);
% figure; imshow(Iocr);


%% selective detection with regexp
% regformat = '\w';
% bboxes = locateText(ocr_result,regformat,'UseRegexp',true);
% texts = regexp(ocr_result.Text,regformat,'match');
% 
% Iocr = insertObjectAnnotation(img_cap, 'rectangle', ...
%     bboxes, ...
%     texts);
% figure; imshow(Iocr);
