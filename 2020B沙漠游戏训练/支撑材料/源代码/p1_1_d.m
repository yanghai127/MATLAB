%% 求解第一关不挖矿时最佳策略的Matlab源代码
clear,clc;
p=xlsread('Result','Sheet2','B2:AB28');
for i=1:27
    for j=i:27
        p(j,i)=p(i,j);
    end
end
clear i j;
inf=99999999;
n=size(p,1);

% 初始化距离矩阵
dis=p;
for i=1:27
    for j=1:27
        if dis(i,j)==0
            dis(i,j)=inf;
        end
    end
end

% floyd
for k=1:n
    for i=1:n
        for j=1:n
            if dis(i,k)+dis(k,j)<dis(i,j)
                dis(i,j)=dis(i,k)+dis(k,j);
            end
        end
    end
end
dis=dis.*(ones(27)-eye(27));

% 天气情况，1为晴朗，2为高温，3为沙暴
weather=[2 2 1 3 1 2 3 1 2 2  3 2 1 2 2 2 3 3 2 2  1 1 2 1 3 2 1 1 2 2];

w_cost=[5 8 10];    % 三种情况下水的消耗量
f_cost=[7 6 10];    % 三种情况下食物的消耗量
weight_limit=1000;  % 背包最大载重
day_limit=30;       % 截止日期
price_w=5;          % 水的价格
price_f=10;         % 食物的价格
weight_w=3;         % 水的重量
weight_f=2;         % 食物的重量

sumw=0;             % 总共需要水的箱数
sumf=0;             % 总共需要食物的箱数
dest=27;            % 目的地编号

i=0;
day=0;
while day<dis(1,dest)
    i=i+1;
    if weather(i)~=3
        day=day+1;
        sumw=sumw+2*w_cost(weather(i));
        sumf=sumf+2*f_cost(weather(i));
    else
        sumw=sumw+w_cost(weather(i));
        sumf=sumf+f_cost(weather(i));
    end
end

left=10000-sumw*price_w-sumf*price_f;
disp("剩余资金："+left);
disp("所消耗水："+sumw);
disp("所消耗食物："+sumf);




