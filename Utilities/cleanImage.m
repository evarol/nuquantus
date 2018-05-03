function Iout=cleanImage(I,size_thresh,channel)

for i=1:length(channel)
    tmp=I(:,:,channel(i));
    cc=bwconncomp(tmp,18);
    for j=1:cc.NumObjects
        if numel(cc.PixelIdxList{j})<size_thresh
            tmp(cc.PixelIdxList{j})=0;
        end
    end
    I(:,:,channel(i))=tmp;
end
Iout=I;
    