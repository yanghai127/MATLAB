% 设置遗传算法的参数，测试效果
% 设定求解精度为小数点后4位

function main()
elitism = true;             % 选择精英操作
population_size = 100;      % 种群大小
chromosome_size = 17;       % 染色体长度
generation_size = 200;      % 最大迭代次数
cross_rate = 0.6;           % 交叉概率
mutate_rate = 0.01;         % 变异概率

[best_individual,best_fitness,iterations,x] = genetic_algorithm(population_size, chromosome_size, generation_size, cross_rate, mutate_rate,elitism);

disp 最优个体:
best_individual
disp 最优适应度:
best_fitness
disp 最优个体对应自变量值:
x
disp 达到最优结果的迭代次数:
iterations

end