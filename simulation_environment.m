function [angle_info_output] = simulation_environment(num_sample,SNR,angle_info_input,has_noise,correlation_coefficient)
%% 确定参数
Model_paras.frequency = 3 * 10^9; % 工作频率
Model_paras.num_sample = num_sample; 
Model_paras.antenna_space_ofwaveLen = 0.5; % 相邻天线之间的距离（表示为与波长的关系）
Model_paras.num_antenna = 7; % 天线的个数
Model_paras.speed_light = 3 * 10^8; % 光速
Model_paras.has_noise = has_noise; % 为1则添加噪声 否则不添加噪声
Model_paras.SNR = SNR; % 信噪比
Model_paras.angle_info_input = angle_info_input; % 模拟信号的信源对应的角度
Model_paras.correlation_coefficient = correlation_coefficient; % 不同信源产生的信号之间的相关度

%% 产生符合要求的CSI数据 之后利用L1-SVD算法解出相应的AOA

    % 生成每个AP对应的CSI矩阵和它所接收到的路径信息
    CSI = create_CSI_by_angle(Model_paras);

    % 使用MUSIC（未经spatial-smoothing）
    angle_info_output = root_music(CSI,Model_paras,length(Model_paras.angle_info_input));
%     angle_info_output = MUSIC_Origin(CSI,Model_paras,length(Model_paras.angle_info_input));
end

    