function [out,Rblur_orig]=preprocess1(I,background_cutoff,brightness_correction_sigma,verbose)
I_orig=I;
%% Background removal
bgR=double(I(:,:,1)<=background_cutoff);
bgG=double(I(:,:,2)<=background_cutoff);
bgB=double(I(:,:,3)<=background_cutoff);
R=I(:,:,1);
G=I(:,:,2);
B=I(:,:,3);
R(bgR==1)=0;
G(bgG==1)=0;
B(bgB==1)=0;
I(:,:,1)=R;
I(:,:,2)=G;
I(:,:,3)=B;
%% Contrast correction
Rblur_orig=imfilter(R,fspecial('gaussian', size(R), brightness_correction_sigma));
Rblur_orig=Rblur_orig/max(max(Rblur_orig));
Rblur=Rblur_orig;
R(Rblur~=0)=R(Rblur~=0)./Rblur(Rblur~=0);
B(Rblur~=0)=B(Rblur~=0)./Rblur(Rblur~=0);
G(Rblur~=0)=G(Rblur~=0)./Rblur(Rblur~=0);
B=imerode(B,strel('disk',0));
I(:,:,1)=R;
I(:,:,2)=G;
I(:,:,3)=B;
Rblur=imfilter(I(:,:,1),fspecial('gaussian', size(R), brightness_correction_sigma));
Rblur=Rblur/max(max(Rblur));
if verbose==1
figure
subplot(1,2,1)
imagesc(Rblur_orig)
title('Original average intensity')
subplot(1,2,2)
imagesc(Rblur)
title('Contrast corrected average intensity')
figure
subplot(1,2,1)
imagesc(uint8(I_orig))
title('Original Image')
subplot(1,2,2)
imagesc(uint8(I))
title('Contrast correction')
end
out=I;
end