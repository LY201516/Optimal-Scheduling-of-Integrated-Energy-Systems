% 单位：计算时功率（kW）
% 仿真数据由matlab自动导入
clear; close; clc; 
currentPath  = pwd;
PATH_ROOT = fileparts(currentPath);      % S:\Thesis\0.自己毕业论文
PATH = fullfile(PATH_ROOT, '仿真数据集');

% ===== 风力发电机组出力数据 =====
path_wt2e = fullfile(PATH, "WT2e.xlsx");
P_wt2e_1h_year = readmatrix(path_wt2e, Sheet='WT2e-1h', Range=[2, 3]);
P_wt2e_30min_year = readmatrix(path_wt2e, Sheet='WT2e-30min', Range=[2, 3]);
P_wt2e_15min_year = readmatrix(path_wt2e, Sheet='WT2e-15min', Range=[2, 3]);
P_wt2e_5min_year = readmatrix(path_wt2e, Sheet='WT2e-5min', Range=[2, 3]);

% ===== 光伏发电机组出力数据 =====
path_pv2e = fullfile(PATH, "PV2e.xlsx");
P_pv2e_1h_year = readmatrix(path_pv2e, Sheet='PV2e-1h', Range=[2, 3]);
P_pv2e_30min_year = readmatrix(path_pv2e, Sheet='PV2e-30min', Range=[2, 3]);
P_pv2e_15min_year = readmatrix(path_pv2e, Sheet='PV2e-15min', Range=[2, 3]);
P_pv2e_5min_year = readmatrix(path_pv2e, Sheet='PV2e-5min', Range=[2, 3]);

% ===== 电负荷数据 =====
path_eLoad = fullfile(PATH, "eLoad.xlsx");
P_eLoad_1h_year = readmatrix(path_eLoad, Sheet='eLoad-1h', Range=[2, 3]);
P_eLoad_30min_year = readmatrix(path_eLoad, Sheet='eLoad-30min', Range=[2, 3]);
P_eLoad_15min_year = readmatrix(path_eLoad, Sheet='eLoad-15min', Range=[2, 3]);
P_eLoad_5min_year = readmatrix(path_eLoad, Sheet='eLoad-5min', Range=[2, 3]);

% ===== 热负荷数据 =====
path_hLoad = fullfile(PATH, "hLoad.xlsx");
P_hLoad_1h_year = readmatrix(path_hLoad, Sheet='hLoad-1h', Range=[2, 3]);
P_hLoad_30min_year = readmatrix(path_hLoad, Sheet='hLoad-30min', Range=[2, 3]);
P_hLoad_15min_year = readmatrix(path_hLoad, Sheet='hLoad-15min', Range=[2, 3]);
P_hLoad_5min_year = readmatrix(path_hLoad, Sheet='hLoad-5min', Range=[2, 3]);


%% ****** 一、仿真参数 ***************************************
%% ======== 0.preference setting ===================================
day_sim = '3-25';
Times_Dayahead = 24;                   % 24h-1h
Times_Dayin = 16;                      % 4h-15min, 1h滚动一次
Times_Realtime = 6;                    % 30min-5min, 15min滚动一次

IF_VALUE_Dayahead = 1;                 % 打开日前阶段8.查看24h-1h求解值开关，1为开，0为关
IF_VALUE_Dayin = 1;
IF_VALUE_Realtime = 1;

zero_tiny = @(x) x .* (abs(x)>1e-10);     % 由于计算机计算的精度问题，当数值很小如e-14时，手动赋值为0
P_eBalanceGen_1 = []; P_eBalanceCon_1 = []; P_hBalanceGen_1 = []; P_hBalanceCon_1 = []; 
P_HBalanceGen_1 = []; P_HBalanceCon_1 = []; P_gBalanceGen_1 = []; P_gBalanceCon_1 = []; 
IF_ResultPlot_Dayahead = 0; 
IF_ResultPlot_Dayin = 1;
IF_ResultPlot_Realtime = 1;

%% ======== 1.源荷数据 ===================================
[P_wt2e_1h, P_wt2e_30min, P_wt2e_15min, P_wt2e_5min] = utils.readxDayData(day_sim, P_wt2e_1h_year, P_wt2e_30min_year, P_wt2e_15min_year, P_wt2e_5min_year);
[P_pv2e_1h, P_pv2e_30min, P_pv2e_15min, P_pv2e_5min] = utils.readxDayData(day_sim, P_pv2e_1h_year, P_pv2e_30min_year, P_pv2e_15min_year, P_pv2e_5min_year);
[P_eLoad_1h, P_eLoad_30min, P_eLoad_15min, P_eLoad_5min] = utils.readxDayData(day_sim, P_eLoad_1h_year, P_eLoad_30min_year, P_eLoad_15min_year, P_eLoad_5min_year);
[P_hLoad_1h, P_hLoad_30min, P_hLoad_15min, P_hLoad_5min] = utils.readxDayData(day_sim, P_hLoad_1h_year, P_hLoad_30min_year, P_hLoad_15min_year, P_hLoad_5min_year);

% ==================== 数据预处理（正态分布误差）====================
[P_wt2e_1h_pre, ~] = utils.forecast_with_error(P_wt2e_1h, 0.2); 
[P_wt2e_15min_pre, ~] = utils.forecast_with_error(P_wt2e_15min, 0.1);
[P_wt2e_5min_pre, ~] = utils.forecast_with_error(P_wt2e_5min, 0.05);
% 真实-预测绘图
% utils.plot_actANDforecast(P_wt2e_1h, P_wt2e_1h_pre, "风机 1h 尺度真实-预测对比（20%）");
% utils.plot_actANDforecast(P_wt2e_15min, P_wt2e_15min_pre, "风机 15min 尺度真实-预测对比（10%）");
% utils.plot_actANDforecast(P_wt2e_5min, P_wt2e_5min_pre, "风机 5min 尺度真实-预测对比（5%）");

[P_pv2e_1h_pre, ~] = utils.forecast_with_error(P_pv2e_1h, 0.15); 
[P_pv2e_15min_pre, ~] = utils.forecast_with_error(P_pv2e_15min, 0.07);
[P_pv2e_5min_pre, ~] = utils.forecast_with_error(P_pv2e_5min, 0.04);
% 真实-预测绘图
% utils.plot_actANDforecast(P_pv2e_1h, P_pv2e_1h_pre, "光伏 1h 尺度真实-预测对比（15%）");
% utils.plot_actANDforecast(P_pv2e_15min, P_pv2e_15min_pre, "光伏 15min 尺度真实-预测对比（7%）");
% utils.plot_actANDforecast(P_pv2e_5min, P_pv2e_5min_pre, "光伏 5min 尺度真实-预测对比（4%）");

