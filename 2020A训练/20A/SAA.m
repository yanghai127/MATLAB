function [Bestv, BestT1, BestT2, BestT3, BestT4, trace, T_m]=SAA()
tic %计时开始，模拟20000*100次历时 1384.379688 秒
% 模拟退火算法，本题是5个决策变量的非线性规划问题
% 设置5个变量的上下限（约束条件之一）
vmax=100;
vmin=65;
T1max=185;
T1min=165;
T2max=205;
T2min=185;
T3max=245;
T3min=225;
T4max=265;
T4min=245;
L=100;      % 内循环迭代次数，每个'温度'迭代L次
T_m=100;    % 初始'温度'，（这里的温度是模拟退火算法的温度，温度与错误解的接受程度成正比）
K=0.98;     % '温度'的下降系数
Yz=1e-6;    % 注意浮点数计算的误差，deta>Yz代表两次结果不相等
P=0;        % 记录这是第几次迭代
Pmax=20000; % 迭代次数
trace=zeros(1,Pmax);    % 这里存的是每次迭代的面积，初始化矩阵节约时间
f=1;
while(f==1) % 非线性规划，先定一个随机的、合理的初始值，模拟退火是基于蒙特卡洛的
    Prev=rand* (vmax-vmin) +vmin;
    PreT1=rand* (T1max-T1min) +T1min;
    PreT2=rand* (T2max-T2min) +T2min;
    PreT3=rand* (T3max-T3min) +T3min;
    PreT4=rand* (T4max-T4min) +T4min;
    temp=T(57.4, 43.7, Prev/60, PreT1, PreT2, PreT3, PreT4,0.00678);
    if (check(0.01, Prev/60, temp)==1)
        Prebestv=Prev;
        PrebestT1=PreT1;
        PrebestT2=PreT2;
        PrebestT3=PreT3;
        PrebestT4=PreT4;
        f=0;
    end
end

f=1;
while(f==1) % 设定初始的、合理的解
    Prev=rand* (vmax-vmin) +vmin;
    PreT1=rand* (T1max-T1min) +T1min;
    PreT2=rand* (T2max-T2min) +T2min;
    PreT3=rand* (T3max-T3min) +T3min;
    PreT4=rand* (T4max-T4min) +T4min;
    temp=T(57.4,43.7,Prev/60,PreT1,PreT2,PreT3,PreT4,0.00678);
    if (check(0.01,Prev/60,temp)==1)
        Bestv=Prev;
        BestT1=PreT1;
        BestT2=PreT2;
        BestT3=PreT3;
        BestT4=PreT4;
        f=0;
    end
end
% 开始正式计算
deta=abs(func3(Bestv,BestT1,BestT2,BestT3,BestT4)-func3(Prebestv,PrebestT1,PrebestT2,PrebestT3,PrebestT4));
% 如果最优解和次优解不相等 && '温度'没有小于0.001 && 迭代次数不超过设定值Pmax
while (deta>Yz) && (T_m>0.001) && (P<Pmax)  % 外循环，'温度'的迭代
    T_m=K*T_m;      % 更新'温度'，如果'温度'很低，算法几乎退化为爬山算法，内循环可以找到此时的最优解了（很大几率是全局最优解）
    % 开始当前'温度'的内循环，每个'温度'迭代L次
    for i=1:L
        p=0;
        while p==0  % 寻找新解,这里感觉没用到模拟退火的精髓，旧解对新解没有启示
            Nextv=rand* (vmax-vmin) +vmin;
            NextT1=rand* (T1max-T1min) +T1min;
            NextT2=rand* (T2max-T2min) +T2min;
            NextT3=rand* (T3max-T3min) +T3min;
            NextT4=rand* (T4max-T4min) +T4min;
            temp=T(57.4,43.7,Nextv/60,NextT1,NextT2,NextT3,NextT4,0.00678);
            m=check(0.01, Nextv/60, temp);  % 要满足制程条件和变量区间(约束条件)
            if (m==1 && Nextv >= vmin && Nextv <= vmax && NextT1 >= T1min && NextT1<=T1max...
                    && NextT2>=T2min && NextT2<=T2max && NextT3>=T3min && NextT3<=T3max &&NextT4>=T4min && NextT4<=T4max)
                p=1;
            end
        end
        % 如果新解面积小于内循环最优解面积则更新内循环最优解
        if (func3(Bestv,BestT1,BestT2,BestT3,BestT4) > func3(Nextv,NextT1,NextT2,NextT3,NextT4))
            Prebestv=Bestv;     % Prebest开头的变量储存此次内循环的次优解
            PrebestT1=BestT1;
            PrebestT2=BestT2;
            PrebestT3=BestT3;
            PrebestT4=BestT4;
            Bestv=Nextv;        % Best开头的变量储存此次内循环的最优解
            BestT1=NextT1;
            BestT2=NextT2;
            BestT3=NextT3;
            BestT4=NextT4;
        end
        % 更新Pre变量，Pre开头的变量代表内循环当前解，新解小于当前解一定更新当前解
        if (func3(Prev,PreT1,PreT2,PreT3,PreT4) > func3(Nextv,NextT1,NextT2,NextT3,NextT4))
            Prev=Nextv;
            PreT1=NextT1;
            PreT2=NextT2;
            PreT3=NextT3;
            PreT4=NextT4;
            P=P+1;      % 更新后记得P+1
        else
            % 模拟退火的核心，不对错误解一刀切，与爬山算法的核心区别
            % 更新对错误解的接受概率，错的越离谱（相比于当前解来说）、'温度'越低，更新当前解的概率越小
            change = -(func3(Prev,PreT1,PreT2,PreT3,PreT4) - func3(Nextv,NextT1,NextT2,NextT3,NextT4))/T_m;
            p1=exp(change);
            if (p1 > rand)
                Prev=Nextv;
                PreT1=NextT1;
                PreT2=NextT2;
                PreT3=NextT3;
                PreT4=NextT4;
                P=P+1;  % 更新后记得P+1
            end
        end
        % 储存本次内循环最优解
        trace(P)=func3(Bestv, BestT1, BestT2, BestT3, BestT4);
    end
    % 计算本次内循环最优解和次优解的距离
    deta=abs(func3(Bestv,BestT1,BestT2,BestT3,BestT4) - func3(Prebestv,PrebestT1,PrebestT2,PrebestT3,PrebestT4));
