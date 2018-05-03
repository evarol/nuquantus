function X=feature_extraction1(I,cc)
RB=I;
RB(:,:,2)=0;
featnames=[];
%% rotationInvariantFiltering.m GABOR
% disp('Computing Gabor features...')
% [r]=rotationInvariantFiltering2(RB(:,:,1));
% [rr]=pixel2nucleus(r,cc);
% featnames=[featnames repmat({'gabor'},1,size(rr,2))];
% disp('...Gabor features Done!')
%% myGLCM.m HARALICK
disp('Computing Haralick features...')
[bb]=myGLCM(RB,cc,15);
featnames=[featnames repmat({'haralick'},1,size(bb,2))];
disp('...Haralick features Done!')
%% multiscaleHessianTV.m TENSOR VOTING
disp('Computing Tensor Voting...')

m(:,:,1)=multiscaleHessianTV(RB(:,:,1),[1.0,1.25,1.5,1.75,2.0,5.0,7.5,10.0,15.0],10);
m(:,:,2)=multiscaleHessianTV(RB(:,:,1),[1.0,1.25,1.5,1.75,2.0,5.0,7.5,10.0,15.0],8);
m(:,:,3)=multiscaleHessianTV(RB(:,:,1),[1.0,1.25,1.5,1.75,2.0,5.0,7.5,10.0,15.0],6);
[mm]=pixel2nucleus(m,cc);
featnames=[featnames repmat({'TV'},1,size(mm,2))];
disp('...Tensor Voting Done!')
%% HUE
% disp('Computing Hue...')
% h=rgb2hsv(RB);
% h=h(:,:,1);
% [hh]=pixel2nucleus(h,cc);
% featnames=[featnames repmat({'hue'},1,size(hh,2))];
% disp('...Hue Done!')
%% feature_geometric.m GEOMETRIC
disp('Computing Geometric Features...')
g(:,:,1)=feature_geometric(RB,1,1.5);
g(:,:,2)=feature_geometric(RB,2,1.5);
g(:,:,3)=feature_geometric(RB,3,1.5);

[gg]=pixel2nucleus(g,cc);
featnames=[featnames repmat({'geometric'},1,size(gg,2))];
disp('...Geometric Features Done!')
%% BLURRED INTENSITIES
% disp('Computing Blurred Intensities...')
% n=blurred_int(RB);
% [nn]=pixel2nucleus(n,cc);
% featnames=[featnames repmat({'blurred_int'},1,size(nn,2))];
% disp('...Blurred Intensities Done!')

%% NUCLEUS SIZE
% disp('Computing Nucleus Size...')
% ss=cellfun(@numel,cc.PixelIdxList)';
% featnames=[featnames repmat({'nucleus_size'},1,size(ss,2))];
% disp('...Nucleus Size Done!')

%% ENTROPY
% disp('Computing Entropy Features...')
% e=entropy_features(RB);
% [ee]=pixel2nucleus(e,cc);
% featnames=[featnames repmat({'entropy'},1,size(ee,2))];
% disp('...Entropy Features Done!')

%% FOURIER HOG
disp('Computing Fourier HOG...')
prepareKernel(6,8,0);
f=FourierHOG(RB);
f=reshape(f,[size(RB,1) size(RB,2) size(f,2)]);
[ff]=pixel2nucleus(f,cc);
featnames=[featnames repmat({'fourier_hog'},1,size(ff,2))];
disp('...Fourier HOG Done!')
%%
%%
%%
%% Red + Blue Channel!
RpB=I(:,:,1)+I(:,:,3);
disp('Computing Features for Red+Blue Channel...')
%%
%%
%%
%% rotationInvariantFiltering.m GABOR
% disp('Computing Gabor features...')
% [r2]=rotationInvariantFiltering2(RpB);
% [rr2]=pixel2nucleus(r2,cc);
% featnames=[featnames repmat({'gabor2'},1,size(rr2,2))];
% disp('...Gabor feature Done!')
%% myGLCM.m HARALICK
% disp('Computing Haralick features...')
% [bb2]=myGLCM(RpB,cc,15);
% featnames=[featnames repmat({'haralick2'},1,size(bb2,2))];
% disp('...Haralick features Done!')
%% multiscaleHessianTV.m TENSOR VOTING
% disp('Computing Tensor Voting...')
% 
% m2(:,:,1)=multiscaleHessianTV(RpB,[1.0,1.25,1.5,1.75,2.0,5.0,7.5,10.0,15.0],10);
% m2(:,:,2)=multiscaleHessianTV(RpB,[1.0,1.25,1.5,1.75,2.0,5.0,7.5,10.0,15.0],8);
% m2(:,:,3)=multiscaleHessianTV(RpB,[1.0,1.25,1.5,1.75,2.0,5.0,7.5,10.0,15.0],6);
% [mm2]=pixel2nucleus(m2,cc);
% featnames=[featnames repmat({'TV2'},1,size(mm2,2))];
% disp('...Tensor Voting Done!')


%% BLURRED INTENSITIES
% disp('Computing Blurred Intensities...')
% n2=blurred_int(RpB);
% [nn2]=pixel2nucleus(n2,cc);
% featnames=[featnames repmat({'blurred_int2'},1,size(nn2,2))];
% disp('...Blurred Intensities Done!')


%% ENTROPY
disp('Computing Entropy Features...')
e2=entropy_features(RpB);
[ee2]=pixel2nucleus(e2,cc);
featnames=[featnames repmat({'entropy2'},1,size(ee2,2))];
disp('...Entropy Features Done!')

%% Original Heat Map
% [~,Rblur_orig]=preprocess1(cc.I_orig,cc.background_cutoff,cc.brightness_correction_sigma,0);
% [hm]=pixel2nucleus(Rblur_orig,cc);
% featnames=[featnames repmat({'original_heat_map'},1,size(hm,2))];
%% Add features
% X.feat=[rr bb mm hh gg nn ss ee ff rr2 bb2 mm2 nn2 ee2 hm];
X.feat=[bb mm gg ff ee2];
X.featnames=featnames;
disp('Features Extracted!')
disp(['Size of features: ' num2str(size(X.feat)) ])