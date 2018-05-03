
%%
% im: image (2D image only)
% scales: scales considered for the multiscale Hessian
%     I have used scales=[1.0,1.25,1.5,1.75,2.0,5.0,7.5,10.0,15.0]
% scale_TV: the scale for the tensor voting
%     I have used scale_TV=10.0
function [re]=multiscaleHessianTV(im,scales,scale_tv)

[hxx,hxy,hyy]=hessianMultiscale(im,scales);

%%%%%%%%%%%%%%%%%%%%%%%%%%
% Jakob Unser correction %
%%%%%%%%%%%%%%%%%%%%%%%%%%

rb=hxx+hyy/3.0;
sb=hxy*4.0/3.0;
tb=hyy+hxx/3.0;
hxx=rb;
hxy=sb;
hyy=tb;

re=tensor_voting(hxx,hxy,hyy,scale_tv);

end

function [re]=tensor_voting(hxx,hxy,hyy,sig)
s=zeros(size(hxx));
th=zeros(size(hxx));

% s and theta
for x=1:1:size(hxx,1)
    for y=1:1:size(hyy,2)
        tr=hxx(x,y)+hyy(x,y);
        if tr>0.0
            dt=hxx(x,y)*hyy(x,y)-hxy(x,y)^2;
            s(x,y)=sqrt(tr*tr-4.0*dt);
            [v,la]=eig([hxx(x,y),hxy(x,y);hxy(x,y),hyy(x,y)]);
            if abs(v(1,1))>0.0
                th(x,y)=atan2(v(1,2),v(1,1));
            else
                th(x,y)=0.0;
            end
        end
    end
end

ccoc=s(:,:);
cdc=s(:,:);
cqc=s(:,:);
csc=s(:,:);

ccos=s(:,:);
cds=s(:,:);
cqs=s(:,:);
css=s(:,:);

for x=1:1:size(hxx,1)
    for y=1:1:size(hyy,2)
        cdc(x,y)=s(x,y)*cos(-2.0*th(x,y));
        cqc(x,y)=s(x,y)*cos(-4.0*th(x,y));
        csc(x,y)=s(x,y)*cos(-6.0*th(x,y));
        cds(x,y)=s(x,y)*sin(-2.0*th(x,y));
        cqs(x,y)=s(x,y)*sin(-4.0*th(x,y));
        css(x,y)=s(x,y)*sin(-6.0*th(x,y));
    end
end
cdbc=cdc;
cdbs=-cds;

r=floor(4.0*sig);
w0c=zeros(2*r+1);
w2c=zeros(2*r+1);
w4c=zeros(2*r+1);
w6c=zeros(2*r+1);
w8c=zeros(2*r+1);
w0s=zeros(2*r+1);
w2s=zeros(2*r+1);
w4s=zeros(2*r+1);
w6s=zeros(2*r+1);
w8s=zeros(2*r+1);

sig=2.0*sig^2;
for x=-r:1:r
    for y=-r:1:r
        rr=x*x+y*y;
        phi=atan2(y,x);
        
        w0c(x+r+1,y+r+1)=exp(-rr/sig)*cos(0.0*phi);
        w2c(x+r+1,y+r+1)=exp(-rr/sig)*cos(2.0*phi);
        w4c(x+r+1,y+r+1)=exp(-rr/sig)*cos(4.0*phi);
        w6c(x+r+1,y+r+1)=exp(-rr/sig)*cos(6.0*phi);
        w8c(x+r+1,y+r+1)=exp(-rr/sig)*cos(8.0*phi);
        
        w0s(x+r+1,y+r+1)=exp(-rr/sig)*sin(0.0*phi);
        w2s(x+r+1,y+r+1)=exp(-rr/sig)*sin(2.0*phi);
        w4s(x+r+1,y+r+1)=exp(-rr/sig)*sin(4.0*phi);
        w6s(x+r+1,y+r+1)=exp(-rr/sig)*sin(6.0*phi);
        w8s(x+r+1,y+r+1)=exp(-rr/sig)*sin(8.0*phi);
    end
end

rec=conv2(w0c,cdbc)-conv2(w0s,cdbs);
rec=rec+4.0*conv2(w2c,ccoc)-4.0*conv2(w2s,ccos);
rec=rec+6.0*conv2(w4c,cdc)-6.0*conv2(w4s,cds);
rec=rec+4.0*conv2(w6c,cqc)-4.0*conv2(w6s,cqs);
rec=rec+conv2(w8c,csc)-conv2(w8s,css);

res=conv2(w0c,cdbs)+conv2(w0s,cdbc);
res=res+4.0*conv2(w2c,ccos)+4.0*conv2(w2s,ccoc);
res=res+6.0*conv2(w4c,cds)+6.0*conv2(w4s,cdc);
res=res+4.0*conv2(w6c,cqs)+4.0*conv2(w6s,cqc);
res=res+conv2(w8c,css)+conv2(w8s,csc);


re=rec.*rec+res.*res;
re=re.^0.5;

%a=floor(size(w0c,1)/2);
re=re(r+1:1:end-r,r+1:1:end-r);


reb=6.0*conv2(w0c,ccoc)-6.0*conv2(w0s,ccos)+8.0*conv2(w2c,cdc)-8.0*conv2(w0s,cds)+2.0*conv2(w4c,cqc)-2.0*conv2(w4s,cqs);
reb=reb(r+1:1:end-r,r+1:1:end-r);

re=0.5*(re+reb);

end