[P_eLoad_1h_pre, ~] = utils.forecast_with_error(P_eLoad_1h, 0.05); 
[P_eLoad_15min_pre, ~] = utils.forecast_with_error(P_eLoad_15min, 0.02);
[P_eLoad_5min_pre, ~] = utils.forecast_with_error(P_eLoad_5min, 0.005);
% 真实-预测绘图
% utils.plot_actANDforecast(P_eLoad_1h, P_eLoad_1h_pre, "电负荷 1h 尺度真实-预测对比（5%）");
% utils.plot_actANDforecast(P_eLoad_15min, P_eLoad_15min_pre, "电负荷 15min 尺度真实-预测对比（2%）");
% utils.plot_actANDforecast(P_eLoad_5min, P_eLoad_5min_pre, "电负荷 5min 尺度真实-预测对比（0.5%）");

[P_hLoad_1h_pre, ~] = utils.forecast_with_error(P_hLoad_1h, 0.05); 
[P_hLoad_15min_pre, ~] = utils.forecast_with_error(P_hLoad_15min, 0.02);
[P_hLoad_5min_pre, ~] = utils.forecast_with_error(P_hLoad_5min, 0.005);
% 真实-预测绘图
% utils.plot_actANDforecast(P_hLoad_1h, P_hLoad_1h_pre, "热负荷 1h 尺度真实-预测对比（5%）");
% utils.plot_actANDforecast(P_hLoad_15min, P_hLoad_15min_pre, "热负荷 15min 尺度真实-预测对比（2%）");
% utils.plot_actANDforecast(P_hLoad_5min, P_hLoad_5min_pre, "热负荷 5min 尺度真实-预测对比（0.5%）");

%% ======== 2.设备参数 ===================================
% ==================== 负荷参数 ====================
P_eLoad_1 = P_eLoad_1h_pre;
P_hLoad_1 = P_hLoad_1h_pre;

% ==================== 风机WT、光伏PV ====================
P_wt2e_max_1 = P_wt2e_1h_pre;          % 风机出力上限1100（kW）
P_pv2e_max_1 = P_pv2e_1h_pre;          % 光伏出力上限2000（kW）

% -------------------- 绘图查看趋势 --------------------
utils.plot_trend(P_wt2e_1h, P_pv2e_1h, P_eLoad_1h, P_hLoad_1h);        % 真实值
utils.plot_trend(P_wt2e_max_1, P_pv2e_max_1, P_eLoad_1, P_hLoad_1);    % 预测值

% ==================== 购能限制 ====================
P_pur_e_max = 4000;                    % 购电上限（kW）eg: 8000
P_pur_g_max = 500;                     % 购气上限（kW）eg: 2000
% ==================== 电解槽EL ====================
f_el = 0.88;                           % EL电转氢效率（参考英文一区论文）
P_el_min = 0;                          % EL输入功率下限
P_el_max = 1500;                       % EL输入功率上限                      
LHV_H2 = 33.3;                         % 氢气热值（kWh/kg）
Delta_el = 0.3;                        % 设备爬升功率比例

% ==================== 甲烷反应器MR ====================
f_mr = 0.6;                            % MR氢转气效率（参考英文一区论文）
P_mr_min = 0;                          % MR输入功率下限（kW）
P_mr_max = 1500;                       % MR输入功率上限（kW）800
LHV_CH4 = 13.3;                        % CH4热值（kWh/kg）
w_mr = 2.9;                            % 生成单位质量CH4消耗的CO2的比例
Delta_mr = 0.2;                        % 设备爬升功率比例

% ==================== 氢燃料电池HFC ====================
f_hfc_H2e = 0.5;                       % HFC氢转电效率（参考中文期刊）
f_hfc_H2h = 0.4;                       % HFC氢转热效率（参考中文期刊）
P_hfc_min = 0;                         % HFC输入功率下限（kW）
P_hfc_max = 1000;                      % HFC输入功率上限（kW）
Delta_hfc = 1;                         % 设备爬升功率比例

% ==================== 燃气轮机GT ====================
f_gt_g2e = 0.45;                       % GT气转电效率（参考英文一区期刊）
f_gt_g2h = 0.4;                        % GT气转热效率（参考英文一区期刊）
P_gt_min = 0;                          % GT输入功率下限（kW）
P_gt_max = 2000;                       % GT输入功率上限（kW）
density_H2 = 0.082;                    % 氢气密度（kg/m3）
density_CH4 = 0.68;                    % 天然气密度（kg/m3）
k_H2gt_upper = 0.2;                    % GT掺氢体积分数比例
k_H2gt_lower = 0;                      % GT掺氢体积分数比例 0.1
Delta_gt = 0.2;                        % 设备爬升功率比例

% ==================== 燃气锅炉GB ====================
f_gb = 0.95;                           % GB气转热效率（参考英文一区期刊）
P_gb_min = 0;                          % GB输入功率下限（kW）
P_gb_max = 1000;                       % GB输入功率上限（kW）
k_H2gb_upper = 0.2;                    % GB掺氢体积分数比例上限
k_H2gb_lower = 0;                      % GB掺氢体积分数比例下限 0.1 
Delta_gb = 0.2;                        % 设备爬升功率比例

% ==================== 电锅炉EB ====================
f_eb = 0.98;                           % EB电转热效率（参考中文期刊）
P_eb_min = 0;                          % EB输入功率下限（kW）
P_eb_max = 400;                        % EB输入功率上限（kW）eg: 200 400
Delta_eb = 1;                          % 设备爬升功率比例

% ==================== 碳捕集CCUS ====================
f_ccus = 0.7;                         % 捕获单位质量的CO2所消耗的电能
% ==================== 储电Battery ====================
Q_bat_max = 200;                       % 最大容量（kWh）eg: 200 1000
f_bat_init = 0.4;                      % SOC初始
f_bat_min = 0.2;                       % SOC下限
f_bat_max = 0.8;                       % SOC上限
f_bat_cha = 0.95;                      % 充能效率
f_bat_dis = 0.95;                      % 放能效率

% ==================== 储氢HST ====================
Q_hst_max = 1000;                      % 最大容量（kWh）eg: 2000 6000
f_hst_init = 0.4;                      % SOC初始
f_hst_min = 0.2;                       % SOC下限
f_hst_max = 0.8;                       % SOC上限
f_hst_cha = 0.95;                      % 充能效率
f_hst_dis = 0.95;                      % 放能效率

% ==================== 储热TST ====================
Q_tst_max = 200;                       % 最大容量（kWh）eg: 200 500 800
f_tst_init = 0.4;                      % SOC初始
f_tst_min = 0.2;                       % SOC下限
f_tst_max = 0.8;                       % SOC上限
f_tst_cha = 0.95;                      % 充能效率
f_tst_dis = 0.95;                      % 放能效率

