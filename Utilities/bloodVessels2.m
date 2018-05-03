
function[r]=bloodVessels2(I,th,size_th)

% th=75;
% size_th=1000;


%A=max(I(:,:,1),I(:,:,3));
A=I(:,:,1);
%A=imdilate(A,strel('diamond',1));
%A=imerode(A,strel('diamond',1));
%A=imerode(A,strel('diamond',1));
A=imdilate(A,strel('disk',1));

%A=imerode(A,strel('disk',1));

%A=imdilate(A,strel('disk',1));

B=(A<th);

cc=bwconncomp(B,8);
toremove=zeros(cc.NumObjects,1);
r=zeros(size(I,1),size(I,2));
for i=1:cc.NumObjects
     if numel(cc.PixelIdxList{i})>=size_th
         toremove(i)=1;
         [X,Y]=ind2sub(cc.ImageSize,cc.PixelIdxList{i});
         for j=1:1:size(X,1)
            r(X(j),Y(j))=1;
         end
     end
     %[X,Y]=ind2sub(cc.ImageSize,cc.PixelIdxList{i});
     %cc.PixelSubList{i}=[X,Y];
end
%cc.PixelIdxList(toremove==1)=[];
%cc.PixelSubList(toremove==1)=[];
%cc.NumObjects=cc.NumObjects-sum(toremove);

end

