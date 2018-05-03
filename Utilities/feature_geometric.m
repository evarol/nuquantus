
%im: image
% radius: (integer) values between 3 and 8 are good, depending on the images
function [r]=feature_geometric(im,radius,sigma)
imr=redChannel(im);
imrr=myerosion(imr,radius);
nr=noir(imrr);
c=components(nr);
r=size_map(c);
r=imfilter(r,fspecial('gaussian',size(r),sigma));
end

function [imr]=redChannel(im)
imr=zeros(size(im,1),size(im,2));
for x=1:1:size(im,1)
    for y=1:1:size(im,2)
        imr(x,y)=im(x,y,1);
    end
end
end


function [imb]=myerosion(im,radius)
imb=im;
for x=1:1:size(im,1)
    for y=1:1:size(im,2)
        for dx=-(radius-1):(radius-1)
            for dy=-(radius-1):(radius-1)
                if x+dx>0
                    if x+dx<size(im,1)
                        if y+dy>0
                            if y+dy<size(im,2)
                                if abs(dx)+abs(dy)<radius
imb(x,y)=min(imb(x,y),im(x+dx,y+dy));
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
end

function [s]=size_map(c)
l=zeros(max(max(c)),1);
for i=1:1:length(l)
   l(i)=sum(sum(c==i));
end
s=c;
for x=1:1:size(c,1)
    for y=1:1:size(c,2)
        if c(x,y)>0
            s(x,y)=l(c(x,y));
        else
            s(x,y)=0;
        end
    end
end
end

function [c]=components(m)
c=m;
[lx,ly]=size(m);
nb=2;
for x=1:1:lx
    for y=1:1:ly
        if c(x,y)==1
           c=marquageD(c,x,y,nb);
           nb=nb+1;
        end
    end
end

%d=(c>0);
%for x=1:1:lx
%    for y=1:1:ly
%        if d(x,y)
%            c(x,y)=c(x,y)-1.0;
%        end
%    end
%end

end

function [c]=marquageD(c,x,y,nb)
[lx,ly]=size(c);

liste=[x;y];
while size(liste,2)>0
    x=liste(1,1);
    y=liste(2,1);
    c(x,y)=nb;
    if size(liste,2)>1
        liste=liste(:,2:end);
    else
       liste=[]; 
    end

    for dx=-1:1:1
        for dy=-1:1:1
            if dx*dx+dy*dy>0
                if x+dx<=lx && x+dx>0 && y+dy<=ly && y+dy>0 && c(x+dx,y+dy)==1
                    liste(1,size(liste,2)+1)=x+dx;
                    liste(2,size(liste,2))=y+dy;
                    c(x+dx,y+dy)=-nb;
                end
            end
        end
    end 
end

end

function [n]=noir(a)

n=zeros(size(a,1),size(a,2));
for x=1:1:size(n,1)
for y=1:1:size(n,2)
if a(x,y,1) < 40
n(x,y)=1;
end
end
end

end
