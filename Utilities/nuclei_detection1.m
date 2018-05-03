function [cc,I]=nuclei_detection1(I,size_thresh)

B=I(:,:,3);
cc=bwconncomp(B,18);
toremove=zeros(cc.NumObjects,1);
for i=1:cc.NumObjects
    if numel(cc.PixelIdxList{i})<=size_thresh
        toremove(i)=1;
        B(cc.PixelIdxList{i})=0;
    end
    [X,Y]=ind2sub(cc.ImageSize,cc.PixelIdxList{i});
    cc.PixelSubList{i}=[X,Y];
end
cc.PixelIdxList(toremove==1)=[];
cc.PixelSubList(toremove==1)=[];
cc.NumObjects=cc.NumObjects-sum(toremove);
I(:,:,3)=B;