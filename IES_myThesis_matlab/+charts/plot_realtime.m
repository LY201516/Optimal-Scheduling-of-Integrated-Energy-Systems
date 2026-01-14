% 实时阶段绘图
%% ========= SOC变化 =================================================
figure;
plot(SOC_bat_save3, 'b--*', 'LineWidth', 1.2, 'DisplayName', "电池SOC");
hold on; plot(SOC_hst_save3, 'g--^', 'LineWidth', 1.2, 'DisplayName', "储氢SOC");
hold on; plot(SOC_tst_save3, 'r-v', 'LineWidth', 1.5, 'DisplayName', "储热SOC");
hold on; plot(SOC_gst_save3, 'm-x', 'LineWidth', 1.5, 'DisplayName', "储气SOC");
legend;

%% ========= 掺氢比 =================================================
% 燃气轮机
rate_H2 = V_H2gt_save3 / (V_H2gt_save3 + V_g2gt_save3);
figure;
plot(V_H2gt_save3, 'b--*', 'LineWidth', 1.2, 'DisplayName', "氢气GT");
hold on; plot(V_g2gt_save3, 'g--^', 'LineWidth', 1.2, 'DisplayName', "天然气GT");
figure; plot(rate_H2, 'k-^', 'LineWidth', 1.2, 'DisplayName', "掺氢比GT");

% 燃气锅炉
rate_H2 = V_H2gb_save3 / (V_H2gb_save3 + V_g2gb_save3);
figure;
plot(V_H2gb_save3, 'b--*', 'LineWidth', 1.2, 'DisplayName', "氢气GB");
hold on; plot(V_g2gb_save3, 'g--^', 'LineWidth', 1.2, 'DisplayName', "天然气GB");
figure; plot(rate_H2, 'k-^', 'LineWidth', 1.2, 'DisplayName', "掺氢比GB");

