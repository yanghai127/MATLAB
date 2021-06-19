%% 求解第二关不挖矿时最佳策略的Matlab源代码
clear,clc;
p=zeros(64,64);
% 生成邻接矩阵
for i=1:64
    a= ceil(i/8);               % ceil向上取整
    b= mod(i,8);
    if b~=0
        p(i,i+1)=1;
    end
    if b~=1
        p(i,i-1)=1;
    end
    if mod(a,2)== 1
        if a-1>0
            if b==1
                p(i,i+8)= 1;
                p(i,i-8)= 1;
            else
                p(i,i+8)= 1;
                p(i,i-8)= 1;
                p(i,i+7)= 1;
                p(i,i-9)= 1;
            end
        else
            if b==1
                p(i,i+8)= 1;
            else
                p(i,i+7)= 1;
                p(i,i+8)= 1;
            end
        end
    else
        if a~=8
            if b==0
                p(i,i+8)=1;
                p(i,i-8)=1;
            else
                p(i,i+8)=1;
                p(i,i-8)=1;
                p(i,i-7)=1;
                p(i,i+9)=1;
            end
        else
            if b==0
                p(i,i-8)=1;
            else
                p(i,i-7)=1;
                p(i,i-8)=1;
            end
        end
    end
end

clear a b i;
inf=99999999;
n=size(p,1);

% 初始化路由矩阵
r=zeros(n,n);
for i=1:n
    for j=1:n
        r(i,j)=j;
    end
end

% 初始化距离矩阵
dis=p;
for i=1:n
    for j=1:n
        if dis(i,j)==0
            dis(i,j)=inf;
        end
    end
end

% floyd求最短路径
for k=1:n
    for i=1:n
        for j=1:n
            if dis(i,k)+dis(k,j)<dis(i,j)
                dis(i,j)=dis(i,k)+dis(k,j);
                r(i,j)=r(i,k);
            end
        end
    end
end

% 回推路径
arrow=zeros(1,n);
arrow(1)=1;
i=2;
pp=1;
while pp~=n
    pp=r(pp,n);
    arrow(i)=pp;
    i=i+1;
end

dis=dis.*(ones(n)-eye(n));

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
dest=64;            % 目的地编号

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
path="";
for i=1:n
    if arrow(i)~=0
        path=path+" "+arrow(i);
    end
end

left=10000-sumw*price_w-sumf*price_f;

disp("最短路径长度："+dis(1,n));
disp("最短路径："+path);
disp("剩余资金："+left);
disp("所消耗水："+sumw);
disp("所消耗食物："+sumf);




