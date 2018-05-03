function [pts]=nuclei_selection2(I,Icorr,CE,keep)
RB=I;
RBcorr=Icorr;
RB(:,:,2)=0;
RBcorr(:,:,2)=0;
RB_Bfull=RB;
RB_Bfull(:,:,3)=255*double(RB(:,:,3)>0);
if keep==0
figure(3)
subplot(1,1,1)
if CE==1
imagesc(uint8(RB_Bfull))
else
imagesc(uint8(RB))
end
end
figure(4)
ha(1)=subplot(2,2,1);
set(gcf, 'Position', [900, 100, 400, 300]);
imagesc(uint8(I))
title('Intensity Corrected, detected nuclei shown')
ha(2)=subplot(2,2,2);
imagesc(uint8(Icorr));
title('Original Image, all nuclei shown')
ha(3)=subplot(2,2,3);
B=I;
B(:,:,1)=0;
B(:,:,2)=0;
imagesc(uint8(B));
title('Blue Channel only')
ha(4)=subplot(2,2,4);
R=I;
R(:,:,2)=0;
R(:,:,3)=0;
imagesc(uint8(R));
title('Red Channel only')
figure(3);
set(gcf, 'Position', [100, 100, 800, 600]);
ha(5)=subplot(1,1,1);
title('Select Valid Cardiomyocyte Nuclei (RIGHT CLICK to finish, BACKSPACE or DELETE to undo last selection)','fontsize',12)
linkaxes(ha,'xy');
hold on
[x,y]=getpts;
x(end)=[];
y(end)=[];
pts=[x y];
end