function [cc,Ipred]=nuclei_plot_test1(I,I_orig,cc,CE)
RB=I;
RB(:,:,2)=0;
RB_Bfull=RB;
RB_Bfull(:,:,3)=255*double(RB(:,:,3)>0);
if CE==1
    Ipred=RB_Bfull;
else
    Ipred=RB;
end
Ipred_B=Ipred;
Ipred(:,:,3)=0;
for i=1:cc.NumObjects
    if cc.Y(i)==1
        for j=1:size(cc.PixelSubList{i},1)
            Ipred(cc.PixelSubList{i}(j,1),cc.PixelSubList{i}(j,2),3)=Ipred_B(cc.PixelSubList{i}(j,1),cc.PixelSubList{i}(j,2),3);
        end
    end
end


s=size(I);
I_orig=I_orig(1:s(1),1:s(2),1:s(3));
figure
subplot(1,2,1)
imagesc(uint8(I_orig));
title('Original')
subplot(1,2,2)
imagesc(uint8(Ipred));
title('Predicted Cardiomyocyte Nuclei')