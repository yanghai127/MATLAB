%% 蒙特卡洛作业
tic
clear,clc;
% 估计自然底数
% randperm
n=100000;
m=0;
for i=1:n
    x=randperm(100);
    y=randperm(100);
    if sum(x==y)==0
        m=m+1;
    end
end
disp(['自然底数e约为：',num2str(n/m)])

% 神器升级
% randi
zmoney=0;
for i=1:n
    test=1;
    money=0;
    while test~=5
        money=money+10000;
        yyds=randi([0,100],1);
        if test==1
            if 66<=yyds && yyds<=85
                test=2;
            elseif 86<=yyds && yyds<=95
                test=3;
            elseif 96<=yyds && yyds<=100
                test=4;
            end
        elseif test==2
            if 1<=yyds && yyds<=25
                test=1;
            elseif 66<=yyds && yyds<=85
                test=3;
            elseif 86<=yyds && yyds<=95
                test=4;
            elseif 96<=yyds && yyds<=100
                test=5;
            end
        elseif test==3
            if 1<=yyds && yyds<=10
                test=1;
            elseif 11<=yyds && yyds<=30
                test=2;
            elseif 71<=yyds && yyds<=90
                test=4;
            elseif 91<=yyds && yyds<=100
                test=5;
            end
        elseif test==4
            if 1<=yyds && yyds<=10
                test=2;
            elseif 11<=yyds && yyds<=40
                test=3;
            elseif 81<=yyds && yyds<=100
                test=5;
            end
        end
    end
    zmoney=zmoney+money;
end
disp(['一把五级神器价值约为：',num2str(zmoney/n),'金币'])

% 非线性规划问题
% unifrnd
fmin=inf;
x1=unifrnd(0,16,n,1);
x2=unifrnd(0,8,n,1);
X=zeros(1,2);
for i=1:n
    x=[x1(i),x2(i)];
    test=2*x(1).^2+x(2).^2-x(1)*x(2)-8*x(1)-3*x(2);
    if test<fmin && 3*x(1)+x(2)>9 && x(1)+2*x(2)<16
        fmin=test;
    end
end
disp(['方程最小解约为：',num2str(fmin)])

% 选择最优方案
money=0;
x=randi([1000,2000],1,4);
T=100000;
t=min(x);
while t<T
    x=x-min(x);
    for i=1:4
        if x(i)==0
            money=money+10;
            x(i)=randi([1000,2000]);
        end
    end
    money=money+20;
    t=t+min(x);
end
disp(['每次更换一支约损失：',num2str(money),'元'])

money=0;
x=randi([1000,2000],1,4);
t=min(x);
while t<T
    x=randi([1000,2000],1,4);
    money=money+80;
    t=t+min(x);
end
disp(['每次更换全部约损失：',num2str(money),'元'])

toc