% ==================== 储气GST ====================
Q_gst_max = 200;                       % 最大容量（kWh）eg: 1200 1500
f_gst_init = 0.4;                      % SOC初始
f_gst_min = 0.2;                       % SOC下限
f_gst_max = 0.8;                       % SOC上限
f_gst_cha = 0.95;                      % 充能效率
f_gst_dis = 0.95;                      % 放能效率
% ==================== 需求响应DR ====================
% 可削减负荷
L_edr_cl_max_1 = 50;                   % 日前电负荷可调容量最大值（kW）90
L_edr_cl_max_2 = 30;                   % 日内电负荷可调容量最大值（kW）60
L_edr_cl_max_3 = 10;                   % 实时电负荷可调容量最大值（kW）25
L_hdr_cl_max_1 = 15;                   % 日前热负荷可调容量最大值（kW）30
L_hdr_cl_max_2 = 10;                   % 日内热负荷可调容量最大值（kW）20
L_hdr_cl_max_3 = 5;                    % 实时热负荷可调容量最大值（kW）10
% 可转移负荷
L_edr_sl_in_max_1 = 50;                % 100             
L_hdr_sl_in_max_1 = 10;                % 40             
prop_edr_sl_out_1 = 0.05;              % 0.2
prop_hdr_sl_out_1 = 0.05;              % 0.2
% ==================== 阶梯碳交易 ====================
% 碳排放配额参数
w_e2pur = 0.728;                       % 电网购电碳配额（kg/kWh）      
w_h = 0.3672;                          % 单位热功率的碳排放配额（kg/kWh）
phi_eh = 1.667;                        % 单位电功率换算为单位热功率的折算系数
% 实际碳排放参数
k_SC_a = 28.5;                         % 电网购电，燃煤机组碳排系数
k_SC_b = -0.45;
k_SC_c = 0.012;
k_gas_a = 2.5;                         % 燃气机组碳排放系数
k_gas_b = -0.005;
k_gas_c = 0.002;
% 阶梯碳交易参数
lambda_lad = 0.25;                     % 基价 eg: 0.25/kg
d_lad = 4000;                          % 增长区间（kg）
alpha_lad = 0.25;                      % 价格增长率（%）


%% ======== 3.成本参数 ===================================
% ==================== 运维成本 ====================
c_opm_wt = 0.012;
c_opm_pv = 0.01;
c_opm_el = 0.045;                      % 参考论文+查资料，人为指定成本参数
c_opm_hfc = 0.05;
c_opm_gt = 0.04;
c_opm_gb = 0.04;
c_opm_eb = 0.026;
% ==================== 购能成本 ====================
c_pur_e = [0.385,  0.385,  0.385,  0.385,  0.385,  0.754,  0.754,  1.02,  1.02,  1.02,  1.02,  1.02,...
           1.02,   1.02,   1.02,   1.02,   0.754,  0.754,  1.02,  1.02,  1.02,  0.754,  0.754,  0.385];
c_pur_g = [2.3,  2.3,  2.3,  2.3,  2.3,  2.3,  2.3,  3.5,  3.5,  3.5,  3.5,  3.5,...
           3.0,  3.0,  3.0,  3.0,  3.5,  3.5,  3.0,  3.0,  3.0,  2.3,  2.3,  2.3];
% ==================== 弃能成本 ====================
c_abd_wt = 0.65;                       % 弃风单价0.65
c_abd_pv = 0.65;                       % 弃光单价0.65
% ==================== 储能成本 ====================
c_st_bat = 0.01;
c_st_hst = 0.01;
c_st_tst = 0.01;
c_st_gst = 0.01;
% ==================== 日内调整成本 ====================
c_adj_2 = 0.2;                         % 日内调整成本（元/kWh） 
c_adj_3 = 0.3;                         % 实时调整成本（元/kWh） 

% ==================== DR补偿成本 ====================
% 可削减负荷
c_edr_cl_1 = 0.8;                      % 日前可削减电负荷DR补偿单价  
c_edr_cl_2 = 0.95;                     % 日内可削减电负荷DR补偿单价  
c_edr_cl_3 = 1.2;                      % 实时可削减电负荷DR补偿单价  
c_hdr_cl_1 = 0.5;                      % 日前可削减热负荷DR补偿单价  
c_hdr_cl_2 = 0.65;                     % 日内可削减热负荷DR补偿单价  
c_hdr_cl_3 = 0.8;                      % 实时可削减热负荷DR补偿单价  
% 可转移负荷
c_edr_sl_1 = 0.6;                      % 日前可转移电负荷DR补偿单价 0.6
c_hdr_sl_1 = 0.1;                      % 日前可转移热负荷DR补偿单价 0.1

%% ****** 二、日前阶段 *************************************** 
%% ======== 1.决策变量定义 ===================================
% -----------------------------------------------------------------风机光伏决策变量定义
P_wt2e_1 = sdpvar(Times_Dayahead, 1, 'full'); P_wt2e_save1 = zeros(Times_Dayahead, 1);               
P_pv2e_1 = sdpvar(Times_Dayahead, 1, 'full'); P_pv2e_save1 = zeros(Times_Dayahead, 1);

% -----------------------------------------------------------------设备决策变量定义
P_e2el_1 = sdpvar(Times_Dayahead, 1, 'full'); P_e2el_save1 = zeros(Times_Dayahead, 1);
P_el2H_1 = sdpvar(Times_Dayahead, 1, 'full'); P_el2H_save1 = zeros(Times_Dayahead, 1);

P_H2mr_1 = sdpvar(Times_Dayahead, 1, 'full'); P_H2mr_save1 = zeros(Times_Dayahead, 1);
P_mr2g_1 = sdpvar(Times_Dayahead, 1, 'full'); P_mr2g_save1 = zeros(Times_Dayahead, 1);

P_H2hfc_1 = sdpvar(Times_Dayahead, 1, 'full'); P_H2hfc_save1 = zeros(Times_Dayahead, 1);
P_hfc2e_1 = sdpvar(Times_Dayahead, 1, 'full'); P_hfc2e_save1 = zeros(Times_Dayahead, 1);
P_hfc2h_1 = sdpvar(Times_Dayahead, 1, 'full'); P_hfc2h_save1 = zeros(Times_Dayahead, 1);

P_g2gt_1 = sdpvar(Times_Dayahead, 1, 'full'); P_g2gt_save1 = zeros(Times_Dayahead, 1); % 氢气和天然气的混合气体
V_H2gt_1 = sdpvar(Times_Dayahead, 1, 'full'); V_H2gt_save1 = zeros(Times_Dayahead, 1); P_H2gt_save1 = zeros(Times_Dayahead, 1);
V_g2gt_1 = sdpvar(Times_Dayahead, 1, 'full'); V_g2gt_save1 = zeros(Times_Dayahead, 1); P_CH42gt_save1 = zeros(Times_Dayahead, 1);
M_H2gt_1 = sdpvar(Times_Dayahead, 1, 'full'); M_H2gt_save1 = zeros(Times_Dayahead, 1);
M_g2gt_1 = sdpvar(Times_Dayahead, 1, 'full'); M_g2gt_save1 = zeros(Times_Dayahead, 1);
P_gt2e_1 = sdpvar(Times_Dayahead, 1, 'full'); P_gt2e_save1 = zeros(Times_Dayahead, 1);
P_gt2h_1 = sdpvar(Times_Dayahead, 1, 'full'); P_gt2h_save1 = zeros(Times_Dayahead, 1);

