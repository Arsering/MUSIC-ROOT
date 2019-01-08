num_sample = 10; % 样本总数
SNR = 20; % 信噪比
angle_info_input =[40.2547,65.23,83.55]; % 组成模拟信号的信源对应的入射角
has_noise = 1; % 为1则添加噪声 否则不添加噪声
correlation_coefficient = 0.9999; % 不同角度的相关系数
format longE
angle_info_output = simulation_environment(num_sample,SNR,angle_info_input,has_noise,correlation_coefficient);