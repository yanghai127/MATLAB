%% 灰色关联分析法
clear;clc
name = '1989年度西山矿务局5个生产矿井技术经济指标实现值.xlsx';
X = readmatrix(name,'Range','B2:F10');

%% 标准化
B = X;
% 正向化成本性指标
for x = [1 5 7 9]
    M = max(X(x,:))*2;
    B(x,:) = (M-X(x,:));
end
disp('标准化后的矩阵：');
disp(B);

%% 熵权法计算权重
P = B./repmat(sum(B,2),1,5);
disp('指标权重向量如下：');
weight = shangquan(P)

%% 构造母序列和子序列，X、Y分别代表子母序列
% 这里不妨用归一化后的序列计算
Y = max(B,[],2);
X = B;

%% 计算灰色加权关联度
absX0_Xi = abs(X - repmat(Y,1,size(X,2)))   % 计算|X0-Xi|矩阵
disp('两级最小差：');
a = min(min(absX0_Xi))  % 计算两级最小差a
disp('两级最大差：');
b = max(max(absX0_Xi))  % 计算两级最大差b
rho = 0.5;              % 分辨系数取0.5即可
disp('灰色关联系数');
gamma = (a+rho*b) ./ (absX0_Xi  + rho*b)    % 计算灰色关联系数
score = sum(gamma .* repmat(weight,1,5));
stand_S = score / sum(score);               % 归一化
writematrix(stand_S,name,'Range','B11');
disp('排序结果如下：');
[sorted_S,index] = sort(stand_S ,'descend') % 排序
huitu(1:5, stand_S);
