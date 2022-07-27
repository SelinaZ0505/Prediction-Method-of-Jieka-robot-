clear
clc
                            %前几节将了时域特征提取，傅里叶变换，其作用将时域信号变换到频域下
                            %这节讲频域特征提取
load('samples2.mat')        %所有样本，二维矩阵，时域样本
                            %每列表示：单个样本的采样长度，单个样本采集时长为2.5 s，采样频率为Fs =20 kHz
                            %所以单个样本的采样长度为2.5*20k =50000
                            %第一列为第1个样本-状态1，第二列为第2个样本-状态2

                            
features = table;           %特征表
sample_number = 2;          %sample_number为样本个数
sample_length = 1:1:50000;  %sample_length为单个样本的采样长度

Fs = 20000;                 %采样频率Fs=20 KHz
t = (1:1:50000)/Fs;         %采样时间t=2.5s
b = (1:24000);              %实际区间



P1_length = 12000;
frequency_samples= zeros(P1_length,sample_number);%把每个样本samples2都从时域通过傅里叶变换到频域
                                                  %frequency_samples为所有样本的频域数据幅值，同样为矩阵
                                                  %行数为P1_length，列大小即为样本个数


figure(1)
subplot(211)
plot(t(b),samples2(b,1))
xlabel('时间/s')
ylabel('时域幅值/A')
title('第1个样本-状态1')          %第1个样本-状态1的波形
subplot(212)
plot(t(b),samples2(b,2))
xlabel('时间/s')
ylabel('时域幅值/A')
title('第2个样本-状态2')          %第2个样本-状态2的波形


Fs = 20000;
x = samples2(b,1);
L = length(x);
y = fft(x);
f = (0:L-1)*Fs/L;
y = y/L;
figure(2)
subplot(411)
plot(t(b),samples2(b,1))
xlabel('时间/s')
ylabel('时域幅值/A')
title('第1个样本-状态1')


subplot(412)
plot(f,abs(y))

fshift = (-L/2:L/2-1)*Fs/L;
yshift = fftshift(y);
subplot(413)
plot(fshift,abs(yshift))

P2 = abs(fft(x)/L);
P1 = P2(1:L/2);
P1(2:end-1) = 2*P1(2:end-1);
fnew = (0:(L/2-1))*Fs/L;
subplot(414)
plot(fnew,P1)


figure(3)
plot(fnew,P1)
xlim([0 100])
ylabel('频域幅值','FontSize',25)
xlabel('频率/Hz','FontSize',25)
% title('第1个样本-状态1')



Fs = 20000;
x = samples2(b,2);
L = length(x);
y = fft(x);
f = (0:L-1)*Fs/L;
y = y/L;
figure(4)
subplot(411)
plot(t(b),samples2(b,2))
xlabel('时间/s')
ylabel('时域幅值/A')
title('第2个样本-状态2')


subplot(412)
plot(f,abs(y))

fshift = (-L/2:L/2-1)*Fs/L;
yshift = fftshift(y);
subplot(413)
plot(fshift,abs(yshift))

P2 = abs(fft(x)/L);
P1 = P2(1:L/2);
P1(2:end-1) = 2*P1(2:end-1);
fnew = (0:(L/2-1))*Fs/L;
subplot(414)
plot(fnew,P1)


figure(5)
plot(fnew,P1)
xlim([0 100])
ylabel('频域幅值')
xlabel('频率/Hz')
title('第2个样本-状态2')


for i=1:1:sample_number        %把时域每个样本都从时域通过傅里叶变换到频域
    Fs = 20000;
    x = samples2(b,i);
    L = length(x);
    y = fft(x);
    f = (0:L-1)*Fs/L;
    y = y/L;

    fshift = (-L/2:L/2-1)*Fs/L;
    yshift = fftshift(y);

    P2 = abs(fft(x)/L);
    P1 = P2(1:L/2);
    P1(2:end-1) = 2*P1(2:end-1);
    fnew = (0:(L/2-1))*Fs/L;
    
    frequency_samples(:,i)= P1; %P1为向量，其长度为P1_length
                                %frequency_samples为所有样本的频域数据幅值，同样为矩阵
                                %行数为P1_length，列大小即为样本个数
end


for i=1:1:sample_number
    
    v = frequency_samples(:,i);
    %频域相关特征
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


