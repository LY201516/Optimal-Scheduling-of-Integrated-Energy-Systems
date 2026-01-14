function [] = resultplot_dayin(P_BalanceGen_2, P_BalanceCon_2)
    % ==================== 公共变量 ===================
    time = 0:minutes(15):hours(24);
    time = time(1:end-1);
    time_ticks = 0:minutes(120):hours(24);
    % ==================== 电功率平衡图片 ===================
    P_eBalanceGen_2 = P_BalanceGen_2{1};    % {}为直接取出矩阵，()返回的依旧是一个元胞数组
    P_eBalanceCon_2 = P_BalanceCon_2{1};
    newcolor1 = [
        "#C74D26", "#B092B6", "#E38D26", "#CAC1D4", "#5F9C61", "#F1CC74",... 
        "#5EA7B8", "#AED2E2", "#308192", "#A4C97C"];
    figure;
    set(gcf, 'Units', "centimeters", 'Position', [2 2 30 20]); 
    % set(gca, 'Position', [0.06 0.06 0.9 0.89]);  % 带标题
    set(gca, 'Position', [0.06 0.06 0.92 0.92]);  % 无标题
    bar(time, P_eBalanceGen_2, "stacked", 'EdgeColor', "none"); 
    xticks(time_ticks);
    xtickformat("hh:mm")
    hold on;
    bar(time, -P_eBalanceCon_2, "stacked", 'EdgeColor', "none");
    colororder(newcolor1); 
    % title('电功率平衡图', 'FontName', "SimSun", 'FontSize', 18, 'FontWeight', "bold");
    xtickformat('hh:mm')
    xlabel('时间', 'FontName', "SimSun", 'FontSize', 14, 'FontWeight', "bold");
    ylabel('功率/kW', 'FontName', "SimSun", 'FontSize', 14, 'FontWeight', "bold");
    lgd = legend("电网购电", "WT发电", "PV发电", "GT发电", "HFC发电", "Bat放电", "电负荷", "EL用电", "EB用电", "Bat充电");
    lgd.NumColumns = 6;
    lgd.Location = "south";
    lgd.Orientation = "horizontal";
    lgd.FontName = "SimSun";
    lgd.FontSize = 12;
    grid("on"); grid("minor");
    ax = gca;
    ylim = ax.YLim;
    ylin_start = ylim(1); ylim_end = ylim(2);
    ax.YLim = [ylin_start+0.2*ylin_start, ylim_end];
    

    % ==================== 热功率平衡图片 ===================
    P_hBalanceGen_2 = P_BalanceGen_2{2};
    P_hBalanceCon_2 = P_BalanceCon_2{2};
    newcolor2 = ["#B092B6", "#E38D26", "#5F9C61", "#CAC1D4", "#A4C97C",...
        "#C74D26", "#F1CC74"];
    figure;
    set(gcf, 'Units', "centimeters", 'Position', [3 2 30 20]); 
    % set(gca, 'Position', [0.06 0.06 0.9 0.89]);
    set(gca, 'Position', [0.06 0.06 0.92 0.92]);  % 无标题
    bar(time, P_hBalanceGen_2, "stacked", 'EdgeColor', "none"); 
    hold on;
    bar(time, -P_hBalanceCon_2, "stacked", 'EdgeColor', "none");
    colororder(newcolor2); 
    % title('热功率平衡图', 'FontName', "SimSun", 'FontSize', 18, 'FontWeight', "bold");
    xticks(time_ticks);
    xtickformat("hh:mm")
    xlabel('时间', 'FontName', "SimSun", 'FontSize', 14, 'FontWeight', "bold");
    ylabel('功率/kW', 'FontName', "SimSun", 'FontSize', 14, 'FontWeight', "bold");
    lgd = legend("GT供热", "GB供热", "HFC供热", "EB供热", "TST供热", "热负荷", "TST储热");
    lgd.NumColumns = 5;
    lgd.Location = "south";
    lgd.Orientation = "horizontal";
    lgd.FontName = "SimSun";
    lgd.FontSize = 12;
    grid("on"); grid("minor");


    
    % ==================== 氢功率平衡图片 ===================
    P_HBalanceGen_2 = P_BalanceGen_2{3};
    P_HBalanceCon_2 = P_BalanceCon_2{3};
    newcolor3 = ["#5F9C61", "#A4C97C",...
        "#B092B6", "#308192", "#5EA7B8", "#AED2E2", "#CAC1D4"];
    figure;
    set(gcf, 'Units', "centimeters", 'Position', [4 2 30 20]); 
    % set(gca, 'Position', [0.06 0.06 0.9 0.89]);
    set(gca, 'Position', [0.06 0.06 0.92 0.92]);  % 无标题
    bar(time, P_HBalanceGen_2, "stacked", 'EdgeColor', "none"); 
    hold on;
    bar(time, -P_HBalanceCon_2, "stacked", 'EdgeColor', "none");
    colororder(newcolor3); 
    % title('氢功率平衡图', 'FontName', "SimSun", 'FontSize', 18, 'FontWeight', "bold");
    xticks(time_ticks);
    xtickformat("hh:mm")
    xlabel('时间', 'FontName', "SimSun", 'FontSize', 14, 'FontWeight', "bold");
    ylabel('功率/kW', 'FontName', "SimSun", 'FontSize', 14, 'FontWeight', "bold");
    lgd = legend("EL产氢", "HST供氢", "HFC耗氢", "MR耗氢", "GT耗氢", "GB耗氢", "HST储氢");
    lgd.NumColumns  = 10;
    lgd.Location = "south";
    lgd.Orientation = "horizontal";
    lgd.FontName = "SimSun";
    lgd.FontSize = 12;
    grid("on"); grid("minor");

    % ==================== 气功率平衡图片 ===================
    P_gBalanceGen_2 = P_BalanceGen_2{4};
    P_gBalanceCon_2 = P_BalanceCon_2{4};
    newcolor4 = ["#B092B6", "#5EA7B8", "#AED2E2",...
        "#E38D26", "#F1CC74", "#CAC1D4"];
    figure;
    set(gcf, 'Units', "centimeters", 'Position', [5 2 30 20]); 
    % set(gca, 'Position', [0.06 0.06 0.9 0.89]);
    set(gca, 'Position', [0.06 0.06 0.92 0.92]);  % 无标题
    bar(time, P_gBalanceGen_2, "stacked", 'EdgeColor', "none"); 
    hold on;
    bar(time, -P_gBalanceCon_2, "stacked", 'EdgeColor', "none");
    colororder(newcolor4); 
    % title('气功率平衡图', 'FontName', "SimSun", 'FontSize', 18, 'FontWeight', "bold");
    xticks(time_ticks);
    xtickformat("hh:mm")
    xlabel('时间', 'FontName', "SimSun", 'FontSize', 14, 'FontWeight', "bold");
    ylabel('功率/kW', 'FontName', "SimSun", 'FontSize', 14, 'FontWeight', "bold");
    lgd = legend("气网购气", "MR产气", "GST供气", "GT耗气", "GB耗气", "GST储气");
    lgd.NumColumns = 10;
    lgd.Location = "south";
    lgd.Orientation = "horizontal";
    lgd.FontName = "SimSun";
    lgd.FontSize = 12;
    grid("on"); grid("minor");
end