% 计算种群个体适应度，对不同的优化目标，修改下面的函数
% population_size: 种群大小
% chromosome_size: 染色体长度

function fitness(population_size, chromosome_size)
global fitness_value;
global population;

upper_bound = 9;    % 自变量的区间上限
lower_bound = 0;    % 自变量的区间下限

% 所有种群个体适应度初始化为0
for i=1:population_size
    fitness_value(i) = 0.;    
end

% f(x) = -x-10*sin(5*x)-7*cos(4*x);
for i=1:population_size
    for j=1:chromosome_size
        if population(i,j) == 1
            fitness_value(i) = fitness_value(i)+2^(j-1);    % population[i]染色体串和实际的自变量xi二进制串顺序是相反的
        end        
    end
    fitness_value(i) = lower_bound + fitness_value(i)*(upper_bound-lower_bound)/(2^chromosome_size-1);  % 自变量xi二进制转十进制
    fitness_value(i) = fitness_value(i) + 10*sin(5*fitness_value(i)) + 7*cos(4*fitness_value(i));  % 计算自变量xi的适应度函数值
end

clear i;
clear j;
