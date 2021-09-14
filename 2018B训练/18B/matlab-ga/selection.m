% 轮盘赌选择操作
% population_size: 种群大小
% chromosome_size: 染色体长度
% elitism: 是否精英选择

function selection(population_size, chromosome_size, elitism)
global population;      % 前代种群
global population_new;  % 新一代种群
global fitness_sum;   % 种群积累适应度

for i=1:population_size
    r = rand * fitness_sum(population_size);  % 生成一个随机数，在[0,总适应度]之间
    first = 1;
    last = population_size;
    mid = round((last+first)/2);
    idx = -1;
    
    % 排中法选择个体
    while (first <= last) && (idx == -1) 
        if r > fitness_sum(mid)
            first = mid;
        elseif r < fitness_sum(mid)
            last = mid;     
        else
            idx = mid;
            break;
        end
        mid = round((last+first)/2);
        if (last - first) == 1
            idx = last;
            break;
        end
    end
   
   % 产生新一代个体
   for j=1:chromosome_size
        population_new(i,j) = population(idx,j);
   end
end

% 是否精英选择
if elitism
    p = population_size-1;
else
    p = population_size;
end

for i=1:p
   for j=1:chromosome_size
       % 如果精英选择，将population中前population_size-1个个体更新，最后一个最优个体保留
       population(i,j) = population_new(i,j);
   end
end

clear i;
clear j;
clear population_new;
clear first;
clear last;
clear idx;
clear mid;
 

