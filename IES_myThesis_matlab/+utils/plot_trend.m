function [] = plot_trend(P_wt, P_pv, P_eLoad, P_hLoad, day)
    if nargin < 5
        day = " ";
    end
    figure;
    set(gcf, 'Units', "centimeters", 'Position', [5 5 32 22]);  % [左边距， 底边距， 宽度，高度]
    t = tiledlayout(1, 1, 'TileSpacing', "compact", 'Padding', "compact");
    ax1 = nexttile;
    plot(ax1, P_wt, 'LineStyle', "-", 'LineWidth', 1);
    hold on;
    plot(ax1, P_pv, 'LineStyle', "-", 'LineWidth', 1);
    hold on;
    plot(ax1, P_eLoad, 'LineStyle', "-", 'LineWidth', 1);
    hold on;
    plot(ax1, P_hLoad, 'LineStyle', "-", 'LineWidth', 1);
    legend(ax1, {"风机出力", "光伏出力", "电负荷", "热负荷"}, 'FontName', 'SimSun', 'FontSize', 12, 'FontWeight','bold');
    xlabel(t, "时间", 'FontName', 'SimSun', 'FontSize', 14, 'FontWeight','bold');
    ylabel(t, "功率/kW", 'FontName', 'SimSun', 'FontSize', 14, 'FontWeight','bold');
    title(day);
end