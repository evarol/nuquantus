function cc=nuclei_plot1(I,I_orig,cc,pts,CE,newpts)
if nargin<6
    newpts=[];
end
if isempty(pts)
pts=[Inf Inf];
end
s=size(I);
RB=I;
RB(:,:,2)=0;
RB_Bfull=RB;
RB_Bfull(:,:,3)=255*double(RB(:,:,3)>0);
idx=[];
coor=[];
for i=1:length(cc.PixelIdxList)
idx=[idx repmat(i,[1 numel(cc.PixelIdxList{i})])]; %#ok<*AGROW>
[I,J]=ind2sub(cc.ImageSize,cc.PixelIdxList{i});
coor=[coor [I';J']];
end
x=pts(:,1);
y=pts(:,2);
cc_idx=[];
for i=1:length(x)
    dist=(coor(1,:)-y(i)).^2+(coor(2,:)-x(i)).^2;
    if min(dist,[],2)<=10;
    [~,tmp_idx]=min(dist,[],2);
    cc_idx=[cc_idx;idx(tmp_idx)];
    end
end

figure(3)
subplot(1,2,1)
imagesc(uint8(I_orig(1:s(1),1:s(2),1:s(3))));
title('Original');
subplot(1,2,2)
if CE==1
imagesc(uint8(RB_Bfull))
else
 imagesc(uint8(RB))
end

hold on
Y=zeros(size(idx))';
for i=1:length(cc_idx)
    coor_find=coor(:,idx==cc_idx(i));
    Y(idx==cc_idx(i))=1;
    mean_coor=round(mean(coor_find,2));
    plot(mean_coor(2),mean_coor(1),'oy','markersize',20,'linewidth',2);
end
plot(x,y,'y+')

cc.Y=zeros(cc.NumObjects,1);
cc.Y(cc_idx)=1;

if nargin==6
    x=newpts(:,1);
y=newpts(:,2);
cc_idx=[];
for i=1:length(x)
    dist=(coor(1,:)-y(i)).^2+(coor(2,:)-x(i)).^2;
    if min(dist,[],2)<=10;
    [~,tmp_idx]=min(dist,[],2);
    cc_idx=[cc_idx;idx(tmp_idx)];
    end
end

figure(3)
subplot(1,2,2)


hold on
Y=zeros(size(idx))';
for i=1:length(cc_idx)
    coor_find=coor(:,idx==cc_idx(i));
    Y(idx==cc_idx(i))=1;
    mean_coor=round(mean(coor_find,2));
    plot(mean_coor(2),mean_coor(1),'og','markersize',20,'linewidth',2);
end
plot(x,y,'y+')

cc.Y(cc_idx)=1;
end