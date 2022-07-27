clear
clc

load('正常_R065_电流.mat')
R1=rotate_feas;
load('正常_R667_电流.mat')
R2=rotate_feas;
load('不确定_R397_电流.mat')
R3=rotate_feas;
load('轻微_R048_电流.mat')
R4=rotate_feas;
load('早期_R521_电流.mat')
R5=rotate_feas;
load('故障_R072_电流.mat')
R6=rotate_feas;
load('故障_R085_电流.mat')
R7=rotate_feas;
load('故障_R368_电流.mat')
R8=rotate_feas;
load('故障_R396_电流.mat')
R9=rotate_feas;
load('故障_R419_电流.mat')
R10=rotate_feas;
load('故障_R420_电流.mat')
R11=rotate_feas;


%% 

% period_num=[];
% orient_num=[];
% time_len=[];
% machine={'R048','R065','R072','R085','R368','R396','R397','R419','R420','R521','R665'};
% for i=1:11 
%     a=machine(i);
%     t=eval(a);
%     [m,n,p]=size(t);
%     period_num=[period_num,m];
%     orient_num=[orient_num,n];
%     time_len=[time_len,p];
% end

% origin_matrix=R667;
% tag='统计特征热力图_正常_R667_电流';
% [period_len, orient_len, time_len] = size(origin_matrix);
% 
% new_matrix=zeros(6,216);
% for i=1:period_len
%     a(:,:)=origin_matrix(i,:,:);
%     new_matrix=new_matrix+a;
%     new_matrix= new_matrix/period_len;
% end
%% 

%同一机器人不同关节
% figure(1)
% h=heatmap(new_matrix);
% h.XDisplayLabels={'1' '' '' '' '' '' '' '' '' '10' '' '' '' '' '' '' '' '' '' '20' '' '' '' '' '' '' '' '' '' '30' '' '' '' '' '' '' '' '' '' '40' '' '' '' '' '' '' '' '' '' '50' '' '' '' '' '' '' '' '' '' '60' '' '' '' '' '' '' '' '' '' '70' '' '' '' '' '' '' '' '' '' '80' '' '' '' '' '' '' '' '' '' '90' '' '' '' '' '' '' '' '' '' '100' '' '' '' '' '' '' '' '' '' '110' '' '' '' '' '' '' '' '' '' '120' '' '' '' '' '' '' '' '' '' '130' '' '' '' '' '' '' '' '' '' '140' '' '' '' '' '' '' '' '' '' '150' '' '' '' '' '' '' '' '' '' '160' '' '' '' '' '' '' '' '' '' '170' '' '' '' '' '' '' '' '' '' '180' '' '' '' '' '' '' '' '' '' '190' '' '' '' '' '' '' '' '' '' '200' '' '' '' '' '' '' '' '' '' '210' '' '' '' '' '' ''};
% h.YDisplayLabels={'关节一' '关节二' '关节三' '关节四' '关节五' '关节六'};
% %title(tag, 'Interpreter', 'none')
% saveas(gcf,[tag '.jpg'])
% savefig([tag '.fig'])
%% 
% a1='R048';
% a2='R065';
% a3='R072';
% a4='R085';
% a5='R368';
% a6='R396';
% a7='R397';
% a8='R419';
% a9='R420';
% a10='R521';
% a11='R667';

%% 
%不同机器人同一关节

tag1='new_R';
period_num=[];
orient_num=[];
time_num=[];

for i=1:11
    str1='R';
    str2=num2str(i);
    str3=[str1,str2];
    temp=eval(str3);
    origin_matrix=temp;
    [period_len, orient_len, time_len] = size(temp);
    period_num=[period_num,period_len];
    orient_num=[orient_num,orient_len];
    time_num=[time_num,time_len];
    new_matrix=zeros(6,216);
    for j=1:period_len
        a(:,:)=origin_matrix(j,:,:);
        new_matrix=new_matrix+a;
        new_matrix= new_matrix/period_len;
        eval([tag1,num2str(i),'=','new_matrix',';']);
    end
end

movement_type={'加速','匀速','减速'};
feature_type={'峰值','标准差','峰值因子','偏度','脉冲因子','峰峰值','均方根','波形因数','能量'};

for m=1:6
    for i=1:216
        n=fix((i-1)/27)+1;
        k=rem(i,9);
        if k==0
            k=9;
        end
        q=rem(fix((i-1)/9)+1,3);
        if q==0
           q=3; 
        end
        y=[];
        for j=1:11
            str1='new_R';
            str2=num2str(j);
            str3=[str1,str2];
            temp=eval(str3);
            y=[y;temp(m,i)];
        end
        
        b=bar(y);
        grid on;
        set(gca,'XTickLabel',{'正常R065','正常R667','不确定R397','轻微R048','早期R521','故障R072','故障R085','故障R368','故障R396','故障R419','故障R420'})
        tag2=['各机器人关节', num2str(m), '子运动' ,num2str(n) ,cell2mat(movement_type(q)), cell2mat(feature_type(k))];
        xlabel(tag2);
        ylabel(feature_type(k));
        saveas(gcf,[tag2 '.jpg'])
        savefig([tag2 '.fig'])
    end
end