P_g2gb_1 = sdpvar(Times_Dayahead, 1, 'full'); P_g2gb_save1 = zeros(Times_Dayahead, 1);
V_H2gb_1 = sdpvar(Times_Dayahead, 1, 'full'); V_H2gb_save1 = zeros(Times_Dayahead, 1); P_H2gb_save1 = zeros(Times_Dayahead, 1);
V_g2gb_1 = sdpvar(Times_Dayahead, 1, 'full'); V_g2gb_save1 = zeros(Times_Dayahead, 1); P_CH42gb_save1 = zeros(Times_Dayahead, 1);
M_H2gb_1 = sdpvar(Times_Dayahead, 1, 'full'); M_H2gb_save1 = zeros(Times_Dayahead, 1);
M_g2gb_1 = sdpvar(Times_Dayahead, 1, 'full'); M_g2gb_save1 = zeros(Times_Dayahead, 1);
P_gb2h_1 = sdpvar(Times_Dayahead, 1, 'full'); P_gb2h_save1 = zeros(Times_Dayahead, 1);

P_e2eb_1 = sdpvar(Times_Dayahead, 1, 'full'); P_e2eb_save1 = zeros(Times_Dayahead, 1);
P_eb2h_1 = sdpvar(Times_Dayahead, 1, 'full'); P_eb2h_save1 = zeros(Times_Dayahead, 1);

%----------------------------------------------------------------------储能决策变量定义
P_bat_cha_1 = sdpvar(Times_Dayahead, 1, 'full'); P_bat_cha_save1 = zeros(Times_Dayahead, 1);
P_bat_dis_1 = sdpvar(Times_Dayahead, 1, 'full'); P_bat_dis_save1 = zeros(Times_Dayahead, 1);
SOC_bat_1 = sdpvar(Times_Dayahead+1, 1, 'full'); SOC_bat_save1 = zeros(Times_Dayahead+1, 1);
Flag_bat_cha_1 = binvar(Times_Dayahead, 1, 'full'); Flag_bat_cha_save1 = zeros(Times_Dayahead, 1);
Flag_bat_dis_1 = binvar(Times_Dayahead, 1, 'full'); Flag_bat_dis_save1 = zeros(Times_Dayahead, 1);

P_hst_cha_1 = sdpvar(Times_Dayahead, 1, 'full'); P_hst_cha_save1 = zeros(Times_Dayahead, 1);
P_hst_dis_1 = sdpvar(Times_Dayahead, 1, 'full'); P_hst_dis_save1 = zeros(Times_Dayahead, 1);
SOC_hst_1 = sdpvar(Times_Dayahead+1, 1, 'full'); SOC_hst_save1 = zeros(Times_Dayahead+1, 1);
Flag_hst_cha_1 = binvar(Times_Dayahead, 1, 'full'); Flag_hst_cha_save1 = zeros(Times_Dayahead, 1);
Flag_hst_dis_1 = binvar(Times_Dayahead, 1, 'full'); Flag_hst_dis_save1 = zeros(Times_Dayahead, 1);

P_tst_cha_1 = sdpvar(Times_Dayahead, 1, 'full'); P_tst_cha_save1 = zeros(Times_Dayahead, 1);
P_tst_dis_1 = sdpvar(Times_Dayahead, 1, 'full'); P_tst_dis_save1 = zeros(Times_Dayahead, 1);
SOC_tst_1 = sdpvar(Times_Dayahead+1, 1, 'full'); SOC_tst_save1 = zeros(Times_Dayahead+1, 1);
Flag_tst_cha_1 = binvar(Times_Dayahead, 1, 'full'); Flag_tst_cha_save1 = zeros(Times_Dayahead, 1);
Flag_tst_dis_1 = binvar(Times_Dayahead, 1, 'full'); Flag_tst_dis_save1 = zeros(Times_Dayahead, 1);

P_gst_cha_1 = sdpvar(Times_Dayahead, 1, 'full'); P_gst_cha_save1 = zeros(Times_Dayahead, 1);
P_gst_dis_1 = sdpvar(Times_Dayahead, 1, 'full'); P_gst_dis_save1 = zeros(Times_Dayahead, 1);
SOC_gst_1 = sdpvar(Times_Dayahead+1, 1, 'full'); SOC_gst_save1 = zeros(Times_Dayahead+1, 1);
Flag_gst_cha_1 = binvar(Times_Dayahead, 1, 'full'); Flag_gst_cha_save1 = zeros(Times_Dayahead, 1);
Flag_gst_dis_1 = binvar(Times_Dayahead, 1, 'full'); Flag_gst_dis_save1 = zeros(Times_Dayahead, 1);

%----------------------------------------------------------------------购能决策变量定义
P_pur_e_1 = sdpvar(Times_Dayahead, 1, 'full'); P_pur_e_save1 = zeros(Times_Dayahead, 1);
P_pur_g_1 = sdpvar(Times_Dayahead, 1, 'full'); P_pur_g_save1 = zeros(Times_Dayahead, 1);

%----------------------------------------------------------------------DR决策变量定义
% 可削减负荷
L_edr_cl_1 = sdpvar(Times_Dayahead, 1, 'full'); L_edr_cl_save1 = zeros(Times_Dayahead, 1);
L_hdr_cl_1 = sdpvar(Times_Dayahead, 1, 'full'); L_hdr_cl_save1 = zeros(Times_Dayahead, 1);
% 转移负荷
L_edr_sl_in_1 = sdpvar(Times_Dayahead, 1, 'full'); L_edr_sl_in_save1 = zeros(Times_Dayahead, 1);
L_edr_sl_out_1 = sdpvar(Times_Dayahead, 1, 'full'); L_edr_sl_out_save1 = zeros(Times_Dayahead, 1);
L_hdr_sl_in_1 = sdpvar(Times_Dayahead, 1, 'full'); L_hdr_sl_in_save1 = zeros(Times_Dayahead, 1);
L_hdr_sl_out_1 = sdpvar(Times_Dayahead, 1, 'full'); L_hdr_sl_out_save1 = zeros(Times_Dayahead, 1);
Flag_edr_sl_in_1 = binvar(Times_Dayahead, 1, 'full'); Flag_edr_sl_in_save1 = zeros(Times_Dayahead, 1);
Flag_edr_sl_out_1 = binvar(Times_Dayahead, 1, 'full'); Flag_edr_sl_out_save1 = zeros(Times_Dayahead, 1);
Flag_hdr_sl_in_1 = binvar(Times_Dayahead, 1, 'full'); Flag_hdr_sl_in_save1 = zeros(Times_Dayahead, 1);
Flag_hdr_sl_out_1 = binvar(Times_Dayahead, 1, 'full'); Flag_hdr_sl_out_save1 = zeros(Times_Dayahead, 1);

%----------------------------------------------------------------------阶梯碳交易决策变量定义
C_lad_CO2_1 = sdpvar(1, 1, 'full');
P_e2ccs_1 = sdpvar(Times_Dayahead, 1, 'full'); P_e2ccs_save1 = zeros(Times_Dayahead, 1);


