clear
clc
                            %前几节将了时域特征提取，傅里叶变换，其作用将时域信号变换到频域下
                            %这节讲频域特征提取
load('不确定_R397_电流.mat')
old_matrix = rotate_feas;
test1(:,:)=old_matrix(:,1,:);
a=test1(1,:);
b=1:1:216;
figure(1);
plot(b,a)

n=[];
for i=1:216
   n=[n,fix((i-1)/9)+1];
end
