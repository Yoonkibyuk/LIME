% close all
I = im2double(imread("D:\Desktop\image\CE\LIME\2.bmp"));

T_hat = max(I,[],3);              %initial illumination

w_d_h = 1./(abs(imfilter(T_hat,[0,0,0;0,-1,1;0,0,0])) + eps);
w_d_v = 1./(abs(imfilter(T_hat,[0,0,0;0,-1,0;0,1,0])) + eps);
K = ones(420,560);
K_advance_h = K;
K_advance_v = K;
K_advance_h(:,560) = 0;
K_advance_v(420,:) = 0;

e = reshape(K,[],1);
e_advance_h = reshape(K_advance_h,[],1);
e_advance_v = reshape(K_advance_v,[],1);
e_h = reshape(w_d_h,[],1);
e_v = reshape(w_d_v,[],1);


V = spdiags([-e],0,420*560,420*560);
V = spdiags(e_advance_v,1,V);

H = spdiags([-e],0,420*560,420*560);
H = spdiags(e_advance_h,420,H);

W_H = spdiags([e_h],0,420*560,420*560);
W_V = spdiags([e_v],0,420*560,420*560);

EYE = spdiags([e],0,420*560,420*560);
t = reshape(T_hat,[],1);
t_hat = spdiags([t],0,420*560,420*560); 


alpha = 2;

A = EYE + alpha*(H'*W_H*H + V'*W_V*V);
T2 = t'/A;
T3 = reshape(T2,420,560);

figure;imshow(T3/max(T3,[],"all"));colormap("hot")

figure;imshow(T3.^(0.8));colormap('hot')
figure;imshow((I)./(abs(T3.^(0.8)) + eps))