


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
