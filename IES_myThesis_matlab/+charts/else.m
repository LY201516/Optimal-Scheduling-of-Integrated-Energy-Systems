%% ========= 1年源荷曲线 =================================================
% 单位：计算时功率（kW）
% 仿真数据由matlab自动导入
clear; close; clc; 
currentPath  = pwd;
PATH_ROOT = fileparts(currentPath);      % S:\Thesis\0.自己毕业论文
PATH = fullfile(PATH_ROOT, '仿真数据集');

% ===== 风力发电机组出力数据 =====
path_wt2e = fullfile(PATH, "WT2e.xlsx");
P_wt2e_1h_year = readmatrix(path_wt2e, Sheet='WT2e-1h', Range=[2, 3]);
% ===== 光伏发电机组出力数据 =====
path_pv2e = fullfile(PATH, "PV2e.xlsx");
P_pv2e_1h_year = readmatrix(path_pv2e, Sheet='PV2e-1h', Range=[2, 3]);
% ===== 电负荷数据 =====
path_eLoad = fullfile(PATH, "eLoad.xlsx");
P_eLoad_1h_year = readmatrix(path_eLoad, Sheet='eLoad-1h', Range=[2, 3]);
% ===== 热负荷数据 =====
path_hLoad = fullfile(PATH, "hLoad.xlsx");
P_hLoad_1h_year = readmatrix(path_hLoad, Sheet='hLoad-1h', Range=[2, 3]);

figure;
set(gcf, Units="centimeters", Position=[2 2 20 9]);
set(gca, Position=[0.093 0.156 0.879 0.82]); 
% plot(P_wt2e_1h_year, LineWidth=1.2, Color="#43CAD8");        % 风机出力
% plot(P_pv2e_1h_year, LineWidth=1.2, Color="#43D885");        % 光伏出力
% plot(P_eLoad_1h_year, LineWidth=1.2, Color="#43A7D8");       % 电负荷
plot(P_hLoad_1h_year, LineWidth=1.2, Color="#D55541");       % 热负荷
ax = gca;
ax.XAxis.FontSize = 12;
ax.YAxis.FontSize = 12;
xlabel('时间/h', FontName='SimSun', FontSize=16);
ylabel('功率/kW', FontName='SimSun', FontSize=16');
xticks([0 1000 2000 3000 4000 5000 6000 7000 8000 8760]);
xlim([0 8760]);
grid("on"); 
%% ========= 某天三层预测曲线 =================================================
time = 0:minutes(5):hours(24);
time = time(1:end-1);
time_ticks = 0:minutes(240):hours(24);
% 风机出力
P_wt2e_1h_288 = repmat(P_wt2e_1h_pre', 12, 1); P_wt2e_1h_288 = reshape(P_wt2e_1h_288, [], 1);
P_wt2e_15min_288 = repmat(P_wt2e_15min_pre', 3, 1); P_wt2e_15min_288 = reshape(P_wt2e_15min_288, [], 1);
P_wt2e_5min_288 = P_wt2e_5min_pre;
% 光伏出力
P_pv2e_1h_288 = repmat(P_pv2e_1h_pre', 12, 1); P_pv2e_1h_288 = reshape(P_pv2e_1h_288, [], 1);
P_pv2e_15min_288 = repmat(P_pv2e_15min_pre', 3, 1); P_pv2e_15min_288 = reshape(P_pv2e_15min_288, [], 1);
P_pv2e_5min_288 = P_pv2e_5min_pre;
% 电负荷
P_eLoad_1h_288 = repmat(P_eLoad_1h_pre', 12, 1); P_eLoad_1h_288 = reshape(P_eLoad_1h_288, [], 1);
P_eLoad_15min_288 = repmat(P_eLoad_15min_pre', 3, 1); P_eLoad_15min_288 = reshape(P_eLoad_15min_288, [], 1);
P_eLoad_5min_288 = P_eLoad_5min_pre;
% 热负荷
P_hLoad_1h_288 = repmat(P_hLoad_1h_pre', 12, 1); P_hLoad_1h_288 = reshape(P_hLoad_1h_288, [], 1);
P_hLoad_15min_288 = repmat(P_hLoad_15min_pre', 3, 1); P_hLoad_15min_288 = reshape(P_hLoad_15min_288, [], 1);
P_hLoad_5min_288 = P_hLoad_5min_pre;

figure;
set(gcf, Units="centimeters", Position=[2 2 20 9]);
set(gca, Position=[0.08 0.154 0.905 0.823]);      % 热负荷 
% --------------------------------------------------------------------------
plot(time, P_wt2e_1h_288, LineWidth=1.5, Color="#0072BD");
hold("on"); plot(time, P_wt2e_15min_288, LineWidth=1.5, color="#77AC30");
hold("on"); plot(time, P_wt2e_5min_288, LineWidth=1.5, Color="#D95319");
% --------------------------------------------------------------------------
% plot(time, P_pv2e_1h_288, LineWidth=1.5, Color="#0072BD");
% hold("on"); plot(time, P_pv2e_15min_288, LineWidth=1.5, color="#77AC30");
% hold("on"); plot(time, P_pv2e_5min_288, LineWidth=1.5, Color="#D95319");
% --------------------------------------------------------------------------
% plot(time, P_eLoad_1h_288, LineWidth=1.5, Color="#0072BD");
% hold("on"); plot(time, P_eLoad_15min_288, LineWidth=1.5, color="#77AC30");
% hold("on"); plot(time, P_eLoad_5min_288, LineWidth=1.5, Color="#D95319");
% --------------------------------------------------------------------------
% plot(time, P_hLoad_1h_288, LineWidth=1.5, Color="#0072BD");
% hold("on"); plot(time, P_hLoad_15min_288, LineWidth=1.5, color="#77AC30");
% hold("on"); plot(time, P_hLoad_5min_288, LineWidth=1.5, Color="#D95319");
% --------------------------------------------------------------------------
xticks(time_ticks);
xtickformat("hh:mm")
ax = gca;
ax.XAxis.FontSize = 12;
ax.YAxis.FontSize = 12;
xlabel('时间', FontName='SimSun', FontSize=16);
ylabel('功率/kW', FontName='SimSun', FontSize=16');
legend(ax, {"日前", "日内", "实时"}, FontName='SimSun', FontSize=12);
grid("on");
%% ========= 典型日工况曲线 =================================================
% 8月2号、3月25号
time = hours(1):hours(1):hours(24);
% time = time(1:end-1);
time_ticks = 0:hours(4):hours(24);

figure;
set(gcf, Units="centimeters", Position=[2 2 20 9]);
set(gca, Position=[0.093 0.156 0.879 0.82]); 
plot(time, P_wt2e_1h, LineWidth=1.5, Color="#C22AD0");        % 风机出力
hold on; plot(time, P_pv2e_1h, LineWidth=1.5, Color="#43D885");        % 光伏出力
hold on; plot(time, P_eLoad_1h, LineWidth=1.5, Color="#43A7D8");       % 电负荷
hold on; plot(time, P_hLoad_1h, LineWidth=1.5, Color="#D55541");       % 热负荷
xticks(time_ticks);
xtickformat("hh:mm")
xlim([hours(0), hours(24)]);
ax = gca;
ax.XAxis.FontSize = 12;
ax.YAxis.FontSize = 12;
xlabel('时间', FontName='SimSun', FontSize=16);
ylabel('功率/kW', FontName='SimSun', FontSize=16');
legend(ax, {"风机出力", "光伏出力", "电负荷", "热负荷"}, FontName='SimSun', FontSize=12, Location='northwest');
grid("on"); 






