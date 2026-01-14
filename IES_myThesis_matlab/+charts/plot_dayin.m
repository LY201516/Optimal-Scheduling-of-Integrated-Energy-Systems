% 日内阶段绘图
%% ========= 日内DR前后 =================================================
figure;
NoDR_base_96 = P_eLoad_1;
NoDR_base_96 = repmat(NoDR_base_96', 4, 1);
NoDR_base_96 = reshape(NoDR_base_96, [], 1);
plot(NoDR_base_96, 'r--', 'LineWidth', 1.2,'DisplayName', "DR前")
hold on;
DR_Load_da = NoDR_base_96 - L_edr_cl_save1_96 + L_edr_sl_in_save1_96 - L_edr_sl_out_save1_96;
plot(DR_Load_da, 'b-', 'LineWidth', 1.2, 'DisplayName', "日前DR后");
hold on;
DR_Load_di = NoDR_base_96 - L_edr_cl_save1_96 + L_edr_sl_in_save1_96 - L_edr_sl_out_save1_96 - L_edr_cl_save2;
plot(DR_Load_di, 'k-', 'LineWidth', 1.2, 'DisplayName', "日内DR后");
legend;


figure;
NoDR_base_96 = P_hLoad_1;
NoDR_base_96 = repmat(NoDR_base_96', 4, 1);
NoDR_base_96 = reshape(NoDR_base_96, [], 1);
plot(NoDR_base_96, 'r--', 'LineWidth', 1.2,'DisplayName', "DR前")
hold on;
DR_Load_da = NoDR_base_96 - L_hdr_cl_save1_96 + L_hdr_sl_in_save1_96 - L_hdr_sl_out_save1_96;
plot(DR_Load_da, 'b-', 'LineWidth', 1.2, 'DisplayName', "日前DR后");
hold on;
DR_Load_di = NoDR_base_96 - L_hdr_cl_save1_96 + L_hdr_sl_in_save1_96 - L_hdr_sl_out_save1_96 - L_hdr_cl_save2;
plot(DR_Load_di, 'k-', 'LineWidth', 1.2, 'DisplayName', "日内DR后");
legend