end
% 绘图
x=1:Pmax;
plot(x,trace);
hold on
grid on
xlabel('模拟次数')
ylabel('最小面积/°C*t')
% 输出第四问结果，求第三问时下面5行要注释掉
ylabel('衡量值')
disp('第四问最小面积：')
disp(func(Bestv, BestT1, BestT2, BestT3, BestT4))
disp('对称度：')
disp(func2(Bestv, BestT1, BestT2, BestT3, BestT4))
toc %计时结束
end

function result=func(v, T1, T2, T3, T4)
% 根据温度和速度计算面积，问题3的目标函数
Tt=T(57.4, 43.7,v/60, T1, T2, T3,T4,0.00678);
maxT=max(Tt);       % 记录峰值温度
len5=length(Tt);
cnt1=0;
cnt2=0;
sum=0;
for i=2:len5
    if(Tt(i-1)<=217 && Tt (i)>217)
        cnt1=i;     % 记录左边界
    end
    if(Tt(i)==maxT)
        cnt2=i;     % 记录中心边界
    end
end
% 积分计算面积
for i=cnt1:cnt2-1
    sum=sum+0.01*(Tt(i)-217);
end
result = sum;
end

function result=func2(v, T1, T2, T3, T4)
% 计算对称度指标
Tt=T(57.4,43.7,v/60,T1,T2,T3,T4,0.00678);
cnt1=0;
cnt2=0;
cnt3=0;
maxT=max(Tt);       % 记录峰值温度
len=length(Tt);
for i=2:len
    if(Tt(i-1)<=217 && Tt(i)>217)
        cnt1=i;     % 记录左边界
    end
    if(Tt(i-1)>217 && Tt(i)<=217)
        cnt3=i-1;   % 记录右边界
    end
    if (Tt(i)==maxT)
        cnt2=i;     % 记录对称中心
    end
end
n=floor(((cnt2-cnt1) + (cnt3-cnt2))/2); % n代表样本个数
% 计算均方差
sum=0;
for i=1:n
    sum=sum+(Tt(cnt2-i)-Tt(cnt2+i))^2; 
end
result=sum/n;
end

function result = func3(v, T1, T2, T3, T4)
% 各面积与对称度统一量纲并赋权，第四问目标函数
m1=func (v, T1, T2, T3, T4);    % 面积，由于是在第三问基础上写的，所以要考虑面积
m2=func2 (v, T1, T2, T3, T4);   % 对称度指标，本质是均方差，妙啊
result=0.1*m1+m2;   % 赋权，求综合指标
end

% 第四问的主函数仅需将第三问中SAA函数中的适应函数func改成func3即可
