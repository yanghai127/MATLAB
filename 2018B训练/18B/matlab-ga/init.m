% 初始化种群
% population_size: 种群大小
% chromosome_size: 染色体长度

function init(population_size, chromosome_size)
global population;
for i=1:population_size
    for j=1:chromosome_size
        % 给population的i行j列赋值
        population(i,j) = round(rand);  % rand产生(0,1)之间的随机数，round()是四舍五入函数
    end
end

