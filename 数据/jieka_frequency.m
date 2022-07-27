clear
clc
                            %前几节将了时域特征提取，傅里叶变换，其作用将时域信号变换到频域下
                            %这节讲频域特征提取
load('不确定_R397_电流.mat')
%load('故障_R072_电流.mat')
% load('故障_R085_电流.mat')
% load('故障_R368_电流.mat')
%load('故障_R396_电流.mat')
 %load('故障_R419_电流.mat')
% load('故障_R420_电流.mat')
% load('轻微_R048_电流.mat')
%load('早期_R521_电流.mat')
 load('正常_R065_电流.mat')
% load('正常_R667_电流.mat')%       %所有样本，二维矩阵，时域样本
                            %每列表示：单个样本的采样长度，单个样本采集时长为2.5 s，采样频率为Fs =20 kHz
                            %所以单个样本的采样长度为2.5*20k =50000
                            %第一列为第1个样本-状态1，第二列为第2个样本-状态2
old_matrix = rotate_feas;        %选择需要进行分析的mat
tag = '正常_R065_电流';
Fs = 125;                 %采样频率Fs=20 KHz
type1='满频';
type2='零频中心';
type3='半频';

% 对于三维矩阵 speeds_circle 和 motion 的操作
[period_len, orient_len, time_len] = size(old_matrix);
new_matrix = [];                            
for i=1:1:period_len        %把22个周期的数据拼接起来
    new_matrix = [new_matrix;squeeze(old_matrix(i,:,:)).']; 
end

% 对于 vib_circle 的操作
% [period_len, time_len] = size(old_matrix);
% orient_len = 1;
% new_matrix = [];                            
% for i=1:1:period_len        %把22个周期的数据拼接起来
%     new_matrix = [new_matrix;old_matrix(i,:).']; 
% end

features1 = table;
features2 = table;           %特征表
sample_number = orient_len;          %sample_number为样本个数
sample_length = 1:1:(period_len*time_len);  %sample_length为单个样本的采样长度


t = (1:1:(period_len*time_len))/Fs;         %采样时间t=2.5s 
b = (1:(period_len*time_len));              %实际区间



P1_length = fix((period_len*time_len)/2);
frequency_samples= zeros(P1_length,sample_number);%把每个样本samples2都从时域通过傅里叶变换到频域
                                                  %frequency_samples为所有样本的频域数据幅值，同样为矩阵
                                                  %行数为P1_length，列大小即为样本个数

for i=1:1:orient_len                              %画图
    figure(i);
    x = new_matrix(b,i);
    L = length(x);
    y = fft(x);
    f = (0:L-1)*Fs/L;
    y = y/L;
    subplot(411)
    plot(t(b),new_matrix(b,i))
    xlabel('时间/s')
    ylabel('时域幅值/A')
    title_str = [tag '_第' num2str(i) '个关节' ];
    title(title_str, 'Interpreter', 'none')


    subplot(412)
    plot(f,abs(y))
    title(title_str, 'Interpreter', 'none')
    
    fshift = (-L/2:L/2-1)*Fs/L;
    yshift = fftshift(y);
    subplot(413)
    plot(fshift,abs(yshift))
    title(title_str, 'Interpreter', 'none')
    
    P2 = abs(fft(x)/L);
    P1 = P2(1:L/2);
    P1(2:end-1) = 2*P1(2:end-1);
    fnew = (0:(L/2-1))*Fs/L;
    subplot(414)
    plot(fnew,P1)
    title(title_str, 'Interpreter', 'none')
    saveas(gcf,[title_str '.jpg'])
    savefig([title_str '.fig'])
end


for i=1:1:sample_number        %把时域每个样本都从时域通过傅里叶变换到频域
    x = new_matrix(b,i);
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
    
    v = new_matrix(:,i);
    %时域特征
    features1.Mean(i) = mean(v);                         %平均值
    features1.Std(i) = std(v);                           %标准差
    features1.Skewness(i) = skewness(v);                 %偏度
    features1.Kurtosis(i) = kurtosis(v);                 %峭度
    features1.max(i) = max(v);                           %最大值
    features1.min(i) = min(v);                           %最小值
    features1.Peak2Peak(i) = peak2peak(v);               %峰峰值
    features1.RMS(i) = rms(v);                           %均方根
    features1.CrestFactor(i) = max(v)/rms(v);            %振幅因数
    features1.ShapeFactor(i) = rms(v)/mean(abs(v));      %波形因数
    features1.ImpulseFactor(i) = max(v)/mean(abs(v));    %冲击因数
    features1.MarginFactor(i) = max(v)/mean(abs(v))^2;   %裕度因数
    features1.Energy(i) = sum(v.^2);                     %能量

end

for i=1:1:sample_number
    
    v = frequency_samples(:,i);
    %频域相关特征
    features2.Mean(i) = mean(v);                         %平均值
    features2.Std(i) = std(v);                           %标准差
    features2.Skewness(i) = skewness(v);                 %偏度
    features2.Kurtosis(i) = kurtosis(v);                 %峭度
    features2.max(i) = max(v);                           %最大值
    features2.min(i) = min(v);                           %最小值
    features2.Peak2Peak(i) = peak2peak(v);               %峰峰值
    features2.RMS(i) = rms(v);                           %均方根
    features2.CrestFactor(i) = max(v)/rms(v);            %振幅因数
    features2.ShapeFactor(i) = rms(v)/mean(abs(v));      %波形因数
    features2.ImpulseFactor(i) = max(v)/mean(abs(v));    %冲击因数
    features2.MarginFactor(i) = max(v)/mean(abs(v))^2;   %裕度因数
    features2.Energy(i) = sum(v.^2);                     %能量

end

writetable(features1, [tag '_time_feature.xls']);
writetable(features2, [tag '_frequency_feature.xls']);
% C = table2cell(T);   % 先获取表头以下的数据
% cell_properties = [T.Properties.VariableNames; C];  % 表头合并，构成新的cell文件
% xlswrite('cell_properties.xls', cell_properties); 
% current=rotate_feas;
% 
% features = table;           %特征表
% sample_number = 4;          %sample_number为样本个数
% sample_length = 1:1:216;  %sample_length为单个样本的采样长度
% 
% Fs = 125;                 %采样频率Fs=20 KHz
% t = (1:1:216)/Fs;         %采样时间t=2.5s
% b = (1:1:216);              %实际区间
% 
% joint1(:,:)=current(:,1,:);
% joint1=joint1';
% joint2(:,:)=current(:,2,:);
% joint2=joint2';
% joint3(:,:)=current(:,3,:);
% joint3=joint3';
% joint4(:,:)=current(:,4,:);
% joint4=joint4';
% joint5(:,:)=current(:,5,:);
% joint5=joint5';
% joint6(:,:)=current(:,6,:);
% joint6=joint6';
% 
% P1_length = 108;   %P1_length是采样长度除以2？
% frequency_samples= zeros(P1_length,sample_number);%把每个样本samples2都从时域通过傅里叶变换到频域
%                                                   %frequency_samples为所有样本的频域数据幅值，同样为矩阵
%                                                   %行数为P1_length，列大小即为样本个数
% 
% %joint1_plot                                                
% figure(1)
% subplot(411)
% plot(t(b),joint1(b,1))
% xlabel('时间/s')
% ylabel('时域幅值/A')
% title('第1个样本-状态1')          %第1个样本-状态1的波形
% subplot(412)
% plot(t(b),joint1(b,2))
% xlabel('时间/s')
% ylabel('时域幅值/A')
% title('第2个样本-状态2')%第2个样本-状态2的波形
% subplot(413)
% plot(t(b),joint1(b,3))
% xlabel('时间/s')
% ylabel('时域幅值/A')
% title('第3个样本-状态3')
% subplot(414)
% plot(t(b),joint1(b,4))
% xlabel('时间/s')
% ylabel('时域幅值/A')
% title('第4个样本-状态4')
% 
% %joint1的第一个样本
% Fs = 125;
% x = joint1(b,1);
% L = length(x);
% y = fft(x);
% f = (0:L-1)*Fs/L;
% y = y/L;
% figure(2)
% subplot(411)
% plot(t(b),joint1(b,1))
% xlabel('时间/s')
% ylabel('时域幅值/A')
% title('第1个样本-状态1')
% 
% 
% subplot(412)   %电流信号的绝对值
% plot(f,abs(y))
% 
% fshift = (-L/2:L/2-1)*Fs/L;
% yshift = fftshift(y);
% subplot(413)   %频域
% plot(fshift,abs(yshift))
% 
% P2 = abs(fft(x)/L);
% P1 = P2(1:L/2);
% P1(2:end-1) = 2*P1(2:end-1);
% fnew = (0:(L/2-1))*Fs/L;
% subplot(414)
% plot(fnew,P1)
% 
% 
% figure(3)
% plot(fnew,P1)
% xlim([0 80])
% ylabel('频域幅值','FontSize',25)
% xlabel('频率/Hz','FontSize',25)
% % title('第1个样本-状态1')
% 
% 
% %joint1的第二个样本
% Fs = 125;
% x = joint1(b,2);
% L = length(x);
% y = fft(x);
% f = (0:L-1)*Fs/L;
% y = y/L;
% figure(4)
% subplot(411)
% plot(t(b),samples2(b,2))
% xlabel('时间/s')
% ylabel('时域幅值/A')
% title('第2个样本-状态2')
% 
% 
% subplot(412)
% plot(f,abs(y))
% 
% fshift = (-L/2:L/2-1)*Fs/L;
% yshift = fftshift(y);
% subplot(413)
% plot(fshift,abs(yshift))
% 
% P2 = abs(fft(x)/L);
% P1 = P2(1:L/2);
% P1(2:end-1) = 2*P1(2:end-1);
% fnew = (0:(L/2-1))*Fs/L;
% subplot(414)
% plot(fnew,P1)
% 
% 
% figure(5)
% plot(fnew,P1)
% xlim([0 100])
% ylabel('频域幅值')
% xlabel('频率/Hz')
% title('第2个样本-状态2')
% 
% 
% for i=1:1:sample_number        %把时域每个样本都从时域通过傅里叶变换到频域
%     Fs = 20000;
%     x = samples2(b,i);
%     L = length(x);
%     y = fft(x);
%     f = (0:L-1)*Fs/L;
%     y = y/L;
% 
%     fshift = (-L/2:L/2-1)*Fs/L;
%     yshift = fftshift(y);
% 
%     P2 = abs(fft(x)/L);
%     P1 = P2(1:L/2);
%     P1(2:end-1) = 2*P1(2:end-1);
%     fnew = (0:(L/2-1))*Fs/L;
%     
%     frequency_samples(:,i)= P1; %P1为向量，其长度为P1_length
%                                 %frequency_samples为所有样本的频域数据幅值，同样为矩阵
%                                 %行数为P1_length，列大小即为样本个数
% end
% 
% 
% for i=1:1:sample_number
%     
%     v = frequency_samples(:,i);
%     %频域相关特征
%     features.Mean(i) = mean(v);                         %平均值
%     features.Std(i) = std(v);                           %标准差
%     features.Skewness(i) = skewness(v);                 %偏度
%     features.Kurtosis(i) = kurtosis(v);                 %峭度
%     features.max(i) = max(v);                           %最大值
%     features.min(i) = min(v);                           %最小值
%     features.Peak2Peak(i) = peak2peak(v);               %峰峰值
%     features.RMS(i) = rms(v);                           %均方根
%     features.CrestFactor(i) = max(v)/rms(v);            %振幅因数
%     features.ShapeFactor(i) = rms(v)/mean(abs(v));      %波形因数
%     features.ImpulseFactor(i) = max(v)/mean(abs(v));    %冲击因数
%     features.MarginFactor(i) = max(v)/mean(abs(v))^2;   %裕度因数
%     features.Energy(i) = sum(v.^2);                     %能量
% 
% end
