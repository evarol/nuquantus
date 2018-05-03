function rr=pixel2nucleus(r,cc)

tmpmean=zeros(cc.NumObjects,size(r,3));
tmpvar=zeros(cc.NumObjects,size(r,3));
tmpmedian=zeros(cc.NumObjects,size(r,3));
tmpmad=zeros(cc.NumObjects,size(r,3));
for j=1:size(r,3)
    tmp=r(:,:,j);
    for i=1:cc.NumObjects
        tmpmean(i,j)=mean(tmp(cc.PixelIdxList{i}));
        tmpvar(i,j)=var(tmp(cc.PixelIdxList{i}));
        tmpmedian(i,j)=median(tmp(cc.PixelIdxList{i}));
        tmpmad(i,j)=mad(tmp(cc.PixelIdxList{i}));
    end
end
rr=[tmpmean tmpvar tmpmedian tmpmad];