%% ========= GT功率 =================================================
% 数据区
P_g2gt_da = repmat(P_g2gt_save1', 12, 1); P_g2gt_da = P_g2gt_da(:);
P_g2gt_di = repmat(P_g2gt_save2', 3, 1); P_g2gt_di = P_g2gt_di(:);
P_g2gt_rt = P_g2gt_save3;

% 绘图区
figure;
plot(P_g2gt_da, 'r--', 'LineWidth', 1.2, 'DisplayName', "日前GT");
hold on; plot(P_g2gt_di, 'b--', 'LineWidth', 1.2, 'DisplayName', "日内GT");
hold on; plot(P_g2gt_rt, 'k-', 'LineWidth', 1.2, 'DisplayName', "实时GT");

%% ========= GB功率 =================================================
% 数据区
P_g2gb_da = repmat(P_g2gb_save1', 12, 1); P_g2gb_da = P_g2gb_da(:);
P_g2gb_di = repmat(P_g2gb_save2', 3, 1); P_g2gb_di = P_g2gb_di(:);
P_g2gb_rt = P_g2gb_save3;

% 绘图区
figure;
plot(P_g2gb_da, 'r--', 'LineWidth', 1.2, 'DisplayName', "日前gb");
hold on; plot(P_g2gb_di, 'b--', 'LineWidth', 1.2, 'DisplayName', "日内gb");
hold on; plot(P_g2gb_rt, 'k-', 'LineWidth', 1.2, 'DisplayName', "实时gb");
legend;

%% ========= DR对比 =================================================
% ==================== 公共变量 ===================
time = 0:minutes(5):hours(24);
time = time(1:end-1);
time_ticks = 0:minutes(120):hours(24);
% 数据区
NoDR_Load_base = P_eLoad_5min;
DR_Load_da = P_eLoad_5min+L_edr_sl_in_save1_288 - L_edr_sl_out_save1_288;
DR_Load_di = P_eLoad_5min_pre - L_edr_cl_save1_288 + L_edr_sl_in_save1_288 - L_edr_sl_out_save1_288 - L_edr_cl_save2_288;
DR_Load_rt = P_eLoad_5min_pre - L_edr_cl_save1_288 + L_edr_sl_in_save1_288 - L_edr_sl_out_save1_288 - L_edr_cl_save2_288 - L_edr_cl_save3;
% 绘图区
figure;
set(gcf, Units='centimeters', Position=[2 2 40 10]);
set(gca, Position=[0.0681 0.1982 0.9291 0.7773]);            % 8月2号
plot(time, NoDR_Load_base, 'r--', LineWidth=1.5, DisplayName='基准负荷');
hold on; plot(time, DR_Load_da, 'm-', LineWidth=1.5, DisplayName='日前IDR');
hold on; plot(time, DR_Load_di, 'g-', LineWidth=1.5, DisplayName='日内IDR');
hold on; plot(time, DR_Load_rt, 'b-', LineWidth=1.5, DisplayName='实时IDR');
lgd = legend;
xticks(time_ticks);
xtickformat("hh:mm");
ax = gca; ax.XAxis.FontSize = 18; ax.YAxis.FontSize = 18;
% ylim = ax.YLim; ylin_start = ylim(1); ylim_end = ylim(2); ax.YLim = [ylin_start, ylim_end+0.26*ylim_end];
xlabel('时间', FontName='SimSun', FontSize=26);
ylabel('功率/kW', FontName='SimSun', FontSize=26);
set(lgd, NumColumns=6, Location='southeast', Orientation='horizontal', FontName='SimSun', FontSize=18);
grid("on"); grid("minor");


% 数据区
NoDR_Load_base = P_hLoad_5min;
DR_Load_da = P_hLoad_5min+L_edr_sl_in_save1_288 - L_edr_sl_out_save1_288;
DR_Load_di = P_hLoad_5min_pre - L_edr_cl_save1_288 + L_edr_sl_in_save1_288 - L_edr_sl_out_save1_288 - L_edr_cl_save2_288;
DR_Load_rt = P_hLoad_5min_pre - L_edr_cl_save1_288 + L_edr_sl_in_save1_288 - L_edr_sl_out_save1_288 - L_edr_cl_save2_288 - L_edr_cl_save3;
% 绘图区
figure;
set(gcf, Units='centimeters', Position=[2 2 40 10]);
set(gca, Position=[0.0607 0.2045 0.9291 0.7709]);            % 8月2号
plot(time, NoDR_Load_base, 'r--', LineWidth=1.5, DisplayName='基准负荷');
hold on; plot(time, DR_Load_da, 'm-', LineWidth=1.5, DisplayName='日前IDR');
hold on; plot(time, DR_Load_di, 'g-', LineWidth=1.5, DisplayName='日内IDR');
hold on; plot(time, DR_Load_rt, 'b-', LineWidth=1.5, DisplayName='实时IDR');
lgd = legend;
xticks(time_ticks);
xtickformat("hh:mm");
ax = gca; ax.XAxis.FontSize = 18; ax.YAxis.FontSize = 18;
% ylim = ax.YLim; ylin_start = ylim(1); ylim_end = ylim(2); ax.YLim = [ylin_start, ylim_end+0.26*ylim_end];
xlabel('时间', FontName='SimSun', FontSize=26);
ylabel('功率/kW', FontName='SimSun', FontSize=26);
set(lgd, NumColumns=6, Location='northeast', Orientation='horizontal', FontName='SimSun', FontSize=18);
grid("on"); grid("minor");

%% ========= DR调用量 =================================================
% ==================== 公共变量 ===================
time = 0:minutes(5):hours(24);
time = time(1:end-1);
time_ticks = 0:minutes(120):hours(24);

figure;
set(gcf, Units='centimeters', Position=[2 2 35 13]);
set(gca, Position=[0.0751 0.1551 0.8769 0.819]);            % 8月2号
yyaxis left;
plot(time, L_edr_sl_in_save1_288 - L_edr_sl_out_save1_288 - L_edr_sl_out_save1_288, 'm-', LineWidth=1.5, DisplayName='日前IDR调用量');
hold on; plot(time, -L_edr_cl_save2_288, 'g-', LineWidth=1.5, DisplayName='日内IDR调用量');
hold on; plot(time, -L_edr_cl_save3, 'b-', LineWidth=1.5, DisplayName='实时IDR调用量');
ylim([-200 100]);
ax = gca; ax.YColor=[0 0 0]; ax.FontSize=18;
ylabel('IDR调用量/kW', FontName='SimSun', FontSize=26);


yyaxis right;
hold on; plot(time, c_pur_e_288, 'r--', LineWidth=1.5, DisplayName='电价');
hold on; plot(time, c_pur_g_288, 'k--', LineWidth=1.5, DisplayName='气价');
lgd = legend;
ylim([0 5]);
ax = gca; ax.YColor=[0 0 0]; 
ylabel('电价/元/kWh-气价/元/m3', FontName='SimSun', FontSize=26);

xlabel('时间', FontName='SimSun', FontSize=26);
xticks(time_ticks);
xtickformat("hh:mm");
set(lgd, NumColumns=6, Location='northeast', Orientation='horizontal', FontName='SimSun', FontSize=18);
grid("on"); grid("minor");


%% ========= 功率调度结果 ====================================================================================================
% ==================== 公共变量 ===================
time = 0:minutes(5):hours(24);
time = time(1:end-1);
time_ticks = 0:minutes(120):hours(24);
% ==================== 电功率平衡图片 ===================
P_eBalanceGen_3 = P_BalanceGen_3{1};    % {}为直接取出矩阵，()返回的依旧是一个元胞数组
P_eBalanceCon_3 = P_BalanceCon_3{1};
newcolor1 = [
    "#C74D26", "#B092B6", "#E38D26", "#CAC1D4", "#F1CC74", "#5F9C61",...
    "#5EA7B8", "#AED2E2", "#308192", "#A4C97C", "#AE42E3"];
figure;
set(gcf, Units='centimeters', Position=[2 2 30 20]);
set(gca, Position=[0.0837 0.0843 0.8928 0.907]);            % 8月2号
bar(time, P_eBalanceGen_3, "stacked", EdgeColor='none');
hold('on'); bar(time, -P_eBalanceCon_3, "stacked", EdgeColor='none');
colororder(newcolor1);
xticks(time_ticks);
xtickformat("hh:mm");
ax = gca; ax.XAxis.FontSize = 16; ax.YAxis.FontSize = 16;
ylim = ax.YLim; ylin_start = ylim(1); ylim_end = ylim(2); ax.YLim = [ylin_start, ylim_end+0.26*ylim_end];
xlabel('时间', FontName='SimSun', FontSize=20);
ylabel('功率/kW', FontName='SimSun', FontSize=20);
lgd = legend("电网购电", "WT发电", "PV发电", "GT发电", "HFC发电", "Bat放电", "电负荷", "EL用电", "EB用电", "CCS用电", "Bat充电");
set(lgd, NumColumns=6, Location='northwest', Orientation='horizontal', FontName='SimSun', FontSize=16);
grid("on"); grid("minor");

% ==================== 热功率平衡图片 ===================
P_hBalanceGen_3 = P_BalanceGen_3{2};
P_hBalanceCon_3 = P_BalanceCon_3{2};
newcolor2 = ["#B092B6", "#E38D26", "#5F9C61", "#CAC1D4", "#A4C97C",...
    "#C74D26", "#F1CC74"];
figure;
set(gcf, Units='centimeters', Position=[2 2 30 20]);
set(gca, Position=[0.0753 0.0843 0.8928 0.907]); 
bar(time, P_hBalanceGen_3, "stacked", EdgeColor='none');
hold('on'); bar(time, -P_hBalanceCon_3, "stacked", EdgeColor='none');
colororder(newcolor2);
xticks(time_ticks);
xtickformat("hh:mm");
ax = gca; ax.XAxis.FontSize = 16; ax.YAxis.FontSize = 16;
ylim = ax.YLim; ylin_start = ylim(1); ylim_end = ylim(2); ax.YLim = [ylin_start, ylim_end+0.18*ylim_end];
xlabel('时间', FontName='SimSun', FontSize=20);
ylabel('功率/kW', FontName='SimSun', FontSize=20);
lgd = legend("GT供热", "GB供热", "HFC供热", "EB供热", "TST供热", "热负荷", "TST储热");
set(lgd, NumColumns=5, Location='northwest', Orientation='horizontal', FontName='SimSun', FontSize=16);
grid("on"); grid("minor");

% ==================== 气功率平衡图片 ===================
P_gBalanceGen_3 = P_BalanceGen_3{4};
P_gBalanceCon_3 = P_BalanceCon_3{4};
newcolor4 = ["#B092B6", "#5EA7B8", "#AED2E2",...
    "#E38D26", "#F1CC74", "#CAC1D4"];
figure;
set(gcf, Units='centimeters', Position=[2 2 30 20]);
set(gca, Position=[0.0753 0.0843 0.8928 0.907]); 
bar(time, P_gBalanceGen_3, "stacked", EdgeColor='none');
hold('on'); bar(time, -P_gBalanceCon_3, "stacked", EdgeColor='none');
colororder(newcolor4);
xticks(time_ticks);
xtickformat("hh:mm");
ax = gca; ax.XAxis.FontSize = 16; ax.YAxis.FontSize = 16;
ylim = ax.YLim; ylin_start = ylim(1); ylim_end = ylim(2); ax.YLim = [ylin_start, ylim_end+0.26*ylim_end];
xlabel('时间', FontName='SimSun', FontSize=20);
ylabel('功率/kW', FontName='SimSun', FontSize=20);
lgd = legend("气网购气", "MR产气", "GST供气", "GT耗气", "GB耗气", "GST储气");
set(lgd, NumColumns=3, Location='northwest', Orientation='horizontal', FontName='SimSun', FontSize=16);
grid("on"); grid("minor");

% ==================== 氢功率平衡图片 ===================
P_HBalanceGen_3 = P_BalanceGen_3{3};
P_HBalanceCon_3 = P_BalanceCon_3{3};
newcolor3 = ["#5F9C61", "#A4C97C",...
    "#B092B6", "#308192", "#5EA7B8", "#AED2E2", "#CAC1D4"];
figure;
set(gcf, Units='centimeters', Position=[2 2 30 20]);
set(gca, Position=[0.0866 0.0843 0.8878 0.9027]); 
bar(time, P_HBalanceGen_3, "stacked", EdgeColor='none');
hold('on'); bar(time, -P_HBalanceCon_3, "stacked", EdgeColor='none');
colororder(newcolor3);
xticks(time_ticks);
xtickformat("hh:mm");
ax = gca; ax.XAxis.FontSize = 16; ax.YAxis.FontSize = 16;
% ylim = ax.YLim; ylin_start = ylim(1); ylim_end = ylim(2); ax.YLim = [ylin_start, ylim_end+0.26*ylim_end];
xlabel('时间', FontName='SimSun', FontSize=20);
ylabel('功率/kW', FontName='SimSun', FontSize=20);
lgd = legend("EL产氢", "HST供氢", "HFC耗氢", "MR耗氢", "GT耗氢", "GB耗氢", "HST储氢");
set(lgd, NumColumns=8, Location='northwest', Orientation='horizontal', FontName='SimSun', FontSize=16);
grid("on"); grid("minor");



