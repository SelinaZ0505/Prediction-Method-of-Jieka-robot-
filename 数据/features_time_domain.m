clear
clc

load('samples1.mat')        %所有样本，二维矩阵
                            %每列表示：单个样本的采样长度，单个样本采集时长为2.5 s，采样频率为Fs =20 kHz
                            %所以单个样本的采样长度为2.5*20k =50000
features = table;           %特征表
sample_number = 4;          %sample_number为样本个数
sample_length = 1:1:50000;  %sample_length为单个样本的采样长度

Fs = 20000;                 %采样频率Fs=20 KHz
t = (1:1:50000)/Fs;         %采样时间t=2.5s
figure(1)
subplot(411)
plot(t,samples1(:,1))
xlabel('时间/s')
ylabel('时域幅值/A')
title('第1个样本')          %第1个样本的波形
subplot(412)
plot(t,samples1(:,2))
xlabel('时间/s')
ylabel('时域幅值/A')
title('第2个样本')          %第2个样本的波形
subplot(413)
plot(t,samples1(:,3))
xlabel('时间/s')
ylabel('时域幅值/A')
title('第3个样本')          %第3个样本的波形
subplot(414)
plot(t,samples1(:,4))
xlabel('时间/s')
ylabel('时域幅值/A')
title('第4个样本')          %第4个样本的波形

for i=1:1:sample_number
    
    v = samples1(sample_length,i);
    %时域特征
    features.Mean(i) = mean(v);                         %平均值
    features.Std(i) = std(v);                           %标准差
    features.Skewness(i) = skewness(v);                 %偏度
    features.Kurtosis(i) = kurtosis(v);                 %峭度
    features.max(i) = max(v);                           %最大值
    features.min(i) = min(v);                           %最小值
    features.Peak2Peak(i) = peak2peak(v);               %峰峰值
    features.RMS(i) = rms(v);                           %均方根
    features.CrestFactor(i) = max(v)/rms(v);            %振幅因数
    features.ShapeFactor(i) = rms(v)/mean(abs(v));      %波形因数
    features.ImpulseFactor(i) = max(v)/mean(abs(v));    %冲击因数
    features.MarginFactor(i) = max(v)/mean(abs(v))^2;   %裕度因数
    features.Energy(i) = sum(v.^2);                     %能量

end
