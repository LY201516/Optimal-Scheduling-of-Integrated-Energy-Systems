function [forecast_data, actual_mape] = forecast_with_error(actual_data, target_mape, error_std_factor)
% 生成带有预测误差的数据
% 输入:
%   actual_data - 真实数据 (24×1 或 n×1)
%   target_mape - 目标MAPE (如 0.20 表示20%)
%   error_std_factor - 误差标准差系数 (默认1.2)
% 输出:
%   forecast_data - 预测数据
%   actual_mape - 实际计算得到的MAPE

    if nargin < 3
        error_std_factor = 1.2;
    end
    
    n = length(actual_data);
    % 固定随机数生成种子，以保证每次的结果是可复现的
    rng(3);  % 任意非负整数即可
    % 生成相对误差
    relative_error_std = target_mape * error_std_factor;
    relative_errors = normrnd(0, relative_error_std, n, 1);
    
    % 应用误差
    forecast_data = zeros(n, 1);
    for i = 1:n
        if actual_data(i) > 0.01
            forecast_data(i) = actual_data(i) * (1 + relative_errors(i));
            forecast_data(i) = max(0, forecast_data(i)); % 非负约束
        else
            forecast_data(i) = 0;
        end
    end
    
    % 计算实际MAPE
    valid_indices = actual_data > 0.01;
    if sum(valid_indices) > 0
        errors = abs(forecast_data(valid_indices) - actual_data(valid_indices));
        actual_mape = mean(errors ./ actual_data(valid_indices));
        disp(actual_mape);
    else
        actual_mape = 0;
    end
end