%% ======== 2.运行约束 ===================================
OBJECTIVE_1 = 0;        % 1：day ahead
CONSTRAINTS_1 = [];
% 风机光伏
CONSTRAINTS_1 = [CONSTRAINTS_1,...
    (0 <= P_wt2e_1 <= P_wt2e_max_1): 'P_wt2e_1',...
    (0 <= P_pv2e_1 <= P_pv2e_max_1): 'P_pv2e_1'
    ];
% EL电解槽（爬升约束）
CONSTRAINTS_1 = [CONSTRAINTS_1,...
    (P_el2H_1 == f_el * P_e2el_1): 'P_el2H_1',...
    (P_el_min <= P_e2el_1 <= P_el_max): 'P_e2el_1',...
    (-Delta_el*P_el_max <= P_e2el_1(2:end)-P_e2el_1(1:end-1) <= Delta_el*P_el_max): 'P_e2el_Delta'    
    ];
% MR甲烷反应器（爬升约束）
CONSTRAINTS_1 = [CONSTRAINTS_1,...
    (P_mr2g_1 == f_mr * P_H2mr_1): 'P_mr2g_1',...
    (P_mr_min <= P_H2mr_1 <= P_mr_max): 'P_H2mr_1',...
    (-Delta_mr*P_mr_max <= P_H2mr_1(2:end)-P_H2mr_1(1:end-1) <= Delta_mr*P_mr_max): 'P_H2mr_Delta' 
    ];
% HFC燃料电池（爬升约束）
CONSTRAINTS_1 = [CONSTRAINTS_1,...
    (P_hfc2e_1 == f_hfc_H2e * P_H2hfc_1): 'P_hfc2e_1',...
    (P_hfc2h_1 == f_hfc_H2h * P_H2hfc_1): 'P_hfc2h_1',...
    (P_hfc2e_1 + P_hfc2h_1 == (f_hfc_H2e+f_hfc_H2h) * P_H2hfc_1): 'P_hfc2e_1 + P_hfc2h_1',...
    (P_hfc_min <= P_H2hfc_1 <= P_hfc_max): 'P_H2hfc_1',...
    (-Delta_hfc*P_hfc_max <= P_H2hfc_1(2:end)-P_H2hfc_1(1:end-1) <= Delta_hfc*P_hfc_max): 'P_H2hfc_Delta' 
    ];
% GT燃气轮机（爬升约束）
CONSTRAINTS_1 = [CONSTRAINTS_1,...
    (P_g2gt_1 == (LHV_CH4 * M_g2gt_1 + LHV_H2 * M_H2gt_1) ): 'M_H2gt_1',...
    (V_g2gt_1 == M_g2gt_1 / density_CH4): 'V_g2gt_1',...
    (V_H2gt_1 == M_H2gt_1 / density_H2): 'V_H2gt_1',...
    (V_H2gt_1 <= k_H2gt_upper * (V_g2gt_1 + V_H2gt_1)): 'k_H2gt_upper',...
    (V_H2gt_1 >= k_H2gt_lower * (V_g2gt_1 + V_H2gt_1)): 'k_H2gt_lower',...
    (P_gt2e_1 == f_gt_g2e * P_g2gt_1): 'P_gt2e_1',...
    (P_gt2h_1 == f_gt_g2h * P_g2gt_1): 'P_gt2h_1',... 
    (P_gt2e_1 + P_gt2h_1 == (f_gt_g2e+f_gt_g2h) * P_g2gt_1): 'P_gt2e_1 + P_gt2h_1',...
    (P_gt_min <= P_g2gt_1 <= P_gt_max): 'P_g2gt_1',...
    (-Delta_gt*P_gt_max <= P_g2gt_1(2:end)-P_g2gt_1(1:end-1) <= Delta_gt*P_gt_max): 'P_g2gt_Delta',
    (M_g2gt_1 >= 0): 'M_g2gt_1',...
    (M_H2gt_1 >= 0): 'M_H2gt_1'
    ];
% GB燃气轮机（爬升约束）
CONSTRAINTS_1 = [CONSTRAINTS_1,...
    (P_g2gb_1 == (LHV_CH4 * M_g2gb_1 + LHV_H2 * M_H2gb_1) ): 'M_H2gb_1',...
    (V_g2gb_1 == M_g2gb_1 / density_CH4): 'V_g2gb_1',...
    (V_H2gb_1 == M_H2gb_1 / density_H2): 'V_H2gb_1',...
    (V_H2gb_1 <= k_H2gb_upper * (V_g2gb_1 + V_H2gb_1)): 'k_H2gb_upper',...
    (V_H2gb_1 >= k_H2gb_lower * (V_g2gb_1 + V_H2gb_1)): 'k_H2gb_lower',...
    (P_gb2h_1 == f_gb * P_g2gb_1): 'P_gb2h_1',... 
    (P_gb_min <= P_g2gb_1 <= P_gb_max): 'P_g2gb_1',...
    (-Delta_gb*P_gb_max <= P_g2gb_1(2:end)-P_g2gb_1(1:end-1) <= Delta_gb*P_gb_max): 'P_g2gb_Delta',...
    (M_g2gb_1 >= 0): 'M_g2gb_1',...
    (M_H2gb_1 >= 0): 'M_H2gb_1'
    ];
% EB电锅炉（爬升约束）
CONSTRAINTS_1 = [CONSTRAINTS_1,...
    (P_eb2h_1 == f_eb * P_e2eb_1): 'P_eb2h_1',...
    (P_eb_min <= P_e2eb_1 <= P_eb_max): 'P_e2eb_1',...
    (-Delta_eb*P_eb_max <= P_e2eb_1(2:end)-P_e2eb_1(1:end-1) <= Delta_eb*P_eb_max): 'P_e2eb_Delta'  
    ];
%% ======== 3.储能约束 ===================================
% 储电约束Battery，充放能倍率选择0.5C
CONSTRAINTS_1 = [CONSTRAINTS_1,...
    (0 <= P_bat_cha_1 <= Flag_bat_cha_1 * Q_bat_max * 0.5): 'P_bat_cha_1',...
    (0 <= P_bat_dis_1 <= Flag_bat_dis_1 * Q_bat_max * 0.5): 'P_bat_dis_1',...
    (Flag_bat_cha_1 + Flag_bat_dis_1 <= 1): 'Flag_bat',...                            
    (SOC_bat_1(1) == f_bat_init): 'SOC_bat_init',...
    (SOC_bat_1(end) == f_bat_init): 'SOC_bat_end',...
    (f_bat_min <= SOC_bat_1 <= f_bat_max): 'SOC_bat_range',...        
    (SOC_bat_1(2:end) == SOC_bat_1(1:end-1) + f_bat_cha/Q_bat_max*P_bat_cha_1 - P_bat_dis_1/(f_bat_dis*Q_bat_max)): 'SOC_bat_Delta'  
    ];

