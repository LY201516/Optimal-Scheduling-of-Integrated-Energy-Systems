% 上接main.m文件
yalmip("clear");         % 清除Yalmip自身维护的内存，让求解更快。删除这一行后不影响求解，只是求解速度越来越慢。
run("main.m");
%% ****** 二、日前阶段 ***************************************
% 日前调度参考数值，24 --> 96，用于计算调整成本
P_g2gt_save1_96 = repmat(P_g2gt_save1', 4, 1);
P_g2gt_save1_96 = reshape(P_g2gt_save1_96, [], 1);  % 1h的数据变为4个相同的15min数据
P_g2gb_save1_96 = repmat(P_g2gb_save1', 4, 1);
P_g2gb_save1_96 = reshape(P_g2gb_save1_96, [], 1);  % 1h的数据变为4个相同的15min数据

P_hst_cha_save1_96 = repmat(P_hst_cha_save1', 4, 1);
P_hst_cha_save1_96 = reshape(P_hst_cha_save1_96, [], 1);
P_hst_dis_save1_96 = repmat(P_hst_dis_save1', 4, 1);
P_hst_dis_save1_96 = reshape(P_hst_dis_save1_96, [], 1);

P_tst_cha_save1_96 = repmat(P_tst_cha_save1', 4, 1);
P_tst_cha_save1_96 = reshape(P_tst_cha_save1_96, [], 1);
P_tst_dis_save1_96 = repmat(P_tst_dis_save1', 4, 1);
P_tst_dis_save1_96 = reshape(P_tst_dis_save1_96, [], 1);

P_gst_cha_save1_96 = repmat(P_gst_cha_save1', 4, 1);
P_gst_cha_save1_96 = reshape(P_gst_cha_save1_96, [], 1);
P_gst_dis_save1_96 = repmat(P_gst_dis_save1', 4, 1);
P_gst_dis_save1_96 = reshape(P_gst_dis_save1_96, [], 1);

% 日前DR_CL响应量，24 --> 96
L_edr_cl_save1_96 = repmat(L_edr_cl_save1', 4, 1);  L_edr_cl_save1_96 = reshape(L_edr_cl_save1_96, [], 1);
L_hdr_cl_save1_96 = repmat(L_hdr_cl_save1', 4, 1);  L_hdr_cl_save1_96 = reshape(L_hdr_cl_save1_96, [], 1);
% 日前DR_SL响应量，24 --> 96
L_edr_sl_in_save1_96 = repmat(L_edr_sl_in_save1', 4, 1);  L_edr_sl_in_save1_96 = reshape(L_edr_sl_in_save1_96, [], 1);
L_edr_sl_out_save1_96 = repmat(L_edr_sl_out_save1', 4, 1);  L_edr_sl_out_save1_96 = reshape(L_edr_sl_out_save1_96, [], 1);
L_hdr_sl_in_save1_96 = repmat(L_hdr_sl_in_save1', 4, 1);  L_hdr_sl_in_save1_96 = reshape(L_hdr_sl_in_save1_96, [], 1);
L_hdr_sl_out_save1_96 = repmat(L_hdr_sl_out_save1', 4, 1);  L_hdr_sl_out_save1_96 = reshape(L_hdr_sl_out_save1_96, [], 1);

% 电价、气价，15min一个点，24h一共96个点
c_pur_e_96 = repmat(c_pur_e, 4, 1);
c_pur_e_96 = reshape(c_pur_e_96, [], 1);  % []为自动计算该维度，96x1
c_pur_g_96 = repmat(c_pur_g, 4, 1);
c_pur_g_96 = reshape(c_pur_g_96, [], 1);  % []为自动计算该维度

% 日前DR_CL响应量，24 --> 288（实时循环层中，需要将日前的响应量当做常数放进去）
L_edr_cl_save1_288 = repmat(L_edr_cl_save1', 12, 1); L_edr_cl_save1_288 = reshape(L_edr_cl_save1_288, [], 1);
L_hdr_cl_save1_288 = repmat(L_hdr_cl_save1', 12, 1); L_hdr_cl_save1_288 = reshape(L_hdr_cl_save1_288, [], 1);
% 日前DR_SL响应量，24 --> 288（实时循环层中，需要将日前的响应量当做常数放进去）
L_edr_sl_in_save1_288 = repmat(L_edr_sl_in_save1', 12, 1);  L_edr_sl_in_save1_288 = reshape(L_edr_sl_in_save1_288, [], 1);
L_edr_sl_out_save1_288 = repmat(L_edr_sl_out_save1', 12, 1);  L_edr_sl_out_save1_288 = reshape(L_edr_sl_out_save1_288, [], 1);
L_hdr_sl_in_save1_288 = repmat(L_hdr_sl_in_save1', 12, 1);  L_hdr_sl_in_save1_288 = reshape(L_hdr_sl_in_save1_288, [], 1);
L_hdr_sl_out_save1_288 = repmat(L_hdr_sl_out_save1', 12, 1);  L_hdr_sl_out_save1_288 = reshape(L_hdr_sl_out_save1_288, [], 1);


% ------------------------- 边际碳价 -----------------------------------
% 根据日前预测的碳排放量，确定系统的碳排在当天处于哪一个价格区间，并以此价格作为日内和实时阶段的碳价
c_lad_di_da = NaN;
switch true
    case E_tra_save1 <= 0   
        c_lad_di_da = -lambda_lad;       % 负数表示挣钱
    case E_tra_save1 <= d_lad
        c_lad_di_da = lambda_lad;
    case E_tra_save1 <= 2*d_lad
        c_lad_di_da = (1 + alpha_lad)*lambda_lad;
    case E_tra_save1 <= 3*d_lad
        c_lad_di_da = (1 + 2*alpha_lad)*lambda_lad;
    case E_tra_save1 <= 4*d_lad
        c_lad_di_da = (1 + 3*alpha_lad)*lambda_lad;
    case E_tra_save1 <= 5*d_lad
        c_lad_di_da = (1 + 4*alpha_lad)*lambda_lad;
    case E_tra_save1 > 5*d_lad
        c_lad_di_da = (1 + 5*alpha_lad)*lambda_lad;
    otherwise
        disp("E_tra_save1 值为空");
end
%% ****** 三、日内阶段 *************************************** 
%% ======== 1.1日内-决策变量定义 ===================================
% -----------------------------------------------------------------风机光伏决策变量定义
P_wt2e_2 = sdpvar(Times_Dayin, 1, 'full'); P_wt2e_save2 = zeros(Times_Dayin*6, 1);               
P_pv2e_2 = sdpvar(Times_Dayin, 1, 'full'); P_pv2e_save2 = zeros(Times_Dayin*6, 1);

% -----------------------------------------------------------------设备决策变量定义
P_e2el_2 = sdpvar(Times_Dayin, 1, 'full'); P_e2el_save2 = zeros(Times_Dayin*6, 1);
P_el2H_2 = sdpvar(Times_Dayin, 1, 'full'); P_el2H_save2 = zeros(Times_Dayin*6, 1);

P_H2mr_2 = sdpvar(Times_Dayin, 1, 'full'); P_H2mr_save2 = zeros(Times_Dayin*6, 1);
P_mr2g_2 = sdpvar(Times_Dayin, 1, 'full'); P_mr2g_save2 = zeros(Times_Dayin*6, 1);

P_H2hfc_2 = sdpvar(Times_Dayin, 1, 'full'); P_H2hfc_save2 = zeros(Times_Dayin*6, 1);
P_hfc2e_2 = sdpvar(Times_Dayin, 1, 'full'); P_hfc2e_save2 = zeros(Times_Dayin*6, 1);
P_hfc2h_2 = sdpvar(Times_Dayin, 1, 'full'); P_hfc2h_save2 = zeros(Times_Dayin*6, 1);

P_g2gt_2 = sdpvar(Times_Dayin, 1, 'full'); P_g2gt_save2 = zeros(Times_Dayin*6, 1);
V_H2gt_2 = sdpvar(Times_Dayin, 1, 'full'); V_H2gt_save2 = zeros(Times_Dayin*6, 1); P_H2gt_save2 = zeros(Times_Dayin*6, 1);
V_g2gt_2 = sdpvar(Times_Dayin, 1, 'full'); V_g2gt_save2 = zeros(Times_Dayin*6, 1); P_CH42gt_save2 = zeros(Times_Dayin*6, 1);
M_H2gt_2 = sdpvar(Times_Dayin, 1, 'full'); M_H2gt_save2 = zeros(Times_Dayin*6, 1);
M_g2gt_2 = sdpvar(Times_Dayin, 1, 'full'); M_g2gt_save2 = zeros(Times_Dayin*6, 1);
P_gt2e_2 = sdpvar(Times_Dayin, 1, 'full'); P_gt2e_save2 = zeros(Times_Dayin*6, 1);
P_gt2h_2 = sdpvar(Times_Dayin, 1, 'full'); P_gt2h_save2 = zeros(Times_Dayin*6, 1);

P_g2gb_2 = sdpvar(Times_Dayin, 1, 'full'); P_g2gb_save2 = zeros(Times_Dayin*6, 1);
V_H2gb_2 = sdpvar(Times_Dayin, 1, 'full'); V_H2gb_save2 = zeros(Times_Dayin*6, 1); P_H2gb_save2 = zeros(Times_Dayin*6, 1);
V_g2gb_2 = sdpvar(Times_Dayin, 1, 'full'); V_g2gb_save2 = zeros(Times_Dayin*6, 1); P_CH42gb_save2 = zeros(Times_Dayin*6, 1);
M_H2gb_2 = sdpvar(Times_Dayin, 1, 'full'); M_H2gb_save2 = zeros(Times_Dayin*6, 1);
M_g2gb_2 = sdpvar(Times_Dayin, 1, 'full'); M_g2gb_save2 = zeros(Times_Dayin*6, 1);
P_gb2h_2 = sdpvar(Times_Dayin, 1, 'full'); P_gb2h_save2 = zeros(Times_Dayin*6, 1);

P_e2eb_2 = sdpvar(Times_Dayin, 1, 'full'); P_e2eb_save2 = zeros(Times_Dayin*6, 1);
P_eb2h_2 = sdpvar(Times_Dayin, 1, 'full'); P_eb2h_save2 = zeros(Times_Dayin*6, 1);

%----------------------------------------------------------------------储能决策变量定义
P_bat_cha_2 = sdpvar(Times_Dayin, 1, 'full'); P_bat_cha_save2 = zeros(Times_Dayin*6, 1);
P_bat_dis_2 = sdpvar(Times_Dayin, 1, 'full'); P_bat_dis_save2 = zeros(Times_Dayin*6, 1);
SOC_bat_2 = sdpvar(Times_Dayin+1, 1, 'full'); SOC_bat_save2 = zeros(Times_Dayin*6+1, 1);
Flag_bat_cha_2 = binvar(Times_Dayin, 1, 'full'); Flag_bat_cha_save2 = zeros(Times_Dayin*6, 1);
Flag_bat_dis_2 = binvar(Times_Dayin, 1, 'full'); Flag_bat_dis_save2 = zeros(Times_Dayin*6, 1);

P_hst_cha_2 = sdpvar(Times_Dayin, 1, 'full'); P_hst_cha_save2 = zeros(Times_Dayin*6, 1);
P_hst_dis_2 = sdpvar(Times_Dayin, 1, 'full'); P_hst_dis_save2 = zeros(Times_Dayin*6, 1);
SOC_hst_2 = sdpvar(Times_Dayin+1, 1, 'full'); SOC_hst_save2 = zeros(Times_Dayin*6+1, 1);
Flag_hst_cha_2 = binvar(Times_Dayin, 1, 'full'); Flag_hst_cha_save2 = zeros(Times_Dayin*6, 1);
Flag_hst_dis_2 = binvar(Times_Dayin, 1, 'full'); Flag_hst_dis_save2 = zeros(Times_Dayin*6, 1);

P_tst_cha_2 = sdpvar(Times_Dayin, 1, 'full'); P_tst_cha_save2 = zeros(Times_Dayin*6, 1);
P_tst_dis_2 = sdpvar(Times_Dayin, 1, 'full'); P_tst_dis_save2 = zeros(Times_Dayin*6, 1);
SOC_tst_2 = sdpvar(Times_Dayin+1, 1, 'full'); SOC_tst_save2 = zeros(Times_Dayin*6+1, 1);
Flag_tst_cha_2 = binvar(Times_Dayin, 1, 'full'); Flag_tst_cha_save2 = zeros(Times_Dayin*6, 1);
Flag_tst_dis_2 = binvar(Times_Dayin, 1, 'full'); Flag_tst_dis_save2 = zeros(Times_Dayin*6, 1);

P_gst_cha_2 = sdpvar(Times_Dayin, 1, 'full'); P_gst_cha_save2 = zeros(Times_Dayin*6, 1);
P_gst_dis_2 = sdpvar(Times_Dayin, 1, 'full'); P_gst_dis_save2 = zeros(Times_Dayin*6, 1);
SOC_gst_2 = sdpvar(Times_Dayin+1, 1, 'full'); SOC_gst_save2 = zeros(Times_Dayin*6+1, 1);
Flag_gst_cha_2 = binvar(Times_Dayin, 1, 'full'); Flag_gst_cha_save2 = zeros(Times_Dayin*6, 1);
Flag_gst_dis_2 = binvar(Times_Dayin, 1, 'full'); Flag_gst_dis_save2 = zeros(Times_Dayin*6, 1);

%----------------------------------------------------------------------购能决策变量定义
P_pur_e_2 = sdpvar(Times_Dayin, 1, 'full'); P_pur_e_save2 = zeros(Times_Dayin*6, 1);
P_pur_g_2 = sdpvar(Times_Dayin, 1, 'full'); P_pur_g_save2 = zeros(Times_Dayin*6, 1);

%----------------------------------------------------------------------DR决策变量定义
% 可削减负荷
L_edr_cl_2 = sdpvar(Times_Dayin, 1, 'full'); L_edr_cl_save2 = zeros(Times_Dayin*6, 1);
L_hdr_cl_2 = sdpvar(Times_Dayin, 1, 'full'); L_hdr_cl_save2 = zeros(Times_Dayin*6, 1);
%----------------------------------------------------------------------阶梯碳交易决策变量定义
P_e2ccs_2 = sdpvar(Times_Dayin, 1, 'full'); P_e2ccs_save2 = zeros(Times_Dayin*6, 1);
% E_actu_total_save2 = zeros(Times_Dayin*6, 1); 
% E_actu_e2pur_save2 = zeros(Times_Dayin*6, 1); E_actu_gt_2 = zeros(Times_Dayin*6, 1); E_actu_gb_2 = zeros(Times_Dayin*6, 1);
% E_ccs_total_save2 = zeros(Times_Dayin*6, 1);
% E_pe_total_save2 = zeros(Times_Dayin*6, 1);
% E_tra_save2 = zeros(Times_Dayin*6, 1);




%% ======== 1.2实时-决策变量定义 ===================================
% -----------------------------------------------------------------风机光伏决策变量定义
P_wt2e_3 = sdpvar(Times_Realtime, 1, 'full'); P_wt2e_save3 = zeros(Times_Realtime*48, 1);               
P_pv2e_3 = sdpvar(Times_Realtime, 1, 'full'); P_pv2e_save3 = zeros(Times_Realtime*48, 1);

% -----------------------------------------------------------------设备决策变量定义
P_e2el_3 = sdpvar(Times_Realtime, 1, 'full'); P_e2el_save3 = zeros(Times_Realtime*48, 1);
P_el2H_3 = sdpvar(Times_Realtime, 1, 'full'); P_el2H_save3 = zeros(Times_Realtime*48, 1);

P_H2mr_3 = sdpvar(Times_Realtime, 1, 'full'); P_H2mr_save3 = zeros(Times_Realtime*48, 1);
P_mr2g_3 = sdpvar(Times_Realtime, 1, 'full'); P_mr2g_save3 = zeros(Times_Realtime*48, 1);

P_H2hfc_3 = sdpvar(Times_Realtime, 1, 'full'); P_H2hfc_save3 = zeros(Times_Realtime*48, 1);
P_hfc2e_3 = sdpvar(Times_Realtime, 1, 'full'); P_hfc2e_save3 = zeros(Times_Realtime*48, 1);
P_hfc2h_3 = sdpvar(Times_Realtime, 1, 'full'); P_hfc2h_save3 = zeros(Times_Realtime*48, 1);

P_g2gt_3 = sdpvar(Times_Realtime, 1, 'full'); P_g2gt_save3 = zeros(Times_Realtime*48, 1); P_H2gt_save3 = zeros(Times_Realtime*48, 1);
V_H2gt_3 = sdpvar(Times_Realtime, 1, 'full'); V_H2gt_save3 = zeros(Times_Realtime*48, 1); P_CH42gt_save3 = zeros(Times_Realtime*48, 1);
V_g2gt_3 = sdpvar(Times_Realtime, 1, 'full'); V_g2gt_save3 = zeros(Times_Realtime*48, 1);
M_H2gt_3 = sdpvar(Times_Realtime, 1, 'full'); M_H2gt_save3 = zeros(Times_Realtime*48, 1);
M_g2gt_3 = sdpvar(Times_Realtime, 1, 'full'); M_g2gt_save3 = zeros(Times_Realtime*48, 1);
P_gt2e_3 = sdpvar(Times_Realtime, 1, 'full'); P_gt2e_save3 = zeros(Times_Realtime*48, 1);
P_gt2h_3 = sdpvar(Times_Realtime, 1, 'full'); P_gt2h_save3 = zeros(Times_Realtime*48, 1);

P_g2gb_3 = sdpvar(Times_Realtime, 1, 'full'); P_g2gb_save3 = zeros(Times_Realtime*48, 1);
V_H2gb_3 = sdpvar(Times_Realtime, 1, 'full'); V_H2gb_save3 = zeros(Times_Realtime*48, 1); P_H2gb_save3 = zeros(Times_Realtime*48, 1);
V_g2gb_3 = sdpvar(Times_Realtime, 1, 'full'); V_g2gb_save3 = zeros(Times_Realtime*48, 1); P_CH42gb_save3 = zeros(Times_Realtime*48, 1);
M_H2gb_3 = sdpvar(Times_Realtime, 1, 'full'); M_H2gb_save3 = zeros(Times_Realtime*48, 1);
M_g2gb_3 = sdpvar(Times_Realtime, 1, 'full'); M_g2gb_save3 = zeros(Times_Realtime*48, 1);
P_gb2h_3 = sdpvar(Times_Realtime, 1, 'full'); P_gb2h_save3 = zeros(Times_Realtime*48, 1);

P_e2eb_3 = sdpvar(Times_Realtime, 1, 'full'); P_e2eb_save3 = zeros(Times_Realtime*48, 1);
P_eb2h_3 = sdpvar(Times_Realtime, 1, 'full'); P_eb2h_save3 = zeros(Times_Realtime*48, 1);

%----------------------------------------------------------------------储能决策变量定义
P_bat_cha_3 = sdpvar(Times_Realtime, 1, 'full'); P_bat_cha_save3 = zeros(Times_Realtime*48, 1);
P_bat_dis_3 = sdpvar(Times_Realtime, 1, 'full'); P_bat_dis_save3 = zeros(Times_Realtime*48, 1);
SOC_bat_3 = sdpvar(Times_Realtime+1, 1, 'full'); SOC_bat_save3 = zeros(Times_Realtime*48+1, 1);
Flag_bat_cha_3 = binvar(Times_Realtime, 1, 'full'); Flag_bat_cha_save3 = zeros(Times_Realtime*48, 1);
Flag_bat_dis_3 = binvar(Times_Realtime, 1, 'full'); Flag_bat_dis_save3 = zeros(Times_Realtime*48, 1);

P_hst_cha_3 = sdpvar(Times_Realtime, 1, 'full'); P_hst_cha_save3 = zeros(Times_Realtime*48, 1);
P_hst_dis_3 = sdpvar(Times_Realtime, 1, 'full'); P_hst_dis_save3 = zeros(Times_Realtime*48, 1);
SOC_hst_3 = sdpvar(Times_Realtime+1, 1, 'full'); SOC_hst_save3 = zeros(Times_Realtime*48+1, 1);
Flag_hst_cha_3 = binvar(Times_Realtime, 1, 'full'); Flag_hst_cha_save3 = zeros(Times_Realtime*48, 1);
Flag_hst_dis_3 = binvar(Times_Realtime, 1, 'full'); Flag_hst_dis_save3 = zeros(Times_Realtime*48, 1);

P_tst_cha_3 = sdpvar(Times_Realtime, 1, 'full'); P_tst_cha_save3 = zeros(Times_Realtime*48, 1);
P_tst_dis_3 = sdpvar(Times_Realtime, 1, 'full'); P_tst_dis_save3 = zeros(Times_Realtime*48, 1);
SOC_tst_3 = sdpvar(Times_Realtime+1, 1, 'full'); SOC_tst_save3 = zeros(Times_Realtime*48+1, 1);
Flag_tst_cha_3 = binvar(Times_Realtime, 1, 'full'); Flag_tst_cha_save3 = zeros(Times_Realtime*48, 1);
Flag_tst_dis_3 = binvar(Times_Realtime, 1, 'full'); Flag_tst_dis_save3 = zeros(Times_Realtime*48, 1);

P_gst_cha_3 = sdpvar(Times_Realtime, 1, 'full'); P_gst_cha_save3 = zeros(Times_Realtime*48, 1);
P_gst_dis_3 = sdpvar(Times_Realtime, 1, 'full'); P_gst_dis_save3 = zeros(Times_Realtime*48, 1);
SOC_gst_3 = sdpvar(Times_Realtime+1, 1, 'full'); SOC_gst_save3 = zeros(Times_Realtime*48+1, 1);
Flag_gst_cha_3 = binvar(Times_Realtime, 1, 'full'); Flag_gst_cha_save3 = zeros(Times_Realtime*48, 1);
Flag_gst_dis_3 = binvar(Times_Realtime, 1, 'full'); Flag_gst_dis_save3 = zeros(Times_Realtime*48, 1);

%----------------------------------------------------------------------购能决策变量定义
P_pur_e_3 = sdpvar(Times_Realtime, 1, 'full'); P_pur_e_save3 = zeros(Times_Realtime*48, 1);
P_pur_g_3 = sdpvar(Times_Realtime, 1, 'full'); P_pur_g_save3 = zeros(Times_Realtime*48, 1);

%----------------------------------------------------------------------DR决策变量定义
% 可削减负荷
L_edr_cl_3 = sdpvar(Times_Realtime, 1, 'full'); L_edr_cl_save3 = zeros(Times_Realtime*48, 1);
L_hdr_cl_3 = sdpvar(Times_Realtime, 1, 'full'); L_hdr_cl_save3 = zeros(Times_Realtime*48, 1);
%----------------------------------------------------------------------阶梯碳交易决策变量定义
P_e2ccs_3 = sdpvar(Times_Realtime, 1, 'full'); P_e2ccs_save3 = zeros(Times_Realtime*48, 1);


for i=1:4:81  % 4h-15min, 1h滚动一次，所以i+4，i=1、5、9
    OBJECTIVE_2 = 0;        
    CONSTRAINTS_2 = [];
    % ==================== 源荷参数 ====================
    P_wt2e_max_2 = P_wt2e_15min_pre(i:i+15);
    P_pv2e_max_2 = P_pv2e_15min_pre(i:i+15);
    P_eLoad_2 = P_eLoad_15min_pre(i:i+15);
    P_hLoad_2 = P_hLoad_15min_pre(i:i+15);
    % ==================== 电价气价 ====================
    c_pur_e_2 = c_pur_e_96(i:i+15);           % 16x1，连续16个15min，也就是4小时        
    c_pur_g_2 = c_pur_g_96(i:i+15);
    % ==================== 日前功率参考值，用于计算调整成本 ====================
    P_g2gt_save1_2 = P_g2gt_save1_96(i:i+15);
    P_g2gb_save1_2 = P_g2gb_save1_96(i:i+15);
    P_hst_cha_save1_2 = P_hst_cha_save1_96(i:i+15);
    P_hst_dis_save1_2 = P_hst_dis_save1_96(i:i+15);
    P_tst_cha_save1_2 = P_tst_cha_save1_96(i:i+15);
    P_tst_dis_save1_2 = P_tst_dis_save1_96(i:i+15);
    P_gst_cha_save1_2 = P_gst_cha_save1_96(i:i+15);
    P_gst_dis_save1_2 = P_gst_dis_save1_96(i:i+15);
    % ==================== 日前DR值 ====================
    % 可削减负荷
    L_edr_cl_save1_2 = L_edr_cl_save1_96(i:i+15);
    L_hdr_cl_save1_2 = L_hdr_cl_save1_96(i:i+15);
    % 可转移负荷
    L_edr_sl_in_save1_2 = L_edr_sl_in_save1_96(i:i+15);
    L_edr_sl_out_save1_2 = L_edr_sl_out_save1_96(i:i+15);
    L_hdr_sl_in_save1_2 = L_hdr_sl_in_save1_96(i:i+15);
    L_hdr_sl_out_save1_2 = L_hdr_sl_out_save1_96(i:i+15);

    %% ======== 2.运行约束 ===================================
    % 风机光伏
    CONSTRAINTS_2 = [CONSTRAINTS_2,...
        (0 <= P_wt2e_2 <= P_wt2e_max_2): 'P_wt2e_2',...
        (0 <= P_pv2e_2 <= P_pv2e_max_2): 'P_pv2e_2'
        ];
    % EL电解槽（爬升约束）
    if i == 1
        CONSTRAINTS_2 = [CONSTRAINTS_2,...
        (P_el2H_2 == f_el * P_e2el_2): 'P_el2H_2',...
        (P_el_min <= P_e2el_2 <= P_el_max): 'P_e2el_2',...
        (-Delta_el*P_el_max/4 <= P_e2el_2(2:end)-P_e2el_2(1:end-1) <= Delta_el*P_el_max/4): 'P_e2el_Delta'    
        ];
    else
        CONSTRAINTS_2 = [CONSTRAINTS_2,...
        (P_el2H_2 == f_el * P_e2el_2): 'P_el2H_2',...
        (P_el_min <= P_e2el_2 <= P_el_max): 'P_e2el_2',...
        (-Delta_el*P_el_max/4 <= P_e2el_2(1)-P_e2el_save2(i-1) <= Delta_el*P_el_max/4): 'P_e2el(0)_Delta',...    
        (-Delta_el*P_el_max/4 <= P_e2el_2(2:end)-P_e2el_2(1:end-1) <= Delta_el*P_el_max/4): 'P_e2el_Delta'    
        ];
    end
    % MR甲烷反应器（爬升约束）
    if i == 1
        CONSTRAINTS_2 = [CONSTRAINTS_2,...
        (P_mr2g_2 == f_mr * P_H2mr_2): 'P_mr2g_2',...
        (P_mr_min <= P_H2mr_2 <= P_mr_max): 'P_H2mr_2',...
        (-Delta_mr*P_mr_max/4 <= P_H2mr_2(2:end)-P_H2mr_2(1:end-1) <= Delta_mr*P_mr_max/4): 'P_H2mr_Delta' 
        ];
    else
        CONSTRAINTS_2 = [CONSTRAINTS_2,...
        (P_mr2g_2 == f_mr * P_H2mr_2): 'P_mr2g_2',...
        (P_mr_min <= P_H2mr_2 <= P_mr_max): 'P_H2mr_2',...
        (-Delta_mr*P_mr_max/4 <= P_H2mr_2(1)-P_H2mr_save2(i-1) <= Delta_mr*P_mr_max/4): 'P_H2mr(0)_Delta',... 
        (-Delta_mr*P_mr_max/4 <= P_H2mr_2(2:end)-P_H2mr_2(1:end-1) <= Delta_mr*P_mr_max/4): 'P_H2mr_Delta' 
        ];        
    end
    % HFC燃料电池（爬升约束）
    if i == 1
        CONSTRAINTS_2 = [CONSTRAINTS_2,...
        (P_hfc2e_2 == f_hfc_H2e * P_H2hfc_2): 'P_hfc2e_2',...
        (P_hfc2h_2 == f_hfc_H2h * P_H2hfc_2): 'P_hfc2h_2',...
        (P_hfc2e_2 + P_hfc2h_2 == (f_hfc_H2e+f_hfc_H2h) * P_H2hfc_2): 'P_hfc2e_2 + P_hfc2h_2',...
        (P_hfc_min <= P_H2hfc_2 <= P_hfc_max): 'P_H2hfc_2',...
        (-Delta_hfc*P_hfc_max/4 <= P_H2hfc_2(2:end)-P_H2hfc_2(1:end-1) <= Delta_hfc*P_hfc_max/4): 'P_H2hfc_Delta' 
        ];
    else
        CONSTRAINTS_2 = [CONSTRAINTS_2,...
        (P_hfc2e_2 == f_hfc_H2e * P_H2hfc_2): 'P_hfc2e_2',...
        (P_hfc2h_2 == f_hfc_H2h * P_H2hfc_2): 'P_hfc2h_2',...
        (P_hfc2e_2 + P_hfc2h_2 == (f_hfc_H2e+f_hfc_H2h) * P_H2hfc_2): 'P_hfc2e_2 + P_hfc2h_2',...
        (P_hfc_min <= P_H2hfc_2 <= P_hfc_max): 'P_H2hfc_2',...
        (-Delta_hfc*P_hfc_max/4 <= P_H2hfc_2(1)-P_H2hfc_save2(i-1) <= Delta_hfc*P_hfc_max/4): 'P_H2hfc(0)_Delta',...
        (-Delta_hfc*P_hfc_max/4 <= P_H2hfc_2(2:end)-P_H2hfc_2(1:end-1) <= Delta_hfc*P_hfc_max/4): 'P_H2hfc_Delta' 
        ];
    end
    % GT燃气轮机（爬升约束）
    temp_gt_2 = reshape(P_g2gt_2, 2, []);  % 只是P_g2gt_2的另一种视图，本质还是在操作P_g2gt_2
    if i == 1
        CONSTRAINTS_2 = [CONSTRAINTS_2,...
        (P_g2gt_2 == (LHV_CH4 * M_g2gt_2 + LHV_H2 * M_H2gt_2) ): 'M_H2gt_2',...
        (V_g2gt_2 == M_g2gt_2 / density_CH4): 'V_g2gt_2',...
        (V_H2gt_2 == M_H2gt_2 / density_H2): 'V_H2gt_2',...
        (V_H2gt_2 <= k_H2gt_upper * (V_g2gt_2 + V_H2gt_2)): 'k_H2gt_upper',...
        (V_H2gt_2 >= k_H2gt_lower * (V_g2gt_2 + V_H2gt_2)): 'k_H2gt_lower',...
        (P_gt2e_2 == f_gt_g2e * P_g2gt_2): 'P_gt2e_2',...
        (P_gt2h_2 == f_gt_g2h * P_g2gt_2): 'P_gt2h_2',... 
        (P_gt2e_2 + P_gt2h_2 == (f_gt_g2e+f_gt_g2h) * P_g2gt_2): 'P_gt2e_2 + P_gt2h_2',...
        (P_gt_min <= P_g2gt_2 <= P_gt_max): 'P_g2gt_2',...
        (-Delta_gt*P_gt_max/2 <= P_g2gt_2(3:2:end-1)-P_g2gt_2(2:2:end-2) <= Delta_gt*P_gt_max/2): 'P_g2gt_Delta',...
        (temp_gt_2(1, :) == temp_gt_2(2, :)),...
        (M_g2gt_2 >= 0),... 
        (M_H2gt_2 >= 0)
        ];
    else
        CONSTRAINTS_2 = [CONSTRAINTS_2,...
        (P_g2gt_2 == (LHV_CH4 * M_g2gt_2 + LHV_H2 * M_H2gt_2) ): 'M_H2gt_2',...
        (V_g2gt_2 == M_g2gt_2 / density_CH4): 'V_g2gt_2',...
        (V_H2gt_2 == M_H2gt_2 / density_H2): 'V_H2gt_2',...
        (V_H2gt_2 <= k_H2gt_upper * (V_g2gt_2 + V_H2gt_2)): 'k_H2gt_upper',...
        (V_H2gt_2 >= k_H2gt_lower * (V_g2gt_2 + V_H2gt_2)): 'k_H2gt_lower',...
        (P_gt2e_2 == f_gt_g2e * P_g2gt_2): 'P_gt2e_2',...
        (P_gt2h_2 == f_gt_g2h * P_g2gt_2): 'P_gt2h_2',... 
        (P_gt2e_2 + P_gt2h_2 == (f_gt_g2e+f_gt_g2h) * P_g2gt_2): 'P_gt2e_2 + P_gt2h_2',...
        (P_gt_min <= P_g2gt_2 <= P_gt_max): 'P_g2gt_2',...
        (-Delta_gt*P_gt_max/2 <= P_g2gt_2(1)-P_g2gt_save2(i-1) <= Delta_gt*P_gt_max/2): 'P_g2gt(0)_Delta',...
        (-Delta_gt*P_gt_max/2 <= P_g2gt_2(3:2:end-1)-P_g2gt_2(2:2:end-2) <= Delta_gt*P_gt_max/2): 'P_g2gt_Delta',...
        (temp_gt_2(1, :) == temp_gt_2(2, :)),...
        (M_g2gt_2 >= 0),...
        (M_H2gt_2 >= 0)
        ];
    end
    % GB燃气轮机（爬升约束）
    temp_gb_2 = reshape(P_g2gb_2, 2, []);
    if i == 1
        CONSTRAINTS_2 = [CONSTRAINTS_2,...
        (P_g2gb_2 == (LHV_CH4 * M_g2gb_2 + LHV_H2 * M_H2gb_2) ): 'M_H2gb_2',...
        (V_g2gb_2 == M_g2gb_2 / density_CH4): 'V_g2gb_2',...
        (V_H2gb_2 == M_H2gb_2 / density_H2): 'V_H2gb_2',...
        (V_H2gb_2 <= k_H2gb_upper * (V_g2gb_2 + V_H2gb_2)): 'k_H2gb_upper',...
        (V_H2gb_2 >= k_H2gb_lower * (V_g2gb_2 + V_H2gb_2)): 'k_H2gb_lower',...
        (P_gb2h_2 == f_gb * P_g2gb_2): 'P_gb2h_2',... 
        (P_gb_min <= P_g2gb_2 <= P_gb_max): 'P_g2gb_2',...
        (-Delta_gb*P_gb_max/2 <= P_g2gb_2(3:2:end-1)-P_g2gb_2(2:2:end-2) <= Delta_gb*P_gb_max/2): 'P_g2gb_Delta',...
        temp_gb_2(1, :) == temp_gb_2(2, :),...
        (M_g2gb_2 >= 0),...
        (M_H2gb_2 >= 0)
        ];
    else
        CONSTRAINTS_2 = [CONSTRAINTS_2,...
        (P_g2gb_2 == (LHV_CH4 * M_g2gb_2 + LHV_H2 * M_H2gb_2) ): 'M_H2gb_2',...
        (V_g2gb_2 == M_g2gb_2 / density_CH4): 'V_g2gb_2',...
        (V_H2gb_2 == M_H2gb_2 / density_H2): 'V_H2gb_2',...
        (V_H2gb_2 <= k_H2gb_upper * (V_g2gb_2 + V_H2gb_2)): 'k_H2gb_upper',...
        (V_H2gb_2 >= k_H2gb_lower * (V_g2gb_2 + V_H2gb_2)): 'k_H2gb_lower',...
        (P_gb2h_2 == f_gb * P_g2gb_2): 'P_gb2h_2',... 
        (P_gb_min <= P_g2gb_2 <= P_gb_max): 'P_g2gb_2',...
        (-Delta_gb*P_gb_max/2 <= P_g2gb_2(1)-P_g2gb_save2(i-1) <= Delta_gb*P_gb_max/2): 'P_g2gb(0)_Delta',...    
        (-Delta_gb*P_gb_max/2 <= P_g2gb_2(3:2:end-1)-P_g2gb_2(2:2:end-2) <= Delta_gb*P_gb_max/2): 'P_g2gb_Delta',...
        temp_gb_2(1, :) == temp_gb_2(2, :),...
        (M_g2gb_2 >= 0),...
        (M_H2gb_2 >= 0)
        ];
    end
    % EB电锅炉（爬升约束）
    if i == 1
        CONSTRAINTS_2 = [CONSTRAINTS_2,...
        (P_eb2h_2 == f_eb * P_e2eb_2): 'P_eb2h_2',...
        (P_eb_min <= P_e2eb_2 <= P_eb_max): 'P_e2eb_2',...
        (-Delta_eb*P_eb_max/4 <= P_e2eb_2(2:end)-P_e2eb_2(1:end-1) <= Delta_eb*P_eb_max/4): 'P_e2eb_Delta'  
        ];
    else
        CONSTRAINTS_2 = [CONSTRAINTS_2,...
        (P_eb2h_2 == f_eb * P_e2eb_2): 'P_eb2h_2',...
        (P_eb_min <= P_e2eb_2 <= P_eb_max): 'P_e2eb_2',...
        (-Delta_eb*P_eb_max/4 <= P_e2eb_2(1)-P_e2eb_save2(i-1) <= Delta_eb*P_eb_max/4): 'P_e2eb_Delta',...  
        (-Delta_eb*P_eb_max/4 <= P_e2eb_2(2:end)-P_e2eb_2(1:end-1) <= Delta_eb*P_eb_max/4): 'P_e2eb_Delta'  
        ];
    end
    %% ======== 3.储能约束 ===================================
    % 储电约束Battery，充放能倍率选择0.5C
    if i == 1
        CONSTRAINTS_2 = [CONSTRAINTS_2,...
        (0 <= P_bat_cha_2 <= Flag_bat_cha_2 * Q_bat_max * 0.5): 'P_bat_cha_2',...
        (0 <= P_bat_dis_2 <= Flag_bat_dis_2 * Q_bat_max * 0.5): 'P_bat_dis_2',...
        (Flag_bat_cha_2 + Flag_bat_dis_2 <= 1): 'Flag_bat',...                            
        (SOC_bat_2(1) == f_bat_init): 'SOC_bat_init',...
        (f_bat_min <= SOC_bat_2 <= f_bat_max): 'SOC_bat_range',...        
        (SOC_bat_2(2:end) == SOC_bat_2(1:end-1) + 0.25*f_bat_cha/Q_bat_max*P_bat_cha_2 - 0.25*P_bat_dis_2/(f_bat_dis*Q_bat_max)): 'SOC_bat_Delta'  
        ];
    elseif i == 81
        CONSTRAINTS_2 = [CONSTRAINTS_2,...
        (0 <= P_bat_cha_2 <= Flag_bat_cha_2 * Q_bat_max * 0.5): 'P_bat_cha_2',...
        (0 <= P_bat_dis_2 <= Flag_bat_dis_2 * Q_bat_max * 0.5): 'P_bat_dis_2',...
        (Flag_bat_cha_2 + Flag_bat_dis_2 <= 1): 'Flag_bat',...                            
        (SOC_bat_2(1) == SOC_bat_save2(i)): 'SOC_bat_init',...
        (SOC_bat_2(end) == f_bat_init): 'SOC_bat_end',...
        (f_bat_min <= SOC_bat_2 <= f_bat_max): 'SOC_bat_range',...        
        (SOC_bat_2(2:end) == SOC_bat_2(1:end-1) + 0.25*f_bat_cha/Q_bat_max*P_bat_cha_2 - 0.25*P_bat_dis_2/(f_bat_dis*Q_bat_max)): 'SOC_bat_Delta'  
        ];
    else
        CONSTRAINTS_2 = [CONSTRAINTS_2,...
        (0 <= P_bat_cha_2 <= Flag_bat_cha_2 * Q_bat_max * 0.5): 'P_bat_cha_2',...
        (0 <= P_bat_dis_2 <= Flag_bat_dis_2 * Q_bat_max * 0.5): 'P_bat_dis_2',...
        (Flag_bat_cha_2 + Flag_bat_dis_2 <= 1): 'Flag_bat',...                            
        (SOC_bat_2(1) == SOC_bat_save2(i)): 'SOC_bat_init',...
        (f_bat_min <= SOC_bat_2 <= f_bat_max): 'SOC_bat_range',...        
        (SOC_bat_2(2:end) == SOC_bat_2(1:end-1) + 0.25*f_bat_cha/Q_bat_max*P_bat_cha_2 - 0.25*P_bat_dis_2/(f_bat_dis*Q_bat_max)): 'SOC_bat_Delta'  
        ];
    end    
    % 储氢约束HST
    if i == 1
        CONSTRAINTS_2 = [CONSTRAINTS_2,...
        (0 <= P_hst_cha_2 <= Flag_hst_cha_2 * Q_hst_max * 0.5): 'P_hst_cha_2',...
        (0 <= P_hst_dis_2 <= Flag_hst_dis_2 * Q_hst_max * 0.5): 'P_hst_dis_2',...
        (Flag_hst_cha_2 + Flag_hst_dis_2 <= 1): 'Flag_hst',...                            
        (SOC_hst_2(1) == f_hst_init): 'SOC_hst_init',...
        (f_hst_min <= SOC_hst_2 <= f_hst_max): 'SOC_hst_range',...        
        (SOC_hst_2(2:end) == SOC_hst_2(1:end-1) + 0.25*f_hst_cha/Q_hst_max*P_hst_cha_2 - 0.25*P_hst_dis_2/(f_hst_dis*Q_hst_max)): 'SOC_hst_Delta'
        ];
    elseif i ==  81
        CONSTRAINTS_2 = [CONSTRAINTS_2,...
        (0 <= P_hst_cha_2 <= Flag_hst_cha_2 * Q_hst_max * 0.5): 'P_hst_cha_2',...
        (0 <= P_hst_dis_2 <= Flag_hst_dis_2 * Q_hst_max * 0.5): 'P_hst_dis_2',...
        (Flag_hst_cha_2 + Flag_hst_dis_2 <= 1): 'Flag_hst',...                            
        (SOC_hst_2(1) == SOC_hst_save2(i)): 'SOC_hst_init',...
        (SOC_hst_2(end) == f_hst_init): 'SOC_hst_end',...
        (f_hst_min <= SOC_hst_2 <= f_hst_max): 'SOC_hst_range',...        
        (SOC_hst_2(2:end) == SOC_hst_2(1:end-1) + 0.25*f_hst_cha/Q_hst_max*P_hst_cha_2 - 0.25*P_hst_dis_2/(f_hst_dis*Q_hst_max)): 'SOC_hst_Delta'
        ];
    else
        CONSTRAINTS_2 = [CONSTRAINTS_2,...
        (0 <= P_hst_cha_2 <= Flag_hst_cha_2 * Q_hst_max * 0.5): 'P_hst_cha_2',...
        (0 <= P_hst_dis_2 <= Flag_hst_dis_2 * Q_hst_max * 0.5): 'P_hst_dis_2',...
        (Flag_hst_cha_2 + Flag_hst_dis_2 <= 1): 'Flag_hst',...                            
        (SOC_hst_2(1) == SOC_hst_save2(i)): 'SOC_hst_init',...
        (f_hst_min <= SOC_hst_2 <= f_hst_max): 'SOC_hst_range',...        
        (SOC_hst_2(2:end) == SOC_hst_2(1:end-1) + 0.25*f_hst_cha/Q_hst_max*P_hst_cha_2 - 0.25*P_hst_dis_2/(f_hst_dis*Q_hst_max)): 'SOC_hst_Delta'
        ];
    end    
    % 储热约束TST
    if i == 1
        CONSTRAINTS_2 = [CONSTRAINTS_2,...
        (0 <= P_tst_cha_2 <= Flag_tst_cha_2 * Q_tst_max * 0.5): 'P_tst_cha_2',...
        (0 <= P_tst_dis_2 <= Flag_tst_dis_2 * Q_tst_max * 0.5): 'P_tst_dis_2',...
        (Flag_tst_cha_2 + Flag_tst_dis_2 <= 1): 'Flag_tst',...                            
        (SOC_tst_2(1) == f_tst_init): 'SOC_tst_init',...
        (f_tst_min <= SOC_tst_2 <= f_tst_max): 'SOC_tst_range',...        
        (SOC_tst_2(2:end) == SOC_tst_2(1:end-1) + 0.25*f_tst_cha/Q_tst_max*P_tst_cha_2 - 0.25*P_tst_dis_2/(f_tst_dis*Q_tst_max)): 'SOC_tst_Delta'
        ];
    elseif i == 81
        CONSTRAINTS_2 = [CONSTRAINTS_2,...
        (0 <= P_tst_cha_2 <= Flag_tst_cha_2 * Q_tst_max * 0.5): 'P_tst_cha_2',...
        (0 <= P_tst_dis_2 <= Flag_tst_dis_2 * Q_tst_max * 0.5): 'P_tst_dis_2',...
        (Flag_tst_cha_2 + Flag_tst_dis_2 <= 1): 'Flag_tst',...                            
        (SOC_tst_2(1) == SOC_tst_save2(i)): 'SOC_tst_init',...
        (SOC_tst_2(end) == f_tst_init): 'SOC_tst_end',...
        (f_tst_min <= SOC_tst_2 <= f_tst_max): 'SOC_tst_range',...        
        (SOC_tst_2(2:end) == SOC_tst_2(1:end-1) + 0.25*f_tst_cha/Q_tst_max*P_tst_cha_2 - 0.25*P_tst_dis_2/(f_tst_dis*Q_tst_max)): 'SOC_tst_Delta'
        ];
    else
        CONSTRAINTS_2 = [CONSTRAINTS_2,...
        (0 <= P_tst_cha_2 <= Flag_tst_cha_2 * Q_tst_max * 0.5): 'P_tst_cha_2',...
        (0 <= P_tst_dis_2 <= Flag_tst_dis_2 * Q_tst_max * 0.5): 'P_tst_dis_2',...
        (Flag_tst_cha_2 + Flag_tst_dis_2 <= 1): 'Flag_tst',...                            
        (SOC_tst_2(1) == SOC_tst_save2(i)): 'SOC_tst_init',...
        (f_tst_min <= SOC_tst_2 <= f_tst_max): 'SOC_tst_range',...        
        (SOC_tst_2(2:end) == SOC_tst_2(1:end-1) + 0.25*f_tst_cha/Q_tst_max*P_tst_cha_2 - 0.25*P_tst_dis_2/(f_tst_dis*Q_tst_max)): 'SOC_tst_Delta'
        ];
    end    
    % 储气约束GST
    if i == 1
        CONSTRAINTS_2 = [CONSTRAINTS_2,...
        (0 <= P_gst_cha_2 <= Flag_gst_cha_2 * Q_gst_max * 0.5): 'P_gst_cha_2',...
        (0 <= P_gst_dis_2 <= Flag_gst_dis_2 * Q_gst_max * 0.5): 'P_gst_dis_2',...
        (Flag_gst_cha_2 + Flag_gst_dis_2 <= 1): 'Flag_gst',...                            
        (SOC_gst_2(1) == f_gst_init): 'SOC_gst_init',...
        (f_gst_min <= SOC_gst_2 <= f_gst_max): 'SOC_gst_range',...        
        (SOC_gst_2(2:end) == SOC_gst_2(1:end-1) + 0.25*f_gst_cha/Q_gst_max*P_gst_cha_2 - 0.25*P_gst_dis_2/(f_gst_dis*Q_gst_max)): 'SOC_gst_Delta'
        ];
    elseif i == 81
        CONSTRAINTS_2 = [CONSTRAINTS_2,...
        (0 <= P_gst_cha_2 <= Flag_gst_cha_2 * Q_gst_max * 0.5): 'P_gst_cha_2',...
        (0 <= P_gst_dis_2 <= Flag_gst_dis_2 * Q_gst_max * 0.5): 'P_gst_dis_2',...
        (Flag_gst_cha_2 + Flag_gst_dis_2 <= 1): 'Flag_gst',...                            
        (SOC_gst_2(1) == SOC_gst_save2(i)): 'SOC_gst_init',...
        (SOC_gst_2(end) == f_gst_init): 'SOC_gst_end',...
        (f_gst_min <= SOC_gst_2 <= f_gst_max): 'SOC_gst_range',...        
        (SOC_gst_2(2:end) == SOC_gst_2(1:end-1) + 0.25*f_gst_cha/Q_gst_max*P_gst_cha_2 - 0.25*P_gst_dis_2/(f_gst_dis*Q_gst_max)): 'SOC_gst_Delta'
        ];
    else
        CONSTRAINTS_2 = [CONSTRAINTS_2,...
        (0 <= P_gst_cha_2 <= Flag_gst_cha_2 * Q_gst_max * 0.5): 'P_gst_cha_2',...
        (0 <= P_gst_dis_2 <= Flag_gst_dis_2 * Q_gst_max * 0.5): 'P_gst_dis_2',...
        (Flag_gst_cha_2 + Flag_gst_dis_2 <= 1): 'Flag_gst',...                            
        (SOC_gst_2(1) == SOC_gst_save2(i)): 'SOC_gst_init',...
        (f_gst_min <= SOC_gst_2 <= f_gst_max): 'SOC_gst_range',...        
        (SOC_gst_2(2:end) == SOC_gst_2(1:end-1) + 0.25*f_gst_cha/Q_gst_max*P_gst_cha_2 - 0.25*P_gst_dis_2/(f_gst_dis*Q_gst_max)): 'SOC_gst_Delta'
        ];
    end

    %% ======== 4.1购能约束 ===================================
    % 购电、购气约束
    CONSTRAINTS_2 = [CONSTRAINTS_2,...
        (0 <= P_pur_e_2 <= P_pur_e_max): 'P_pur_e_2',...
        (0 <= P_pur_g_2 <= P_pur_g_max): 'P_pur_g_2'
        ];

    %% ======== 4.2DR约束 ===================================
    % 规定L_edr_2>0 时为削减负荷
    CONSTRAINTS_2 = [CONSTRAINTS_2,...
        (0 <= L_edr_cl_2 <= L_edr_cl_max_2): 'L_edr_cl_2',...
        (0 <= L_hdr_cl_2 <= L_hdr_cl_max_2): 'L_hdr_cl_2'
        ];
    %% ======== 4.3阶梯碳交易 ===================================
    % 实际碳排放，这里只计算天然气部分产生的二氧化碳
    E_actu_e2pur_2 = sum( k_SC_a + k_SC_b*P_pur_e_2 + k_SC_c*(P_pur_e_2.^2) ) / 4;          % 电网实际碳排放量
    P_gt_total_2 = LHV_CH4*M_g2gt_2*f_gt_g2e*phi_eh + LHV_CH4*M_g2gt_2*f_gt_g2h;
    E_actu_gt_2 = sum( k_gas_a + k_gas_b*P_gt_total_2 + k_gas_c*(P_gt_total_2.^2) ) / 4;    % GT实际碳排放量
    P_gb_total_2 = LHV_CH4*M_g2gb_2*f_gb;
    E_actu_gb_2 = sum( k_gas_a + k_gas_b*P_gb_total_2 + k_gas_c*(P_gb_total_2.^2) ) / 4;    % GB实际碳排放量
    E_actu_total_2 = E_actu_e2pur_2 + E_actu_gt_2 + E_actu_gb_2;
    % CCS吸收碳排放量
    E_ccs_total_2 = sum( P_mr2g_2 / LHV_CH4 * w_mr) / 4; 
    CONSTRAINTS_2 = [CONSTRAINTS_2,...
        (P_e2ccs_2 == P_mr2g_2 / LHV_CH4 * w_mr * f_ccus): 'P_e2ccs_2'
        ];
    % 碳配额部分
    E_pe_total_2 = E_pe_total_save1 / (E_actu_total_save1 - E_ccs_total_save1) * (E_actu_total_2 - E_ccs_total_2);
    % 碳交易
    E_tra_2 = E_actu_total_2 - E_pe_total_2 - E_ccs_total_2;     % 参与碳交易的二氧化碳量
    C_lad_CO2_2 = c_lad_di_da * E_tra_2;
    

    %% ======== 5.功率平衡约束 ===================================
    CONSTRAINTS_2 = [CONSTRAINTS_2,...
        ... 电平衡：风光发电 + 电网购电 + GT发电 + HFC发电 + 电池放电 = 电负荷 + EL电解槽电解 + EB电锅炉用电 + CCS用电 + 电池充电 -日前DR_CL+日前DR_SL_in-日前DR_SL_out-日内DR_CL
        (P_wt2e_2+P_pv2e_2+P_pur_e_2+P_gt2e_2+P_hfc2e_2+P_bat_dis_2 ==  P_eLoad_2+P_e2el_2+P_e2eb_2+P_e2ccs_2+P_bat_cha_2-L_edr_cl_save1_2+L_edr_sl_in_save1_2-L_edr_sl_out_save1_2-L_edr_cl_2): 'P_e_balance',...
        ... 热平衡：GT产热 + GB产热 + HFC产热 + EB产热 + 储热放热 = 热负荷 + 储热吸热 - 日前DR_CL+日前DR_SL_in-日前DR_SL_out-日内DR
        (P_gt2h_2 + P_gb2h_2 + P_hfc2h_2 + P_eb2h_2 + P_tst_dis_2 == P_hLoad_2 + P_tst_cha_2-L_hdr_cl_save1_2+L_hdr_sl_in_save1_2-L_hdr_sl_out_save1_2-L_hdr_cl_2): 'P_h_balance',...
        ... 氢平衡：EL产氢 + 储氢放氢 = HFC用氢 + MR用氢 + GT用氢 + GB用氢 + 储氢充氢
        (P_el2H_2 + P_hst_dis_2 == P_H2hfc_2 + P_H2mr_2 + LHV_H2*M_H2gt_2 + LHV_H2*M_H2gb_2 + P_hst_cha_2): 'P_H_balance',...  
        ... 气平衡：气网购气 + MR产气 + 储气放气 = GT用气 + GB用气 + 储气充气
        (P_pur_g_2 + P_mr2g_2 + P_gst_dis_2 == LHV_CH4*M_g2gt_2 + LHV_CH4*M_g2gb_2 + P_gst_cha_2): 'P_g_balance'  
        ];
    %% ======== 6.目标函数 ===================================
    % ==================== 运维成本 ====================
    C_opm_2 = ( sum(P_wt2e_2)*c_opm_wt + sum(P_pv2e_2)*c_opm_pv + sum(P_e2el_2)*c_opm_el + sum(P_H2hfc_2)*c_opm_hfc + ...
        sum(P_g2gt_2)*c_opm_gt + sum(P_g2gb_2)*c_opm_gb + sum(P_e2eb_2)*c_opm_eb ) / 4;
    % ==================== 购能成本 ====================
    % 注意：天然气价格为 元/m3，所以需要转换单位
    C_pur_2 = ( sum(P_pur_e_2.*c_pur_e_2) + sum( P_pur_g_2 / (LHV_CH4 * density_CH4) .* c_pur_g_2 )) / 4;
    % ==================== 储能成本 ====================
    C_st_2 = ( sum(P_bat_cha_2+P_bat_dis_2)*c_st_bat + sum(P_hst_cha_2+P_hst_dis_2)*c_st_hst + sum(P_tst_cha_2+P_tst_dis_2)*c_st_tst + ...
        sum(P_gst_cha_2+P_gst_dis_2)*c_st_gst ) / 4;
    % ==================== 弃能成本 ====================
    C_abd_2 = ( sum(P_wt2e_max_2 - P_wt2e_2)*c_abd_wt + sum(P_pv2e_max_2 - P_pv2e_2)*c_abd_pv ) / 4;
    % ==================== 调整成本（新增） ====================
    C_adj_2 = ( sum(abs(P_g2gt_2 - P_g2gt_save1_2))*c_adj_2 + sum(abs(P_g2gb_2 - P_g2gb_save1_2)) * c_adj_2 + ...
        sum(abs(P_hst_cha_2 - P_hst_cha_save1_2))*c_adj_2 +  sum(abs(P_hst_dis_2 - P_hst_dis_save1_2))*c_adj_2 + ...
        sum(abs(P_tst_cha_2 - P_tst_cha_save1_2))*c_adj_2 +  sum(abs(P_tst_dis_2 - P_tst_dis_save1_2))*c_adj_2 + ...
        sum(abs(P_gst_cha_2 - P_gst_cha_save1_2))*c_adj_2 +  sum(abs(P_gst_dis_2 - P_gst_dis_save1_2))*c_adj_2 ) / 4;
    % ==================== DR成本 ====================
    C_dr_2 = ( sum(L_edr_cl_2)*c_edr_cl_2  + sum(L_hdr_cl_2)*c_hdr_cl_2 ) / 4;
   
    %% ======== 7.求解 ===================================
    OBJECTIVE_2 = OBJECTIVE_2 + C_opm_2 + C_pur_2 + C_st_2 + C_abd_2 + C_adj_2 + C_dr_2 + C_lad_CO2_2;
    OPTIONS = sdpsettings('solver', 'cplex', 'verbose', 0, 'showprogress', 0);
    % 在数学优化中，容差参数用于处理数值计算中的舍入误差和数值不稳定性。由于计算机使用浮点数运算，严格的等式约束在实际中很难完全满足。
    OPTIONS.cplex.eprhs = 1e-6;     % 可行性容差
    OPTIONS.cplex.epopt = 1e-6;     % 最优性容差
    sol = optimize(CONSTRAINTS_2, OBJECTIVE_2, OPTIONS);
    
    if sol.problem == 0
        win = (i-1)/4 + 1;
        fprintf("日内滚动窗口 %d（起点索引 i=%d）求解成功\n", win, i);

    else 
        disp("出错了，原因是：");
        disp(sol.info);
        
        % 正确的调试方法
        if sol.problem == 1
            disp("问题不可行，检查约束条件");
            % 检查哪些约束不满足
            disp("检查约束可行性:");
            check(CONSTRAINTS_2);
        else
            disp(["求解器返回代码: ", num2str(sol.problem)]);
        end
    end  %if sol.problem == 0 

    %% ======== 8.保存4h-15min求解值 ===================================
    if IF_VALUE_Dayin
        %-------------------------------------------设备决策变量保存
        P_wt2e_save2(i:i+15) = zero_tiny(value(P_wt2e_2(1:end))); P_pv2e_save2(i:i+15) = zero_tiny(value(P_pv2e_2(1:end)));
        P_e2el_save2(i:i+15) = zero_tiny(value(P_e2el_2(1:end))); P_el2H_save2(i:i+15) = zero_tiny(value(P_el2H_2(1:end)));
        P_H2mr_save2(i:i+15) = zero_tiny(value(P_H2mr_2(1:end))); P_mr2g_save2(i:i+15) = zero_tiny(value(P_mr2g_2(1:end)));
        P_H2hfc_save2(i:i+15) = zero_tiny(value(P_H2hfc_2(1:end))); P_hfc2e_save2(i:i+15) = zero_tiny(value(P_hfc2e_2(1:end))); P_hfc2h_save2(i:i+15) = zero_tiny(value(P_hfc2h_2(1:end)));

        P_g2gt_save2(i:i+15) = zero_tiny(value(P_g2gt_2(1:end)));
        P_H2gt_save2(i:i+15) = zero_tiny(value(LHV_H2*M_H2gt_2(1:end))); P_CH42gt_save2(i:i+15) = zero_tiny(value(LHV_CH4*M_g2gt_2(1:end)));
        V_H2gt_save2(i:i+15) = zero_tiny(value(V_H2gt_2(1:end))); V_g2gt_save2(i:i+15) = zero_tiny(value(V_g2gt_2(1:end)));
        M_H2gt_save2(i:i+15) = zero_tiny(value(M_H2gt_2(1:end))); M_g2gt_save2(i:i+15) = zero_tiny(value(M_g2gt_2(1:end)));
        P_gt2e_save2(i:i+15) = zero_tiny(value(P_gt2e_2(1:end))); P_gt2h_save2(i:i+15) = zero_tiny(value(P_gt2h_2(1:end)));

        P_g2gb_save2(i:i+15) = zero_tiny(value(P_g2gb_2(1:end)));
        P_H2gb_save2(i:i+15) = zero_tiny(value(LHV_H2*M_H2gb_2(1:end))); P_CH42gb_save2(i:i+15) = zero_tiny(value(LHV_CH4*M_g2gb_2(1:end)));
        V_H2gb_save2(i:i+15) = zero_tiny(value(V_H2gb_2(1:end))); V_g2gb_save2(i:i+15) = zero_tiny(value(V_g2gb_2(1:end)));
        M_H2gb_save2(i:i+15) = zero_tiny(value(M_H2gb_2(1:end))); M_g2gb_save2(i:i+15) = zero_tiny(value(M_g2gb_2(1:end)));
        P_gb2h_save2(i:i+15) = zero_tiny(value(P_gb2h_2(1:end)));

        P_e2eb_save2(i:i+15) = zero_tiny(value(P_e2eb_2(1:end))); P_eb2h_save2(i:i+15) = zero_tiny(value(P_eb2h_2(1:end)));
        %-------------------------------------------储能决策变量保存
        P_bat_cha_save2(i:i+15) = zero_tiny(value(P_bat_cha_2(1:end))); P_bat_dis_save2(i:i+15) = zero_tiny(value(P_bat_dis_2(1:end)));
        SOC_bat_save2(i:i+16) = zero_tiny(value(SOC_bat_2(1:end)));
        Flag_bat_cha_save2(i:i+15) = zero_tiny(value(Flag_bat_cha_2(1:end))); Flag_bat_dis_save2(i:i+15) = zero_tiny(value(Flag_bat_dis_2(1:end)));

        P_hst_cha_save2(i:i+15) = zero_tiny(value(P_hst_cha_2(1:end))); P_hst_dis_save2(i:i+15) = zero_tiny(value(P_hst_dis_2(1:end)));
        SOC_hst_save2(i:i+16) = zero_tiny(value(SOC_hst_2(1:end)));
        Flag_hst_cha_save2(i:i+15) = zero_tiny(value(Flag_hst_cha_2(1:end))); Flag_hst_dis_save2(i:i+15) = zero_tiny(value(Flag_hst_dis_2(1:end)));

        P_tst_cha_save2(i:i+15) = zero_tiny(value(P_tst_cha_2(1:end))); P_tst_dis_save2(i:i+15) = zero_tiny(value(P_tst_dis_2(1:end)));
        SOC_tst_save2(i:i+16) = zero_tiny(value(SOC_tst_2(1:end)));
        Flag_tst_cha_save2(i:i+15) = zero_tiny(value(Flag_tst_cha_2(1:end))); Flag_tst_dis_save2(i:i+15) = zero_tiny(value(Flag_tst_dis_2(1:end)));

        P_gst_cha_save2(i:i+15) = zero_tiny(value(P_gst_cha_2(1:end))); P_gst_dis_save2(i:i+15) = zero_tiny(value(P_gst_dis_2(1:end)));
        SOC_gst_save2(i:i+16) = zero_tiny(value(SOC_gst_2(1:end)));
        Flag_gst_cha_save2(i:i+15) = zero_tiny(value(Flag_gst_cha_2(1:end))); Flag_gst_dis_save2(i:i+15) = zero_tiny(value(Flag_gst_dis_2(1:end)));
        %----------------------------------------------------------------------购能决策变量保存
        P_pur_e_save2(i:i+15) = zero_tiny(value(P_pur_e_2(1:end))); P_pur_g_save2(i:i+15) = zero_tiny(value(P_pur_g_2(1:end)));
        %----------------------------------------------------------------------DR决策变量保存
        L_edr_cl_save2(i:i+15) = zero_tiny(value(L_edr_cl_2(1:end))); L_hdr_cl_save2(i:i+15) = zero_tiny(value(L_hdr_cl_2(1:end)));
        %----------------------------------------------------------------------阶梯碳交易决策变量保存
        P_e2ccs_save2(i:i+15) = zero_tiny(value(P_e2ccs_2(1:end)));
    end %if IF_VALUE_Dayin

    %% ****** 三、实时阶段 ***************************************
    run('main3.m');

end %for i=1:4:81  % 4h-15min, 1h滚动一次，所以i+4


%% ======== 9.绘图4h-15min（24h）调度结果 ===================================
%----------------------------------------------------------------------功率平衡变量定义
P_eBalanceGen_2 = [P_pur_e_save2, P_wt2e_save2, P_pv2e_save2, P_gt2e_save2, P_hfc2e_save2, P_bat_dis_save2]; 
P_eBalanceCon_2 = [P_eLoad_15min_pre - L_edr_cl_save1_96 + L_edr_sl_in_save1_96 - L_edr_sl_out_save1_96 - L_edr_cl_save2,...
    P_e2el_save2, P_e2eb_save2, P_e2ccs_save2, P_bat_cha_save2];

P_hBalanceGen_2 = [P_gt2h_save2, P_gb2h_save2, P_hfc2h_save2, P_eb2h_save2, P_tst_dis_save2];
P_hBalanceCon_2 = [P_hLoad_15min_pre - L_hdr_cl_save1_96 + L_hdr_sl_in_save1_96 - L_hdr_sl_out_save1_96 - L_hdr_cl_save2,... 
    P_tst_cha_save2];

P_HBalanceGen_2 = [P_el2H_save2, P_hst_dis_save2];
P_HBalanceCon_2 = [P_H2hfc_save2, P_H2mr_save2, P_H2gt_save2, P_H2gb_save2, P_hst_cha_save2];

P_gBalanceGen_2 = [P_pur_g_save2, P_mr2g_save2, P_gst_dis_save2];
P_gBalanceCon_2 = [P_CH42gt_save2, P_CH42gb_save2, P_gst_cha_save2];

P_BalanceGen_2 = {P_eBalanceGen_2, P_hBalanceGen_2, P_HBalanceGen_2, P_gBalanceGen_2};
P_BalanceCon_2 = {P_eBalanceCon_2, P_hBalanceCon_2, P_HBalanceCon_2, P_gBalanceCon_2};
if IF_ResultPlot_Dayahead
     utils.resultplot_dayin(P_BalanceGen_2, P_BalanceCon_2);
end


%% ======== 10.绘图30-5min（24h）调度结果 ===================================
%----------------------------------------------------------------------绘图变量
% 日前DR响应量，24 --> 288
% 行39已经处理过了

% 日内DR响应量，96 --> 288
L_edr_cl_save2_288 = repmat(L_edr_cl_save2', 3, 1); L_edr_cl_save2_288 = reshape(L_edr_cl_save2_288, [], 1);
L_hdr_cl_save2_288 = repmat(L_hdr_cl_save2', 3, 1); L_hdr_cl_save2_288 = reshape(L_hdr_cl_save2_288, [], 1);

%----------------------------------------------------------------------功率平衡变量定义
P_eBalanceGen_3 = [P_pur_e_save3, P_wt2e_save3, P_pv2e_save3, P_gt2e_save3, P_hfc2e_save3, P_bat_dis_save3]; 
P_eBalanceCon_3 = [P_eLoad_5min_pre - L_edr_cl_save1_288 + L_edr_sl_in_save1_288 - L_edr_sl_out_save1_288 - L_edr_cl_save2_288 - L_edr_cl_save3,...
    P_e2el_save3, P_e2eb_save3, P_e2ccs_save3, P_bat_cha_save3];

P_hBalanceGen_3 = [P_gt2h_save3, P_gb2h_save3, P_hfc2h_save3, P_eb2h_save3, P_tst_dis_save3];
P_hBalanceCon_3 = [P_hLoad_5min_pre - L_hdr_cl_save1_288 + L_hdr_sl_in_save1_288 - L_hdr_sl_out_save1_288 - L_hdr_cl_save2_288 - L_hdr_cl_save3,... 
    P_tst_cha_save3];

P_HBalanceGen_3 = [P_el2H_save3, P_hst_dis_save3];
P_HBalanceCon_3 = [P_H2hfc_save3, P_H2mr_save3, P_H2gt_save3, P_H2gb_save3, P_hst_cha_save3];

P_gBalanceGen_3 = [P_pur_g_save3, P_mr2g_save3, P_gst_dis_save3];
P_gBalanceCon_3 = [P_CH42gt_save3, P_CH42gb_save3, P_gst_cha_save3];

P_BalanceGen_3 = {P_eBalanceGen_3, P_hBalanceGen_3, P_HBalanceGen_3, P_gBalanceGen_3};
P_BalanceCon_3 = {P_eBalanceCon_3, P_hBalanceCon_3, P_HBalanceCon_3, P_gBalanceCon_3};
if IF_ResultPlot_Realtime
     utils.resultplot_realtime(P_BalanceGen_3, P_BalanceCon_3);
end


