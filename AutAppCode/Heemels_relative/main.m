%read: with relative threshold, without counter q, with augementation of the disturbance

function [td,jd,xid] = outputFeedback()
clear all
close all
    rng('shuffle'); %reseed random number generator
    global sigma Ad Bd Hd Kd L1d d dim_n dim_m dim_p%(Ad,Hd) observable; F1 and F2 are Hurwitz; eye(2)-expm(F2*delta)*expm(-F1*delta) is invertible
%     tau_max = 5; %half of desired convergence instant
%     delta = 2; %SOD of ETM on sensor-controller channel

sigma = 0.1;
A=[1.2943, 0.0163 0.6935, -0.5260;...
   -0.0740, 0.5459, -0.0217, 0.0868;...
   0.0986, 0.4490, 0.4520, 0.4733;...
   -0.0049, 0.4488, 0.1104, 0.8062]; %plant n*n
    B=[0.0146, -0.1827;...
   0.6413, 0.0038;...
   0.3782, -0.3143;...
   0.3777, -0.0320]; %n*m
    H = [1, 0, -1, 1;...
   0, 1, 0, 0];
    E=2.*B;
    Fmatrix=eye(2);

    d = [1;1]; %constant disturbance m*1
    
    dim_n = size(B,1);
    dim_m = size(B,2);
    dim_p = size(H,1);
%     dim_q = size(E,2);
    Ad = [A E;zeros(dim_m,dim_n) zeros(dim_m,dim_m)];
    Bd = [B;zeros(dim_m,dim_m)];
    Hd = [H Fmatrix];
%         ObAH = obsv(A,H) 
%         unobAH = length(A)-rank(ObAH) % Number of unobservable states
%         CoAB = ctrb(A,B)
%         uncoAB = length(A) - rank(CoAB) % Number of uncontrollable states
%         ObAHd = obsv(Ad,Hd) 
%         unobAHd = length(Ad)-rank(ObAHd) % Number of unobservable states
%         CoABd = ctrb(Ad,Bd)
%         uncoABd = length(Ad) - rank(CoABd) % Number of uncontrollable states
    
%     K = lqr(A,B,eye(dim_n),dim_m); %LQR on controller side
%         F = A-B*K;
%         eigs(F) %Re(F) =  -0.676096724726979 < 0
K_1=[-0.3926, 0.6485, 0.2655, 7.2730;...
-12.2766, -0.0841, -4.2180, 4.2003];
K_2=2.*eye(2);

    Kd = [K_1 K_2];    

%     L1d = transpose(lqr(Ad',Hd',eye(dim_n+dim_m),eye(dim_p))); %1st Luenberger: real eig(Ad-L1d*Hd)=-1.018 and -1.018 and -0.623
%     L2d = transpose(lqr(Ad',Hd',2*eye(dim_n+dim_m),eye(dim_p))); %2nd Luenberger: real eig(Ad-L2d*Hd)=-1.395 and -1.395 and -0.768
L1d =[6.0982,-6.2687;...
    0.9352,3.1758;...
    51.7487,81.3678;...
    52.4523,88.5717;...
    -0.9605,-0.2782;...
    -0.2782,0.9605];
% L2d =[5.4397,-4.6109;...
%     0.8780,3.0014;...
%     42.2300,66.0135;...
%     42.7257,71.5024;...
%     -0.6798,-0.1947;...
%     -0.1948,0.6798];
%     F1d = Ad - L1d*Hd;
%     F2d = Ad - L2d*Hd;
%         eigs(F1d) %Re(F1d)<0
%         eigs(F2d) %Re(F2d)<0

%     inv_H1d = eye(dim_n+dim_m)-expm(F1d*tau_max)*expm(-F2d*tau_max);
%     inv_H2d = eye(dim_n+dim_m)-expm(F2d*tau_max)*expm(-F1d*tau_max);
    
%     digits(10000);
%     
%     inv_H1d=vpa(inv_H1d);
%     inv_H1d=double(inv_H1d);
%     inv_H2d=vpa(inv_H2d);
%     inv_H2d=double(inv_H2d);
%     inv_H1d^(-1)+inv_H2d^(-1)
%         det(H1d) %\neq 0
%         det(H2d) %\neq 0

    TSPAN = [0 500];
    JSPAN = [0 10000];
    rule  = 1;
    xd_0 = [5;-5;5;-5;d]; %xi(:,1:dim_n+dim_m) disturbance should match the actual for the plant
    hxd1_0 = [ones(4,1);ones(2,1)]; %xi(:,dim_n+dim_m+1:2dim_n+2dim_m)
%     hxd2_0 = [zeros(4,1);zeros(2,1)]; %xi(:,2dim_n+2dim_m+1:3dim_n+3dim_m)
    xcd_0 = [zeros(4,1);zeros(2,1)]; %xi(:,3dim_n+3dim_m+1:4dim_n+4dim_m)
