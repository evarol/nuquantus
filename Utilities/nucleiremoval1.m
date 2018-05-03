function cc=nucleiremoval1(I,cc)
[r1]=bloodVessels2(I,75,1000);
[r2]=bloodVesselsTV(I,200,3.0*10^5);

for i=1:cc.NumObjects
    count=0;
    for j=1:size(cc.PixelSubList{i},1)
        count=count+or(r1(cc.PixelSubList{i}(j,1),cc.PixelSubList{i}(j,2)),...
            r2(cc.PixelSubList{i}(j,1),cc.PixelSubList{i}(j,2)));
    end
    if count>size(cc.PixelSubList{i},1)*0.4;
        cc.remove(i)=1;
    else
        cc.remove(i)=0;
    end
end