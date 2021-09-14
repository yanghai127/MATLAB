%% 
clear;clc
name='person相关系数.xls';
X1=xlsread(name,'Sheet1','A2:L121');
X2=xlsread(name,'Sheet2','A2:L121');

% 样本量120，大样本，进行JB检验
c = size(X1,2);     % 数据的列数
H = zeros(1,c);     % 初始化节省时间和消耗
P = zeros(1,c);
for i = 1:c
    [h,p] = jbtest(X1(:,i),0.05);   % h为1代表拒绝原假设
    H(i)=h;
    P(i)=p;         % P代表p值
end
disp(H)
disp(P)

% 计算相关度和显著性水平
[R1,P1]=corr(X1,'type','Spearman');
R1(:,2:2:end)=[];
R1(1:2:end,:)=[];
P1(:,2:2:end)=[];
P1(1:2:end,:)=[];
[R2,P2]=corr(X2,'type','Spearman');
R2(:,2:2:end)=[];
R2(1:2:end,:)=[];
P2(:,2:2:end)=[];
P2(1:2:end,:)=[];
% xlswrite(name,R1,'Sheet3','B2');
% xlswrite(name,R2,'Sheet4','B2');

% 显著性标记

P1 < 0.01                   % 标记3颗星的位置
(P1 < 0.05) .* (P1 > 0.01)  % 标记2颗星的位置
(P1 < 0.1) .* (P1 > 0.05)	% 标记1颗星的位置

P2 < 0.01                   % 标记3颗星的位置
(P2 < 0.05) .* (P2 > 0.01)  % 标记2颗星的位置
(P2 < 0.1) .* (P2 > 0.05)   % 标记1颗星的位置