% 储氢约束HST
CONSTRAINTS_1 = [CONSTRAINTS_1,...
    (0 <= P_hst_cha_1 <= Flag_hst_cha_1 * Q_hst_max * 0.5): 'P_hst_cha_1',...
    (0 <= P_hst_dis_1 <= Flag_hst_dis_1 * Q_hst_max * 0.5): 'P_hst_dis_1',...
    (Flag_hst_cha_1 + Flag_hst_dis_1 <= 1): 'Flag_hst',...                            
    (SOC_hst_1(1) == f_hst_init): 'SOC_hst_init',...
    (SOC_hst_1(end) == f_hst_init): 'SOC_hst_end',...
    (f_hst_min <= SOC_hst_1 <= f_hst_max): 'SOC_hst_range',...        
    (SOC_hst_1(2:end) == SOC_hst_1(1:end-1) + f_hst_cha/Q_hst_max*P_hst_cha_1 - P_hst_dis_1/(f_hst_dis*Q_hst_max)): 'SOC_hst_Delta'  
    ];

% 储热约束TST
CONSTRAINTS_1 = [CONSTRAINTS_1,...
    (0 <= P_tst_cha_1 <= Flag_tst_cha_1 * Q_tst_max * 0.5): 'P_tst_cha_1',...
    (0 <= P_tst_dis_1 <= Flag_tst_dis_1 * Q_tst_max * 0.5): 'P_tst_dis_1',...
    (Flag_tst_cha_1 + Flag_tst_dis_1 <= 1): 'Flag_tst',...                            
    (SOC_tst_1(1) == f_tst_init): 'SOC_tst_init',...
    (SOC_tst_1(end) == f_tst_init): 'SOC_tst_end',...
    (f_tst_min <= SOC_tst_1 <= f_tst_max): 'SOC_tst_range',...        
    (SOC_tst_1(2:end) == SOC_tst_1(1:end-1) + f_tst_cha/Q_tst_max*P_tst_cha_1 - P_tst_dis_1/(f_tst_dis*Q_tst_max)): 'SOC_tst_Delta'  
    ];

% 储气约束GST
CONSTRAINTS_1 = [CONSTRAINTS_1,...
    (0 <= P_gst_cha_1 <= Flag_gst_cha_1 * Q_gst_max * 0.5): 'P_gst_cha_1',...
    (0 <= P_gst_dis_1 <= Flag_gst_dis_1 * Q_gst_max * 0.5): 'P_gst_dis_1',...
    (Flag_gst_cha_1 + Flag_gst_dis_1 <= 1): 'Flag_gst',...                            
    (SOC_gst_1(1) == f_gst_init): 'SOC_gst_init',...
    (SOC_gst_1(end) == f_gst_init): 'SOC_gst_end',...
    (f_gst_min <= SOC_gst_1 <= f_gst_max): 'SOC_gst_range',...        
    (SOC_gst_1(2:end) == SOC_gst_1(1:end-1) + f_gst_cha/Q_gst_max*P_gst_cha_1 - P_gst_dis_1/(f_gst_dis*Q_gst_max)): 'SOC_gst_Delta'  
    ];
%% ======== 4.1购能约束 ===================================
% 购电、购气约束
CONSTRAINTS_1 = [CONSTRAINTS_1,...
    (0 <= P_pur_e_1 <= P_pur_e_max): 'P_pur_e_1',...
    (0 <= P_pur_g_1 <= P_pur_g_max): 'P_pur_g_1'
    ];
%% ======== 4.2DR约束 ===================================
% 可削减负荷
CONSTRAINTS_1 = [CONSTRAINTS_1,...
    (0 <= L_edr_cl_1 <= L_edr_cl_max_1): 'L_edr_cl_1',... 
    (0 <= L_hdr_cl_1 <= L_hdr_cl_max_1): 'L_hdr_cl_1'
    ];
% 可转移负荷
CONSTRAINTS_1 = [CONSTRAINTS_1,...
    (0 <= L_edr_sl_in_1 <= Flag_edr_sl_in_1.*L_edr_sl_in_max_1): 'L_edr_sl_in_1',...    
    (0 <= L_edr_sl_out_1 <= Flag_edr_sl_out_1.*prop_edr_sl_out_1.*P_eLoad_1): 'L_edr_sl_out_1',...   
    (Flag_edr_sl_in_1 + Flag_edr_sl_out_1 <= 1): 'Flag_edr_sl',...    
    (sum(L_edr_sl_in_1) == sum(L_edr_sl_out_1)): 'sum(L_edr_sl)'
    ];
CONSTRAINTS_1 = [CONSTRAINTS_1,...
    (0 <= L_hdr_sl_in_1 <= Flag_hdr_sl_in_1.*L_hdr_sl_in_max_1): 'L_hdr_sl_in_1',...
    (0 <= L_hdr_sl_out_1 <= Flag_hdr_sl_out_1.*prop_hdr_sl_out_1.*P_hLoad_1): 'L_hdr_sl_out_1',...
    (Flag_hdr_sl_in_1 + Flag_hdr_sl_out_1 <= 1): 'Flag_hdr_sl',...
    (sum(L_hdr_sl_in_1) == sum(L_hdr_sl_out_1)): 'sum(L_hdr_sl)'
    ];
%% ======== 4.3阶梯碳交易 ===================================
% 碳配额部分
E_pe_e2pur_1 = sum( P_pur_e_1 * w_e2pur );                 % 电网碳配额
E_pe_gt_1 = sum( (phi_eh*P_gt2e_1 + P_gt2h_1)*w_h );       % GT配额
E_pe_gb_1 = sum( P_gb2h_1 * w_h );                         % GB配额
E_pe_total_1 = E_pe_e2pur_1 + E_pe_gt_1 + E_pe_gb_1;
% 实际碳排放，这里只计算天然气部分产生的二氧化碳
E_actu_e2pur_1 = sum( k_SC_a + k_SC_b*P_pur_e_1 + k_SC_c*(P_pur_e_1.^2) );      % 电网实际碳排放量
P_gt_total_1 = LHV_CH4*M_g2gt_1*f_gt_g2e*phi_eh + LHV_CH4*M_g2gt_1*f_gt_g2h;
E_actu_gt_1 = sum( k_gas_a + k_gas_b*P_gt_total_1 + k_gas_c*(P_gt_total_1.^2) );    % GT实际碳排放量
P_gb_total_1 = LHV_CH4*M_g2gb_1*f_gb;
E_actu_gb_1 = sum( k_gas_a + k_gas_b*P_gb_total_1 + k_gas_c*(P_gb_total_1.^2) );    % GB实际碳排放量
E_actu_total_1 = E_actu_e2pur_1 + E_actu_gt_1 + E_actu_gb_1;
% CCS吸收碳排放量
E_ccs_total_1 = sum( P_mr2g_1 / LHV_CH4 * w_mr);
CONSTRAINTS_1 = [CONSTRAINTS_1,...
    (P_e2ccs_1 == P_mr2g_1 / LHV_CH4 * w_mr * f_ccus): 'P_e2ccs_1'
    ];

