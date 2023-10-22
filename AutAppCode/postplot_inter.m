close all
clear all

% set(0,'defaulttextInterpreter','latex')

load data_ours_wo_q.mat td jd xid out2
load data_ours_w_q.mat td_w_q jd_w_q xid_w_q out23_w_q
load data_Hee_SOD.mat td_Hee_SOD jd_Hee_SOD xid_Hee_SOD out2_Hee_SOD
load data_Hee_original.mat td_Hee_original jd_Hee_original xid_Hee_original out2_Hee_original
load data_tt.mat td_tt jd_tt xid_tt out2_tt

layout = [1;1;1;1]*ones(1,8);
% h=create_axis(layout,15,...
%     'innerymargin',0.015,...
%     'botmargin',.13,...
%     'innerxmargin',0.06,...
%     'leftmargin',0.05);
h=create_axis(layout,18,...
    'innerymargin',0.018,...
    'botmargin',0.15,...
    'innerxmargin',0.015,...
    'leftmargin',0.1);
colors = get(gca,'colororder');
blue=colors(1,:);
red=colors(2,:);
yellow=colors(3,:);
purple=colors(4,:);
green=colors(5,:);
lineWidth = 3;
markerSize = 8;

xlim = [0,33];
% x_vec = xi(:,1:2);
% hx1_vec = xi(:,3:4);
% hx2_vec = xi(:,5:6);
% xc_vec = xi(:,7:8);
% tau_vec = xi(:,9);
% q_vec = xi(:,10);

t_event=td(out2==1);
t_inter=t_event-[0;t_event(1:end-1)];

t_event_w_q=td_w_q(out23_w_q==1);
t_inter_w_q=t_event_w_q-[0;t_event_w_q(1:end-1)];

t_event_Hee_SOD=td_Hee_SOD(out2_Hee_SOD==1);
t_inter_Hee_SOD=t_event_Hee_SOD-[0;t_event_Hee_SOD(1:end-1)];

t_event_Hee_original=td_Hee_original(out2_Hee_original==1);
t_inter_Hee_original=t_event_Hee_original-[0;t_event_Hee_original(1:end-1)];

t_event_tt=td_tt(out2_tt==1);
t_inter_tt=t_event_tt-[0;t_event_tt(1:end-1)];

% mean(t_inter)=0.0558;
% mean(t_inter_w_q)=0.1071;
% mean(t_inter_Hee_SOD)=0.0731;
% mean(t_inter_Hee_original)=0.2494;?35?

plot(t_event_tt,t_inter_tt,'x','Color',purple,'MarkerSize',markerSize);hold on;
plot(t_event_Hee_SOD,t_inter_Hee_SOD,'o','Color',yellow,'MarkerSize',markerSize);hold on;
plot(t_event_Hee_original,t_inter_Hee_original,'square','Color',green,'MarkerSize',markerSize);hold on;
plot(t_event,t_inter,'^','Color',blue,'MarkerSize',markerSize);hold on;
plot(t_event_w_q,t_inter_w_q,'v','Color',red,'MarkerSize',markerSize);hold on;
leg=legend({'Periodic time-triggered','Heemels et al. under ETM 1','Heemels et al.','$\mathcal{H}$ in Eqn. (6) under ETM 1','$\mathcal{H}^\prime$ in Eqn. (7) under ETM 2'},'fontsize',12);
legend('boxoff')
leg.Orientation='vertical';
set(leg,...
    'Location','northwest')
pos = leg.Position;
set(leg,...
    'Position',pos+[-0.25 -0.37 0 0])
grid on

ylabel('\text{Inter-sampling time}','fontsize',12)

ylim = [0 15];
ylim(2)=1.1*ylim(2);
% ylim = enlarge(ylim,1.1);
% xticks = ([0 1 2 3 4 5 6 7 8 9 10]);
% xticklabels({'0','1','2','3','4','5','6','7','8','9','10'})
set(gca,'xlim',xlim,'ylim',ylim)
xlabel('$t\,[s]$','fontsize',12)
ax = gca; % current axes
ax.FontSize = 12;

matlabfrag2('simu_inter')