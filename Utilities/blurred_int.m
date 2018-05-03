function [n]=blurred_int(I)

if size(I,3)==3
    r=I(:,:,1);
    b=I(:,:,3);
    sigma=(2:1:6);
    for i=1:length(sigma)
        rr(:,:,i)=imfilter(r,fspecial('gaussian',size(r),sigma(i)));
        bb(:,:,i)=imfilter(b,fspecial('gaussian',size(b),sigma(i)));
    end
    n=cat(3,rr,bb);
else
    r=I(:,:,1);
    sigma=(2:1:6);
    for i=1:length(sigma)
        rr(:,:,i)=imfilter(r,fspecial('gaussian',size(r),sigma(i)));
    end
    n=rr;
end