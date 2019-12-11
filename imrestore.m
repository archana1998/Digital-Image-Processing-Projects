im1 = imread('Distorted Image.tif') %reading in the distorted image
subplot(1,2,1); % plots the existing image
imshow(im1);% show distorted image
title('Distorted Image')
img= im2double(im1); % convert image matrix into double matrix for calculations
h = fspecial('disk',3.75); % creates a circular averaging 2-D filter of radius 3.75 inside square matrix
hf = fft2(h,size(img,1),size(img,2)); % estimation of degradation function
img_inv = real(ifft2((abs(hf) > 0.0375).*fft2(img)./hf));% calculating ratio of image to estimated degradation function and applying the filter to it
img_inv = mat2gray(img_inv);% converts output to double
subplot(1,2,2);% subplots output
imshow(img_inv); % shows plot
title('Image after Restoration');

% result = zeros(480);
% for u = 1:480
%     for v = 1:480
%         H(u,v) = exp(-0.0025*((((u-240.0)^2)+(v-240.0)^2)^(5/6)));
%         B(u,v) = 1.0/(1.0+(((((u^2)+(v^2))^0.5)/70.0)^20.0));
%         result(u,v) = (((fftshift(fft2(img(u,v))))/H(u,v))*B(u,v));
%     end
% end
% % 
% % H = fft2(H);
% % B = fft2(B);
% % result = real(((fftshift(fft2(img)))./H).*B);
% cam_pinv = real(ifft2(ifftshift(result)));
% 
% 
% 
% % imsharpen(cam_pinv);





% im1 = imread('Distorted Image.tif')
% subplot(1,2,1); % plots the existing image
% imshow(im1);
% img= im2double(im1);
% 
% 
% F = img./H;
% 
% [b,a] = butter(10,70);
% % for i=1:480
% %     for j=1:480
% %         F(i,j) = (img(i,j)/.degrade(i,j));
% % %         F(i,j)= butter(10,70);
% %     end
% % end
% subplot(1,2,2);
% imshow(F);
% 
img = imread('Distorted Image.tif'); %reads the distorted image
subplot(1,2,1); %subplots distorted image
title('Distorted Image'); %title for subplot
ft_img = fftshift(fft2(img));%converts distorted image to freq domain and centers it
A = zeros(480); %initializing output image matrix with 0s
k = 0.0025; %value of k for degradation function
m = 5/6; %value of m for degradation function
D = 85; %radius of BLPF

for u= 1:size(ft_img,1)
    for v= 1:size(ft_img,2) % for loop for doing matrix element wise computations
        l = ((u-240)^2+(v-240)^2); %distance used in degradation function
        h = exp(-k*(l^m)); %degradation function
        d = ((u-240)^2+(v-240)^2)^0.5; %distance for BLPF
        b = 1/(1+(d/D)^30);%BLPF function
        A(u,v) = (ft_img(u,v)/h)*b;%divide the transformed distorted image by the degradation function, and filter through BLPF
    end
end

result= mat2gray(real(ifft2(ifftshift(A)))); %taking inverse transform and shift of result obtained above, and converting to double
subplot(1,2,2);%subplots restored image
imshow(result);%shows final plot
title('Image after Restoration')