E_tra_1 = E_actu_total_1 - E_pe_total_1 - E_ccs_total_1;     % 参与碳交易的二氧化碳量     
% 阶梯碳交易区间  
C_lad_seg1 = lambda_lad * E_tra_1;
C_lad_seg2 = lambda_lad*d_lad  +  lambda_lad*(1 + alpha_lad)*(E_tra_1-d_lad);
C_lad_seg3 = lambda_lad*(2+alpha_lad)*d_lad  +  lambda_lad*(1+2*alpha_lad)*(E_tra_1-2*d_lad);
C_lad_seg4 = lambda_lad*(3+3*alpha_lad)*d_lad  +  lambda_lad*(1+3*alpha_lad)*(E_tra_1-3*d_lad);
C_lad_seg5 = lambda_lad*(4+6*alpha_lad)*d_lad  +  lambda_lad*(1+4*alpha_lad)*(E_tra_1-4*d_lad);
C_lad_seg6 = lambda_lad*(5+10*alpha_lad)*d_lad  +  lambda_lad*(1+5*alpha_lad)*(E_tra_1-5*d_lad);
% 阶梯碳交易约束
CONSTRAINTS_1 = [CONSTRAINTS_1,...
    C_lad_CO2_1 >= C_lad_seg1,...
    C_lad_CO2_1 >= C_lad_seg2,...
    C_lad_CO2_1 >= C_lad_seg3,...
    C_lad_CO2_1 >= C_lad_seg4,...
    C_lad_CO2_1 >= C_lad_seg5,...
    C_lad_CO2_1 >= C_lad_seg6
    ];

%% ======== 5.功率平衡约束 ===================================
CONSTRAINTS_1 = [CONSTRAINTS_1,...
    ... 电平衡：风光发电 + 电网购电 + GT发电 + HFC发电 + 电池放电 = 电负荷 + EL电解槽电解 + EB电锅炉用电 + CCS碳捕集用电 +电池充电 -日前DR_CL+日前DR_SL_in-日前DR_SL_out
    (P_wt2e_1+P_pv2e_1+P_pur_e_1+P_gt2e_1+P_hfc2e_1+P_bat_dis_1 ==  P_eLoad_1+P_e2el_1+P_e2eb_1+P_e2ccs_1+P_bat_cha_1-L_edr_cl_1+L_edr_sl_in_1-L_edr_sl_out_1): 'P_e_balance',...
    ... 热平衡：GT产热 + GB产热 + HFC产热 + EB产热 + 储热放热 = 热负荷 + 储热吸热 - 日前DR
    (P_gt2h_1 + P_gb2h_1 + P_hfc2h_1 + P_eb2h_1 + P_tst_dis_1 == P_hLoad_1 + P_tst_cha_1 - L_hdr_cl_1+L_hdr_sl_in_1-L_hdr_sl_out_1): 'P_h_balance',...
    ... 氢平衡：EL产氢 + 储氢放氢 = HFC用氢 + MR用氢 + GT用氢 + GB用氢 + 储氢充氢
    (P_el2H_1 + P_hst_dis_1 == P_H2hfc_1 + P_H2mr_1 + LHV_H2*M_H2gt_1 + LHV_H2*M_H2gb_1 + P_hst_cha_1): 'P_H_balance',...  
    ... 气平衡：气网购气 + MR产气 + 储气放气 = GT用天然气气 + GB用天然气气 + 储气充气
    (P_pur_g_1 + P_mr2g_1 + P_gst_dis_1 == LHV_CH4*M_g2gt_1 + LHV_CH4*M_g2gb_1 + P_gst_cha_1): 'P_g_balance'  
    ];


%% ======== 6.目标函数 ===================================
% ==================== 运维成本 ====================
C_opm_1 = sum(P_wt2e_1)*c_opm_wt + sum(P_pv2e_1)*c_opm_pv + sum(P_e2el_1)*c_opm_el + sum(P_H2hfc_1)*c_opm_hfc + ...
    sum(P_g2gt_1)*c_opm_gt + sum(P_g2gb_1)*c_opm_gb + sum(P_e2eb_1)*c_opm_eb;
% ==================== 购能成本 ====================
% 注意：天然气价格为 元/m3，所以需要转换单位
C_pur_1 = sum(P_pur_e_1.*c_pur_e') + sum( (P_pur_g_1 / (LHV_CH4 * density_CH4)) .* c_pur_g' );
% ==================== 储能成本 ====================
C_st_1 = sum(P_bat_cha_1+P_bat_dis_1)*c_st_bat + sum(P_hst_cha_1+P_hst_dis_1)*c_st_hst + sum(P_tst_cha_1+P_tst_dis_1)*c_st_tst + ...
    sum(P_gst_cha_1+P_gst_dis_1)*c_st_gst;
% ==================== 弃能成本 ====================
C_abd_1 = sum(P_wt2e_max_1 - P_wt2e_1)*c_abd_wt + sum(P_pv2e_max_1 - P_pv2e_1)*c_abd_pv;
% ==================== DR成本 ====================
C_dr_cl_1 = sum(L_edr_cl_1)*c_edr_cl_1 + sum(L_hdr_cl_1)*c_hdr_cl_1;
C_dr_sl_1 = sum(L_edr_sl_out_1)*c_edr_sl_1 + sum(L_hdr_sl_out_1)*c_hdr_sl_1;
%% ======== 7.求解 ===================================
OBJECTIVE_1 = OBJECTIVE_1 + C_opm_1 + C_pur_1 + C_st_1 + C_abd_1 + C_dr_cl_1 + C_dr_sl_1 + C_lad_CO2_1; 
OPTIONS = sdpsettings('solver', 'cplex', 'verbose', 0, 'showprogress', 0);
% 在数学优化中，容差参数用于处理数值计算中的舍入误差和数值不稳定性。由于计算机使用浮点数运算，严格的等式约束在实际中很难完全满足。
OPTIONS.cplex.eprhs = 1e-6;     % 可行性容差
OPTIONS.cplex.epopt = 1e-6;     % 最优性容差
sol = optimize(CONSTRAINTS_1, OBJECTIVE_1, OPTIONS);

if sol.problem == 0
     disp("求解成功");
else 
    disp("出错了，原因是：");
    disp(sol.info);
    
    % 正确的调试方法
    if sol.problem == 1
        disp('问题不可行，检查约束条件');
        % 检查哪些约束不满足
        disp('检查约束可行性:');
        check(CONSTRAINTS_1);
    else
        disp(['求解器返回代码: ', num2str(sol.problem)]);
    end
end

