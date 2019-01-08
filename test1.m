%% 此程序检测相邻角度间的距离对实验结果的影响
num_sample = 100; % 样本总数
SNR = 20; % 信噪比
angle_option = [11.36,36.87,78.55,109.66,127.83];
space_range = 2:2:40;
num_experiment = 1000;
has_noise = 1; % 为1则添加噪声 否则不添加噪声
correlation_coefficient = 0.02; % 不同角度的相关系数
error = zeros(1,length(space_range));

for space = 1:length(space_range)
    for experim = 1:num_experiment
        % 确定入射角
        angle_info_input = zeros(1,2);
        angle_info_input(1) = angle_option(mod(experim,length(angle_option)) +1 );
        angle_info_input(2) = angle_info_input(1) + space_range(space);
        
        % 利用root_music 算法
        angle_info_output = simulation_environment(num_sample,SNR,angle_info_input,has_noise,correlation_coefficient);
        error(space) = error(space) + sum(abs(angle_info_input - sort(angle_info_output)));
    end
end

error = error / (num_experiment * 2);
% 将计算结果保存到文件
file_name = '.\data_experiment\test1.mat';
save(file_name,'error') ;

% 输出图表
plot(space_range,error,'b-s','DisplayName','root music','LineWidth',1);
legend();
xlabel('Angel Space(°)');
ylabel('error(°)');
