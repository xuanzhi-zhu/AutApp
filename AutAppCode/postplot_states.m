close all
clear all

% set(0,'defaulttextInterpreter','latex')

load data_ours_wo_q.mat td jd xid out2
load data_ours_w_q.mat td_w_q jd_w_q xid_w_q out23_w_q
load data_Hee_SOD.mat td_Hee_SOD jd_Hee_SOD xid_Hee_SOD out2_Hee_SOD
load data_Hee_original.mat td_Hee_original jd_Hee_original xid_Hee_original out2_Hee_original
load data_tt.mat td_tt jd_tt xid_tt out2_tt


x_vec = xid(:,1:4);
x_vec_w_q = xid_w_q(:,1:4);
x_vec_Hee_SOD = xid_Hee_SOD(:,1:4);
x_vec_Hee_original = xid_Hee_original(:,1:4);
x_vec_tt = xid_tt(:,1:4);

norm_x_vec=(sum(x_vec.^2,2)).^(1/2);
norm_x_vec_w_q=(sum(x_vec_w_q.^2,2)).^(1/2);
norm_x_vec_Hee_SOD=(sum(x_vec_Hee_SOD.^2,2)).^(1/2);
norm_x_vec_Hee_original=(sum(x_vec_Hee_original.^2,2)).^(1/2);
norm_x_vec_tt=(sum(x_vec_tt.^2,2)).^(1/2);

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
grey=[0.7 0.7 0.7];
lineWidth = 3;
markerSize = 5;

xlim = [0,33];
t_vec =0:1:xlim(2);

%%%=================================================================woQ
plot(td_tt,norm_x_vec_tt,'-x','Color',purple,'LineWidth',0.5.*lineWidth,'MarkerSize',markerSize);hold on;
plot(td_Hee_SOD,norm_x_vec_Hee_SOD,'LineWidth',lineWidth,'LineStyle','-.','Color',yellow);hold on;
plot(td_Hee_original,norm_x_vec_Hee_original,'LineWidth',lineWidth,'LineStyle',':','Color',green);hold on;
plot(td,norm_x_vec,'LineWidth',lineWidth,'LineStyle','-','Color',blue);hold on;
plot(td_w_q,norm_x_vec_w_q,'LineWidth',lineWidth,'LineStyle','--','Color',red);hold on;
plot(t_vec,3.351.*ones(length(t_vec),1),'-o','Color',grey,'LineWidth',0.5.*lineWidth,'MarkerSize',markerSize);
leg=legend({'Periodic time-triggered','Heemels et al. under ETM 1','Heemels et al.','$\mathcal{H}$ in Eqn. (6) under ETM 1','$\mathcal{H}^\prime$ in Eqn. (7) under ETM 2','$x\in\overline{\mathcal{A}}$'},'fontsize',12);
legend('boxoff')
leg.Orientation='vertical';
set(leg,...
    'Location','southwest')
pos = leg.Position;
set(leg,...
    'Position',pos+[-0.24 0 0 0])
grid on

ylabel('$|x|$','fontsize',12)

set(gca, 'YScale', 'log')
% yticks = ([1 10 100]);
% yticklabels({'10^0','10^1','10^2'})

ylim = [0 max(max(norm_x_vec(:,1)),max(max(norm_x_vec_w_q(:,1)),max(norm_x_vec_Hee_original(:,1))))];
ylim(2)=1.1*ylim(2);
% ylim = enlarge(ylim,1.1);
% xticks = ([0 1 2 3 4 5 6 7 8 9 10]);
% xticklabels({'0','1','2','3','4','5','6','7','8','9','10'})
set(gca,'xlim',xlim,'ylim',ylim)

xlabel('$t\,[s]$','fontsize',12)
ax = gca; % current axes
ax.FontSize = 12;

matlabfrag2('simu_state')