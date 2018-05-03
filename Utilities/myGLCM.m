

% im: the RGB correcte image
% blue: the output of the thresholding of the blue channel (all nuclei)
% radius: half of the size of the patchs (let try first 10 and 15)
% output: "b" a vector of [nb_nuclei x 44] features

function [b]=myGLCM(im,cc,radius)
    
    nuclei=cc.PixelSubList;
    fprintf('%i nuclei found\n',size(nuclei,2));
    if size(im,3)==3
    imb=zeros(size(im)+[2*radius+2 2*radius+2 0]);
    %size(im)
    %size( imb(radius+1:(radius+1+size(im,1)),radius+1:(radius+1+size(im,2)),:) )
    imb(radius+1:(radius+size(im,1)),radius+1:(radius+size(im,2)),:)=im;
    nb_patchs=size(nuclei,2);
    b=zeros(nb_patchs,44);
    xo=0;
    yo=0;
    for i=1:1:nb_patchs
       m=round(mean(nuclei{i},1));
       xo=m(1)+radius+1;
       yo=m(2)+radius+1;
       b(i,:)=myGLCMpatch(imb((xo-radius):1:(xo+radius),(yo-radius):1:(yo+radius)));
    end
    b(isnan(b))=0;
    else
         imb=zeros(size(im)+[2*radius+2 2*radius+2]);
    imb(radius+1:(radius+size(im,1)),radius+1:(radius+size(im,2)))=im;
    nb_patchs=size(nuclei,2);
    b=zeros(nb_patchs,44);
    xo=0;
    yo=0;
    for i=1:1:nb_patchs
       m=round(mean(nuclei{i},1));
       xo=m(1)+radius+1;
       yo=m(2)+radius+1;
       b(i,:)=myGLCMpatch(imb((xo-radius):1:(xo+radius),(yo-radius):1:(yo+radius)));
    end
    b(isnan(b))=0;   
    end
end

function [b]=myGLCMpatch(im)

imr=im(:,:,1);
GLCM2 = graycomatrix(imr,'Offset',[5 0;0 5]);
a = GLCM_Features1(GLCM2,0);
b=zeros(1,22*2);

b(1:2)=a.autoc;
b(3:4)=a.contr;
b(5:6)=a.corrm;
b(7:8)=a.corrp;
b(9:10)=a.cprom;
b(11:12)=a.cshad;
b(13:14)=a.dissi;
b(15:16)=a.energ;
b(17:18)=a.entro;
b(19:20)=a.homom;
b(21:22)=a.homop;
b(23:24)=a.maxpr;
b(25:26)=a.sosvh;
b(27:28)=a.savgh;
b(29:30)=a.svarh;
b(31:32)=a.senth;
b(33:34)=a.dvarh;
b(35:36)=a.denth;
b(37:38)=a.inf1h;
b(39:40)=a.inf2h;
b(41:42)=a.indnc;
b(43:44)=a.idmnc;

end



