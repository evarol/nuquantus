function [ret]=rotationInvariantFiltering(imo)

im=zeros(size(imo,1),size(imo,2));
for x=1:1:size(imo,1)
    for y=1:1:size(imo,2)
        im(x,y)=imo(x,y,1);
    end
end

fs=all_filters;
r=zeros(size(im,1),size(im,2),size(fs,2)*size(fs{1},2));

s=zeros(size(im,1),size(im,2),size(fs,2));
ss=[];
xa=0;
ya=0;
xb=0;
yb=0;
for i=1:1:size(fs{1},2)
   fprintf('%i/%i\n',i,size(fs{1},2));
   for j=1:1:size(fs,2)
       ss=conv2(im,fs{j}{i});
       xa=(size(fs{j}{i},1)+1)/2;
       ya=(size(fs{j}{i},2)+1)/2;
       xb=size(ss,1)-xa+1;
       yb=size(ss,2)-ya+1;
       
       ss=ss(xa:xb,ya:yb);
       s(:,:,j)=ss;    
   end
   for x=1:1:size(r,1)
       for y=1:1:size(r,2)
           %r(x,y, ((i-1)*size(fs,2)+1):((i)*size(fs,2)) )=abs(fft(s(x,y,:)));
           r(x,y, ((i-1)*size(fs,2)+1):((i)*size(fs,2)) )=abs(s(x,y,:));
       end
   end
end

ret=zeros(size(r,1),size(r,2));
for x=1:1:size(r,1)
    for y=1:1:size(r,2)
        ret(x,y)=max(abs(r(x,y,:)));
    end
end

end


function [fs]=all_filters()

sigmas=[3.0];
thetas=0.0:pi/10.0:pi/1.0;
ls=3.0;
g=3.0;
psi=0.0:pi/4.0:pi/1.0;

fs={};
for i=length(thetas)
   fs{i}={};
end

p=1;
for i=1:1:length(sigmas)
    for j=1:1:length(psi)
        for k=1:1:length(thetas)
            fs{k}{p}=gabor_filter(sigmas(i),thetas(k),ls,psi(j),g);
        end
        p=p+1;
    end
end


end
