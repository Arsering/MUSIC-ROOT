function CSI = create_CSI_by_angle(Model_paras)
%% 通过steering_matrix生成模拟数据

% 相邻天线之间距离 单位：m
antenna_space = (Model_paras.speed_light/Model_paras.frequency) * Model_paras.antenna_space_ofwaveLen;

% 生成complex_gain
Model_paras.complex_gain = create_complexGain(Model_paras);

% 生成模拟CSI
CSI = complex(zeros(Model_paras.num_antenna,Model_paras.num_sample));

for T = 1:Model_paras.num_sample
    for A = 1:length(Model_paras.angle_info_input)
    CSI(:,T) = CSI(:,T)...
        + exp(-1i * 2*pi * (0:Model_paras.num_antenna-1) * antenna_space * cos(deg2rad(Model_paras.angle_info_input(A))) * Model_paras.frequency / Model_paras.speed_light).'...
        * Model_paras.complex_gain(A,T);
    end
end

% 添加噪声
if Model_paras.has_noise == 1
    CSI = awgn(CSI,Model_paras.SNR);
end

end

%% 根据给定的相关系数随机生成complex_gain
function complex_gain = create_complexGain(Model_paras)

% 生成初始的协方差矩阵
signalCovMat = 1*eye(length(Model_paras.angle_info_input));

% 为了简便 我将任意两个不同信源之间的相关系数都置同一个值
for t = 1:length(Model_paras.angle_info_input)
    for k = 1:length(Model_paras.angle_info_input)
        if t == k
            continue;
        else
            signalCovMat(t,k) = Model_paras.correlation_coefficient;
        end
    end
end
rand_phase = mvnrnd(zeros(length(Model_paras.angle_info_input), 1), signalCovMat, Model_paras.num_sample).';

% 为了简便才如此 可以修改（无论修改与否，都不影响我们的实验效果）
complex_gain = exp(1i * rand_phase);
end