clear
clc
                            %前几节将了时域特征提取，傅里叶变换，其作用将时域信号变换到频域下
                            %这节讲频域特征提取

 %load('不确定_R397_电流.mat')
 load('故障_R072_电流.mat')
% load('故障_R085_电流.mat')
% load('故障_R368_电流.mat')
% load('故障_R396_电流.mat')
% load('故障_R419_电流.mat')
% load('故障_R420_电流.mat')
% load('轻微_R048_电流.mat')
% load('早期_R521_电流.mat')
% load('正常_R065_电流.mat')
% load('正常_R667_电流.mat')%所有样本，二维矩阵，时域样本
                            %每列表示：单个样本的采样长度，单个样本采集时长为2.5 s，采样频率为Fs =20 kHz
                            %所以单个样本的采样长度为2.5*20k =50000
                            %第一列为第1个样本-状态1，第二列为第2个样本-状态2
old_matrix = rotate_feas;        %选择需要进行分析的mat
tag = '正常_R667_电流';
Fs = 125;                 %采样频率Fs=20 KHz
type0='时域';
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
    figure(4*i-3);
    x = new_matrix(b,i);
    L = length(x);
    y = fft(x);
    f = (0:L-1)*Fs/L;
    y = y/L;
    plot(t(b),new_matrix(b,i))
    xlabel('时间/s')
    ylabel('时域幅值/A')
    title_str = [tag '_第' num2str(i) '个关节' ];
    title(title_str, 'Interpreter', 'none')
    saveas(gcf,[type0,title_str '.jpg'])
    savefig([type0,title_str '.fig'])
    
    figure(4*i-2);
    plot(f,abs(y))
    saveas(gcf,[type1,title_str '.jpg'])
    savefig([type1,title_str '.fig'])

    fshift = (-L/2:L/2-1)*Fs/L;
    yshift = fftshift(y);
    figure(4*i-1);
    plot(fshift,abs(yshift))
    saveas(gcf,[type2,title_str '.jpg'])
    savefig([type2,title_str '.fig'])
    
    P2 = abs(fft(x)/L);
    P1 = P2(1:L/2);
    P1(2:end-1) = 2*P1(2:end-1);
    fnew = (0:(L/2-1))*Fs/L;
    figure(4*i);
    plot(fnew,P1)
    saveas(gcf,[type3,title_str '.jpg'])
    savefig([type3,title_str '.fig'])
end
