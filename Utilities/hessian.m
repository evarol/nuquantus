function [rxx,rxy,ryy]=hessian(im,sig)
[kxx,kxy,kyy]=kernels(sig);
rxx=conv2(im,kxx);
rxy=conv2(im,kxy);
ryy=conv2(im,kyy);

a=floor(size(kxx,1)/2);
rxx=rxx(a+1:1:end-a,a+1:1:end-a);
rxy=rxy(a+1:1:end-a,a+1:1:end-a);
ryy=ryy(a+1:1:end-a,a+1:1:end-a);

end

function[xx,xy,yy]=kernels(s)

nb=round(3.5*s);
xx=zeros(2*nb+1);
xy=zeros(2*nb+1);
yy=zeros(2*nb+1);
ss=s*s;
for x=-nb:1:nb
    for y=-nb:1:nb
        xx(x+nb+1,y+nb+1)=1.0/ss*( x*x/ss-1.0 )*exp(-(x*x+y*y)/(2.0*ss));
        xy(x+nb+1,y+nb+1)=1.0/ss*( x*y/ss )*exp(-(x*x+y*y)/(2.0*ss));
        yy(x+nb+1,y+nb+1)=1.0/ss*( y*y/ss-1.0 )*exp(-(x*x+y*y)/(2.0*ss));
    end
end

ss=1.0/(2.0*pi*ss);
xx=xx*ss;
xy=xy*ss;
yy=yy*ss;

end
