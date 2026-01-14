function [] = plot_actANDforecast(actual_data, forecast_data, title_str)
    figure;
    x = 1:length(actual_data);
    plot(x, actual_data, "b-", 'LineWidth', 1.5, 'DisplayName', "真实值");
    hold on;
    plot(x, forecast_data, "r--", 'LineWidth', 1.5, 'DisplayName', "预测值");
    title(title_str, 'FontName', "SimSun", 'FontSize', 15, 'FontWeight', "bold");
    legend;
    grid on;

end
