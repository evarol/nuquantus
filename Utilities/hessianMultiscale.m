

% Edge detection and ridge detection with automatic scale selection
% Tony Lindeberg

function [rxx,rxy,ryy]=hessianMultiscale(im,sigs)

[rxx,rxy,ryy]=hessian(im,sigs(1));
ga=sigs(1)^(3.0/2.0);
rxx=rxx*ga;
rxy=rxy*ga;
ryy=ryy*ga;

for i=2:2:length(sigs)
    [sxx,sxy,syy]=hessian(im,sigs(i));
    ga=sigs(i)^(3.0/2.0);
    rxx=rxx+sxx*ga;
    rxy=rxy+sxy*ga;
    ryy=ryy+syy*ga;
end
end