%     tau_0 = 0; %xi(:,4dim_n+4dim_m+1)
%     xd_0 = [rand(dim_n,1)*10-5;d]; %xi(:,1:dim_n+dim_m) disturbance should match the actual for the plant
%     hxd1_0 = [rand(dim_n,1)*10-5;0]; %xi(:,dim_n+dim_m+1:2dim_n+2dim_m)
%     hxd2_0 = [rand(dim_n,1)*10-5;0]; %xi(:,2dim_n+2dim_m+1:3dim_n+3dim_m)
%     xcd_0 = [rand(dim_n,1)*10-5;0]; %xi(:,3dim_n+3dim_m+1:4dim_n+4dim_m)
%     tau_0 = 0; %xi(:,4dim_n+4dim_m+1)
    xid_0 = [xd_0;hxd1_0;xcd_0];
    options = odeset('AbsTol',1e-6,'RelTol',1e-6,'InitialStep',eps);
    
    [td,jd,xid] = HyEQsolver(@F,@G,@C,@D,xid_0,TSPAN,JSPAN,rule,options);
    
    figure(1)
    subplot(2,3,1) %1st component of: state, obs1, obs2, pr
    plot(td,[xid(:,1) xid(:,dim_n+dim_m+1) xid(:,2*dim_n+2*dim_m+1)])
    legend('x_1','hx1_1','x_s1')
    subplot(2,3,2) %2nd component of: state, obs1, obs2, pr
    plot(td,[xid(:,2) xid(:,dim_n+dim_m+2) xid(:,2*dim_n+2*dim_m+2)])
    legend('x_2','hx1_2','x_s2')
    subplot(2,3,3) %3rd component of: state, obs1, obs2, pr
    plot(td,[xid(:,3) xid(:,dim_n+dim_m+3) xid(:,2*dim_n+2*dim_m+3)])
    legend('x_3','hx1_3','x_s3')
    subplot(2,3,4) %4th component of: state, obs1, obs2, pr
    plot(td,[xid(:,4) xid(:,dim_n+dim_m+4) xid(:,2*dim_n+2*dim_m+4)])
    legend('x_4','hx1_4','x_s4')
    subplot(2,3,5) %disturbance 1st component: real, obs1, obs2, pr
    plot(td,[xid(:,5) xid(:,dim_n+dim_m+5) xid(:,2*dim_n+2*dim_m+5)])
    legend('d_1','hd1_1','d_c_1')
    subplot(2,3,6) %disturbance 1st component: real, obs1, obs2, pr
    plot(td,[xid(:,6) xid(:,dim_n+dim_m+6) xid(:,2*dim_n+2*dim_m+6)])
    legend('d_2','hd1_2','d_c_2')
%     plot(td,[xid(:,4*dim_n+4*dim_m+1) jd])
%     legend('timer','events')
    
    figure(2)
%     out1 = zeros(size(td));
    out2 = zeros(size(td));
    for i=1:1:length(td)
        hxd1 = xid(i,dim_n+dim_m+1:2*dim_n+2*dim_m);
        xcd = xid(i,2*dim_n+2*dim_m+1:3*dim_n+3*dim_m);
%         tau = xid(i,4*dim_n+4*dim_m+1);
        
%         out1(i) = sensor.D(tau); %observer event
        out2(i) = ETM.D(hxd1',xcd'); %channel event
    end
    plot(td,out2)
    legend('G2')
    
    td_Hee_original=td;
    jd_Hee_original=jd;
    xid_Hee_original=xid;
    out2_Hee_original=out2;
    
    save data_Hee_original td_Hee_original jd_Hee_original xid_Hee_original out2_Hee_original
end    

function dxid = F(xid)
    global dim_n dim_m
    
    xd = xid(1:dim_n+dim_m);
    hxd1 = xid(dim_n+dim_m+1:2*dim_n+2*dim_m);
    xcd = xid(2*dim_n+2*dim_m+1:3*dim_n+3*dim_m);
    
    u = controller.output(xcd); %use predictor state
%     u = 0; %null
    dxd = plant.dynamics(xd,u);
    y = plant.output(xd);
    dhxd1 = sensor.dynamics_flow(hxd1,y,u);
    hxc = predictor.dynamics_flow(xcd,u);
    
    dxid = [dxd;dhxd1;hxc];
end

function next_xid = G(xid)
    global dim_n dim_m
    
    xd = xid(1:dim_n+dim_m);
    hxd1 = xid(dim_n+dim_m+1:2*dim_n+2*dim_m);
    xcd = xid(2*dim_n+2*dim_m+1:3*dim_n+3*dim_m);
    
    
%     out1 = sensor.D(tau); %observer event
%     out2 = ETM.D(hxd1,xcd); %channel event
    
%     [next_hxd1,next_hxd2] = sensor.dynamics_jump(hxd1,hxd2); %H1\xo[1]+H2\xo[2]
    next_xcd = predictor.dynamics_jump(hxd1); %\xo[1]
    
%     G1_xid = [xd;next_hxd1;next_hxd2;xcd;0];
    next_xid = [xd;hxd1;next_xcd];
    
%     if (out1 == 1) && (out2 == 0)
%         next_xid = G1_xid;
%     elseif (out1 == 0) && (out2 == 1)
%         next_xid = G2_xid;
%     else
%         index = round(rand(1))+1; %generate 1 or 2 randomly
%         next_xid = [G1_xid G2_xid];
%         next_xid = next_xid(:,index);
%     end
end

function out = C(xid)
    global dim_n dim_m
    
    xd = xid(1:dim_n+dim_m);
    hxd1 = xid(dim_n+dim_m+1:2*dim_n+2*dim_m);
    xcd = xid(2*dim_n+2*dim_m+1:3*dim_n+3*dim_m);
    
%     out1 = sensor.C(tau); %observer event
    out = ETM.C(hxd1,xcd); %channel event
    
%     out = out1 & out2;
end

function out = D(xid)
    global dim_n dim_m
    
    xd = xid(1:dim_n+dim_m);
    hxd1 = xid(dim_n+dim_m+1:2*dim_n+2*dim_m);
    xcd = xid(2*dim_n+2*dim_m+1:3*dim_n+3*dim_m);
    
%     out1 = sensor.D(tau); %observer event
    out = ETM.D(hxd1,xcd); %channel event
    
%     out = out1 | out2;
end