%% ======== 8.查看24h-1h求解值 ===================================
if IF_VALUE_Dayahead
    %-------------------------------------------设备决策变量保存
    P_wt2e_save1 = zero_tiny(value(P_wt2e_1)); P_pv2e_save1 = zero_tiny(value(P_pv2e_1));
    P_e2el_save1 = zero_tiny(value(P_e2el_1)); P_el2H_save1 = zero_tiny(value(P_el2H_1));
    P_H2mr_save1 = zero_tiny(value(P_H2mr_1)); P_mr2g_save1 = zero_tiny(value(P_mr2g_1));
    P_H2hfc_save1 = zero_tiny(value(P_H2hfc_1)); P_hfc2e_save1 = zero_tiny(value(P_hfc2e_1)); P_hfc2h_save1 = zero_tiny(value(P_hfc2h_1));
    
    P_g2gt_save1 = zero_tiny(value(P_g2gt_1));
    P_H2gt_save1 = zero_tiny(value(LHV_H2*M_H2gt_1)); P_CH42gt_save1 = zero_tiny(value(LHV_CH4*M_g2gt_1));
    V_H2gt_save1 = zero_tiny(value(V_H2gt_1)); V_g2gt_save1 = zero_tiny(value(V_g2gt_1));
    M_H2gt_save1 = zero_tiny(value(M_H2gt_1)); M_g2gt_save1 = zero_tiny(value(M_g2gt_1));
    P_gt2e_save1 = zero_tiny(value(P_gt2e_1)); P_gt2h_save1 = zero_tiny(value(P_gt2h_1));
    
    P_g2gb_save1 = zero_tiny(value(P_g2gb_1));
    P_H2gb_save1 = zero_tiny(value(LHV_H2*M_H2gb_1)); P_CH42gb_save1 = zero_tiny(value(LHV_CH4*M_g2gb_1));
    V_H2gb_save1 = zero_tiny(value(V_H2gb_1)); V_g2gb_save1 = zero_tiny(value(V_g2gb_1));
    M_H2gb_save1 = zero_tiny(value(M_H2gb_1)); M_g2gb_save1 = zero_tiny(value(M_g2gb_1));
    P_gb2h_save1 = zero_tiny(value(P_gb2h_1));
    
    P_e2eb_save1 = zero_tiny(value(P_e2eb_1)); P_eb2h_save1 = zero_tiny(value(P_eb2h_1));        
    %-------------------------------------------储能决策变量保存
    P_bat_cha_save1 = zero_tiny(value(P_bat_cha_1)); P_bat_dis_save1 = zero_tiny(value(P_bat_dis_1));
    SOC_bat_save1 = zero_tiny(value(SOC_bat_1));
    Flag_bat_cha_save1 = zero_tiny(value(Flag_bat_cha_1)); Flag_bat_dis_save1 = zero_tiny(value(Flag_bat_dis_1));
    
    P_hst_cha_save1 = zero_tiny(value(P_hst_cha_1)); P_hst_dis_save1 = zero_tiny(value(P_hst_dis_1));
    SOC_hst_save1 = zero_tiny(value(SOC_hst_1));
    Flag_hst_cha_save1 = zero_tiny(value(Flag_hst_cha_1)); Flag_hst_dis_save1 = zero_tiny(value(Flag_hst_dis_1));
    
    P_tst_cha_save1 = zero_tiny(value(P_tst_cha_1)); P_tst_dis_save1 = zero_tiny(value(P_tst_dis_1));
    SOC_tst_save1 = zero_tiny(value(SOC_tst_1));
    Flag_tst_cha_save1 = zero_tiny(value(Flag_tst_cha_1)); Flag_tst_dis_save1 = zero_tiny(value(Flag_tst_dis_1));
    
    P_gst_cha_save1 = zero_tiny(value(P_gst_cha_1)); P_gst_dis_save1 = zero_tiny(value(P_gst_dis_1));
    SOC_gst_save1 = zero_tiny(value(SOC_gst_1));
    Flag_gst_cha_save1 = zero_tiny(value(Flag_gst_cha_1)); Flag_gst_dis_save1 = zero_tiny(value(Flag_gst_dis_1));       
    %----------------------------------------------------------------------购能决策变量保存
    P_pur_e_save1 = zero_tiny(value(P_pur_e_1)); P_pur_g_save1 = zero_tiny(value(P_pur_g_1));
    %----------------------------------------------------------------------DR决策变量保存
    L_edr_cl_save1 = zero_tiny(value(L_edr_cl_1)); L_hdr_cl_save1 = zero_tiny(value(L_hdr_cl_1));
    L_edr_sl_in_save1 = zero_tiny(value(L_edr_sl_in_1)); L_hdr_sl_in_save1 = zero_tiny(value(L_hdr_sl_in_1));
    L_edr_sl_out_save1 = zero_tiny(value(L_edr_sl_out_1)); L_hdr_sl_out_save1 = zero_tiny(value(L_hdr_sl_out_1));
    %----------------------------------------------------------------------阶梯碳交易决策变量保存
    P_e2ccs_save1 = zero_tiny(value(P_e2ccs_1));
    % 碳配额
    E_pe_total_save1 = zero_tiny(value(E_pe_total_1));
    E_pe_e2pur_save1 = zero_tiny(value(E_pe_e2pur_1));
    E_pe_gt_save1 = zero_tiny(value(E_pe_gt_1));
    E_pe_gb_save1 = zero_tiny(value(E_pe_gb_1));
    % 实际碳排放
    E_actu_total_save1 = zero_tiny(value(E_actu_total_1));
    E_actu_e2pur_save1 = zero_tiny(value(E_actu_e2pur_1));
    E_actu_gt_save1 = zero_tiny(value(E_actu_gt_1));
    E_actu_gb_save1 = zero_tiny(value(E_actu_gb_1));
    % CCS吸收
    E_ccs_total_save1 = zero_tiny(value(E_ccs_total_1));
    % 参与碳交易的碳排
    E_tra_save1 = zero_tiny(value(E_tra_1));

    %----------------------------------------------------------------------功率平衡变量保存
    P_eBalanceGen_1 = [P_pur_e_save1, P_wt2e_save1, P_pv2e_save1, P_gt2e_save1, P_hfc2e_save1, P_bat_dis_save1]; 
    P_eBalanceCon_1 = [P_eLoad_1-L_edr_cl_save1+L_edr_sl_in_save1-L_edr_sl_out_save1, P_e2el_save1, P_e2eb_save1, P_e2ccs_save1, P_bat_cha_save1];

    P_hBalanceGen_1 = [P_gt2h_save1, P_gb2h_save1, P_hfc2h_save1, P_eb2h_save1, P_tst_dis_save1];
    P_hBalanceCon_1 = [P_hLoad_1-L_hdr_cl_save1+L_hdr_sl_in_save1-L_hdr_sl_out_save1, P_tst_cha_save1];
    
    P_HBalanceGen_1 = [P_el2H_save1, P_hst_dis_save1];
    P_HBalanceCon_1 = [P_H2hfc_save1, P_H2mr_save1, P_H2gt_save1, P_H2gb_save1, P_hst_cha_save1];

    P_gBalanceGen_1 = [P_pur_g_save1, P_mr2g_save1, P_gst_dis_save1];
    P_gBalanceCon_1 = [P_CH42gt_save1, P_CH42gb_save1, P_gst_cha_save1];
    
    P_BalanceGen_1 = {P_eBalanceGen_1, P_hBalanceGen_1, P_HBalanceGen_1, P_gBalanceGen_1};
    P_BalanceCon_1 = {P_eBalanceCon_1, P_hBalanceCon_1, P_HBalanceCon_1, P_gBalanceCon_1};  
end
%% ======== 9.绘图24h-1h调度结果 ===================================
if IF_ResultPlot_Dayahead
    utils.resultplot_dayahead(P_BalanceGen_1, P_BalanceCon_1);
end

%% ****** 三、日内-实时阶段 *************************************** 



