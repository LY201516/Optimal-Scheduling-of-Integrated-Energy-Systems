%% ========= 数值结果 =================================================
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
% -------------碳排放量计算-------------
% 日前碳配额部分
% E_pe_total_save1

% 碳配额部分
E_pe_e2pur_save3 = sum( P_pur_e_save3 * w_e2pur ) / 12;                     % 电网碳配额
E_pe_gt_save3 = sum( (phi_eh*P_gt2e_save3 + P_gt2h_save3)*w_h ) / 12;       % GT配额
E_pe_gb_save3 = sum( P_gb2h_save3 * w_h ) / 12;                             % GB配额
E_pe_total_save3 = E_pe_e2pur_save3 + E_pe_gt_save3 + E_pe_gb_save3;
% 实际碳排放，这里只计算天然气部分产生的二氧化碳
E_actu_e2pur_save3 = sum( k_SC_a + k_SC_b*P_pur_e_save3 + k_SC_c*(P_pur_e_save3.^2) ) / 12;      % 电网实际碳排放量
P_gt_total_save3= LHV_CH4*M_g2gt_save3*f_gt_g2e*phi_eh + LHV_CH4*M_g2gt_save3*f_gt_g2h;
E_actu_gt_save3 = sum( k_gas_a + k_gas_b*P_gt_total_save3 + k_gas_c*(P_gt_total_save3.^2) ) / 12;    % GT实际碳排放量
P_gb_total_save3 = LHV_CH4*M_g2gb_save3*f_gb;
E_actu_gb_save3 = sum( k_gas_a + k_gas_b*P_gb_total_save3 + k_gas_c*(P_gb_total_save3.^2) ) / 12;    % GB实际碳排放量
E_actu_total_save3 = E_actu_e2pur_save3 + E_actu_gt_save3 + E_actu_gb_save3;
% CCS吸收碳排放量
E_ccs_total_save3 = sum( P_mr2g_save3 / LHV_CH4 * w_mr) / 12;
% 净碳排放量
E_net = E_actu_total_save3 - E_pe_total_save3 - E_ccs_total_save3; 
% C_net = E_net * 0.25;
switch true
    case 0 < E_net <= d_lad
        C_net = lambda_lad * E_net;

    case d_lab < E_net <= 2*d_lad
        C_net = lambda_lad*d_lad  +  lambda_lad*(1 + alpha_lad)*(E_net-d_lad);

    case 2*d_lab < E_net <= 3*d_lad
        C_net = lambda_lad*(2+alpha_lad)*d_lad  +  lambda_lad*(1+2*alpha_lad)*(E_net-2*d_lad);

    case 3*d_lad < E_net <= 4*d_lad
        C_net = llambda_lad*(3+3*alpha_lad)*d_lad  +  lambda_lad*(1+3*alpha_lad)*(E_net-3*d_lad);

    case 4*d_lad < E_net <= 5*d_lad
        C_net = lambda_lad*(4+6*alpha_lad)*d_lad  +  lambda_lad*(1+4*alpha_lad)*(E_net-4*d_lad);

    case E_net > 5*d_lad
        C_net = lambda_lad*(5+10*alpha_lad)*d_lad  +  lambda_lad*(1+5*alpha_lad)*(E_net-5*d_lad);
                     
end


% ------------购能成本-------------------
C_pur_e_save3 = ( sum(P_pur_e_save3.*c_pur_e_288) ) / 12;
C_pur_g_save3 = ( sum( P_pur_g_save3 / (LHV_CH4 * density_CH4) .* c_pur_g_288) ) / 12;
% ------------DR成本 -------------------
C_dr_cl_1 = sum(L_edr_cl_save1)*c_edr_cl_1 + sum(L_hdr_cl_save1)*c_hdr_cl_1;
C_dr_sl_1 = sum(L_edr_sl_out_save1)*c_edr_sl_1 + sum(L_hdr_sl_out_save1)*c_hdr_sl_1;
C_dr_2 = ( sum(L_edr_cl_save2_288)*c_edr_cl_2  + sum(L_hdr_cl_save2_288)*c_hdr_cl_2 ) / 12;
C_dr_3 = ( sum(L_edr_cl_save3)*c_edr_cl_3 + sum(L_hdr_cl_save3)*c_hdr_cl_3 ) / 12;
C_dr = C_dr_cl_1 + C_dr_sl_1 + C_dr_2 + C_dr_3;

% ------------其他成本-------------------
C_opm_save3 = ( sum(P_wt2e_save3)*c_opm_wt + sum(P_pv2e_save3)*c_opm_pv + sum(P_e2el_save3)*c_opm_el + sum(P_H2hfc_save3)*c_opm_hfc + ...
    sum(P_g2gt_save3)*c_opm_gt + sum(P_g2gb_save3)*c_opm_gb + sum(P_e2eb_save3)*c_opm_eb ) / 12;

C_st_save3 = ( sum(P_bat_cha_save3+P_bat_dis_save3)*c_st_bat + sum(P_hst_cha_save3+P_hst_dis_save3)*c_st_hst + sum(P_tst_cha_save3+P_tst_dis_save3)*c_st_tst + ...
    sum(P_gst_cha_save3+P_gst_dis_save3)*c_st_gst ) / 12;

C_abd_save3 = ( sum(P_wt2e_5min_pre - P_wt2e_save3)*c_abd_wt + sum(P_pv2e_5min_pre - P_pv2e_save3)*c_abd_pv ) / 12;

C_adj_save3 = ( sum(abs(P_g2gt_save3 - P_g2gt_save2_288))*c_adj_3 + sum(abs(P_g2gb_save3 - P_g2gb_save2_288)) * c_adj_3 + ...
    sum(abs(P_e2el_save3 - P_e2el_save2_288))*c_adj_3 + sum(abs(P_H2mr_save3 - P_H2mr_save2_288))*c_adj_3 + sum(abs(P_e2eb_save3 - P_e2eb_save2_288))*c_adj_3 +...
    sum(abs(P_hst_cha_save3 - P_hst_cha_save2_288))*c_adj_3 +  sum(abs(P_hst_dis_save3 - P_hst_dis_save2_288))*c_adj_3 + ...
    sum(abs(P_tst_cha_save3 - P_tst_cha_save2_288))*c_adj_3 +  sum(abs(P_tst_dis_save3 - P_tst_dis_save2_288))*c_adj_3 + ...
    sum(abs(P_gst_cha_save3 - P_gst_cha_save2_288))*c_adj_3 +  sum(abs(P_gst_dis_save3 - P_gst_dis_save2_288))*c_adj_3 ) / 12;

C_else = C_opm_save3 + C_st_save3 + C_abd_save3 + C_adj_save3;
C_all = C_else + C_net + C_pur_e_save3 + C_pur_g_save3 + C_dr;
