
function[r]=bloodVesselsTV(I,size_th,fr)

%th=3.0*10^5;
%size_th=1000;


li=[1.0,1.25,1.5,1.75,2.0,3.0,4.0,5.0,7.5];
%[r,s,t]=hessianMultiscale(I(:,:,1),li);
[re]=multiscaleHessianTV(I(:,:,1),li,7.0);
th=fr*median(re(:));
B=(re>th);


%figure(2);imagesc(re);colorbar
%figure(1);imagesc(A);colorbar



%A=max(I(:,:,1),I(:,:,3));
%A=I(:,:,1);
%A=imdilate(A,strel('diamond',1));
%A=imerode(A,strel('diamond',1));
%A=imerode(A,strel('diamond',1));
%A=imdilate(A,strel('disk',1));

%A=imerode(A,strel('disk',1));

%A=imdilate(A,strel('disk',1));
%B=A;


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
end
%cc.PixelIdxList(toremove==1)=[];
%cc.PixelSubList(toremove==1)=[];
%cc.NumObjects=cc.NumObjects-sum(toremove);

end

