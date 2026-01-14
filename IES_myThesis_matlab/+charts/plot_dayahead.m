% 日前阶段绘图
%% ========= SOC变化 =================================================
figure;
plot(SOC_bat_save1, 'b--*', 'LineWidth', 1.2, 'DisplayName', "电池SOC");
hold on;
plot(SOC_hst_save1, 'g--^', 'LineWidth', 1.2, 'DisplayName', "储氢SOC");
hold on;
plot(SOC_tst_save1, 'r-v', 'LineWidth', 1.5, 'DisplayName', "储热SOC");
hold on;
plot(SOC_gst_save1, 'm-x', 'LineWidth', 1.5, 'DisplayName', "储气SOC");
legend;

%% ========= 日前DR前后 =================================================
figure;
plot(P_eLoad_1, 'r--', 'LineWidth', 1.2,'DisplayName', "DR前")
hold on;
% plot(P_eLoad_1-L_edr_cl_save1, 'b-', 'LineWidth', 1.2, 'DisplayName', "DR后");
% plot(P_eLoad_1-L_edr_sl_out_save1, 'b-', 'LineWidth', 1.2, 'DisplayName', "DR后");
plot(P_eLoad_1-L_edr_cl_save1+L_edr_sl_in_save1-L_edr_sl_out_save1, 'b-', 'LineWidth', 1.2, 'DisplayName', "DR后");
legend;

figure;
plot(c_pur_e, 'm-^', 'DisplayName', "电价");
legend;

figure;
plot(c_pur_g, 'm-^', 'DisplayName', "电价");
legend;

figure;
plot(P_hLoad_1, 'r--', 'LineWidth', 1.2,'DisplayName', "DR前")
hold on;
% plot(P_hLoad_1-L_hdr_cl_save1, 'b-', 'LineWidth', 1.2, 'DisplayName', "DR后");
plot(P_hLoad_1-L_hdr_cl_save1+L_hdr_sl_in_save1-L_hdr_sl_out_save1, 'b-', 'LineWidth', 1.2, 'DisplayName', "DR后");
legend;

%% ========= 弃风弃光 =================================================
% 弃风弃光率（真实值）
rate_abandon_wt = (P_wt2e_1h - P_wt2e_save1) ./ P_wt2e_1h;
figure;
plot(rate_abandon_wt);
title("弃风率");
rate_abandon_pv = (P_pv2e_1h - P_pv2e_save1) ./ P_pv2e_1h;
figure;
plot(rate_abandon_pv); 
title("弃光率");
rate_abandon = (P_wt2e_1h - P_wt2e_save1 + P_pv2e_1h - P_pv2e_save1) ./ (P_wt2e_1h + P_pv2e_1h);
figure;
plot(rate_abandon);
title("弃能率");
% 弃风弃光率（预测值）
rate_abandon_wt = (P_wt2e_max_1 - P_wt2e_save1) ./ P_wt2e_max_1;
figure;
plot(rate_abandon_wt);
title("弃风率");
rate_abandon_pv = (P_pv2e_max_1 - P_pv2e_save1) ./ P_pv2e_max_1;
figure;
plot(rate_abandon_pv); 
title("弃光率");
rate_abandon = (P_wt2e_max_1 - P_wt2e_save1 + P_pv2e_max_1 - P_pv2e_save1) ./ (P_wt2e_max_1 + P_pv2e_max_1);
figure;
plot(rate_abandon);
title("弃能率");

%% ========= 掺氢比例 =================================================
% 燃气轮机/燃气锅炉掺氢比例
rate_HinG = V_H2gt_save1 ./ (V_H2gt_save1 + V_g2gt_save1);
figure;
plot(rate_HinG)
title("燃气轮机掺氢");

figure;
plot(V_H2gt_save1);

rate_HinG = V_H2gb_save1 ./ (V_H2gb_save1 + V_g2gb_save1);
figure;
plot(rate_HinG)
title("燃气锅炉掺氢");

