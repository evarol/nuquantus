function count=bg_counter(G,B,size_thresh)
ccB=bwconncomp(B,18);
count=0;
for i=1:ccB.NumObjects
    if sum(G(ccB.PixelIdxList{i})>0)>=size_thresh
        count=count+1;
    end
end
    