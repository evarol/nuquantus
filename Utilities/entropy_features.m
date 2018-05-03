function e=entropy_features(RB)
if size(RB,3)==3
    J=entropyfilt(RB);
    K=stdfilt(RB);
    R=rangefilt(RB);
    e(:,:,1)=J(:,:,1);
    e(:,:,2)=J(:,:,3);
    e(:,:,3)=K(:,:,1);
    e(:,:,4)=K(:,:,3);
    e(:,:,5)=R(:,:,1);
    e(:,:,6)=R(:,:,3);
else
    J=entropyfilt(RB);
    K=stdfilt(RB);
    R=rangefilt(RB);
    e(:,:,1)=J;
    e(:,:,2)=K;
    e(:,:,3)=R;
end