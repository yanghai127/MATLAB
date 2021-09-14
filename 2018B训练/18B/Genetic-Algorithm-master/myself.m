%% 遗传参数设置
% 遗传算法求函数y=x*sin(3*pi*x)在（-1，2）区间内的最大值
clear,clc
NUMPOP=100;     % 初始种群大小
irange_l=-1;	% 问题解区间
irange_r=2;
LENGTH=22;      % 二进制编码长度
ITERATION = 10000;  % 迭代次数
CROSSOVERRATE=0.7;  % 杂交率
SELECTRATE = 0.5;   % 选择率
VARIATIONRATE = 0.001;  % 变异率

% 初始化种群
pop=m_InitPop(NUMPOP,irange_l,irange_r);
pop_save=pop;
% 绘制初始种群分布
x=linspace(-1,2,1000);
y=m_Fx(x);
plot(x,y);
hold on
for i=1:size(pop,2)
    plot(pop(i),m_Fx(pop(i)),'ro');
end
grid on
hold off
title('初始种群');

% 开始迭代
for time=1:ITERATION
    fitness=m_Fitness(pop);	% 计算初始种群的适应度
    pop=m_Select(fitness,pop,SELECTRATE);	% 选择
    binpop=m_Coding(pop,LENGTH,irange_l);   % 编码
    kidsPop = crossover(binpop,NUMPOP,CROSSOVERRATE); % 交叉
    kidsPop = Variation(kidsPop,VARIATIONRATE); % 变异
    kidsPop=m_Incoding(kidsPop,irange_l);   % 解码
    pop=[pop, kidsPop]; % 更新种群
end
figure
plot(x,y);
hold on
for i=1:size(pop,2)
    plot(pop(i),m_Fx(pop(i)),'ro');
end
grid on
hold off
title('终止种群');

disp(['最优解：' num2str(max(m_Fx(pop)))]);
disp(['最大适应度：' num2str(max(m_Fitness(pop)))]);

