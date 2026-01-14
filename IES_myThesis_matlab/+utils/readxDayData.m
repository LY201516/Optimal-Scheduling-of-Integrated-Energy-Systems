function [data1h, data30min, data15min, data5min] = readxDayData(day_str, P_data_1h, P_data_30min, P_data_15min, P_data_5min)
% 从四个不同时间分辨率的数据变量中提取指定日期的数据
% 输入参数:
%   day_str - 日期字符串，格式为'月-日'，例如'1-23'表示1月23日
%   P_data_1h, P_data_30min, P_data_15min, P_data_5min - 四个时间分辨率的数据向量
% 输出参数:
%   data1h, data30min, data15min, data5min - 对应日期的提取数据

    % 解析输入的日期字符串
    date_parts = strsplit(day_str, '-');
    if length(date_parts) ~= 2
        error('日期格式错误，请使用 "月-日" 格式，例如 "1-23"');
    end
    
    month = str2double(date_parts{1});
    day = str2double(date_parts{2});
    
    % 验证日期有效性
    if month < 1 || month > 12 || day < 1 || day > 31
        error('无效的日期');
    end
    
    % 各时间分辨率下一天的数据点数
    points_per_day_1h = 24;
    points_per_day_30min = 48;
    points_per_day_15min = 96;
    points_per_day_5min = 288;
    
    % 计算一年中第几天（平年）
    days_in_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    day_of_year = sum(days_in_month(1:month-1)) + day;
    
    % 计算起始索引
    start_idx_1h = (day_of_year - 1) * points_per_day_1h + 1;
    start_idx_30min = (day_of_year - 1) * points_per_day_30min + 1;
    start_idx_15min = (day_of_year - 1) * points_per_day_15min + 1;
    start_idx_5min = (day_of_year - 1) * points_per_day_5min + 1;
    
    % 计算结束索引
    end_idx_1h = start_idx_1h + points_per_day_1h - 1;
    end_idx_30min = start_idx_30min + points_per_day_30min - 1;
    end_idx_15min = start_idx_15min + points_per_day_15min - 1;
    end_idx_5min = start_idx_5min + points_per_day_5min - 1;
    
    % 检查索引是否超出范围
    if end_idx_1h > length(P_data_1h)
        error('1小时数据索引超出范围');
    end
    if end_idx_30min > length(P_data_30min)
        error('30分钟数据索引超出范围');
    end
    if end_idx_15min > length(P_data_15min)
        error('15分钟数据索引超出范围');
    end
    if end_idx_5min > length(P_data_5min)
        error('5分钟数据索引超出范围');
    end
    
    % 提取数据
    data1h = P_data_1h(start_idx_1h:end_idx_1h);
    data30min = P_data_30min(start_idx_30min:end_idx_30min);
    data15min = P_data_15min(start_idx_15min:end_idx_15min);
    data5min = P_data_5min(start_idx_5min:end_idx_5min);
    
    % 显示提取信息
    fprintf('成功提取 %d月%d日的数据:\n', month, day);
    fprintf('  1小时分辨率: %d个数据点\n', length(data1h));
    fprintf('  30分钟分辨率: %d个数据点\n', length(data30min));
    fprintf('  15分钟分辨率: %d个数据点\n', length(data15min));
    fprintf('  5分钟分辨率: %d个数据点\n', length(data5min));
end