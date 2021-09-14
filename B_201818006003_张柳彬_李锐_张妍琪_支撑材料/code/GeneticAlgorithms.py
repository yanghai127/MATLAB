'''
单亲遗传算法主程序
'''
import random


class SAPGA(object):    # 要使用python高级特性记得加object，python3默认加载object，tql
    def __init__(self, fitness, bounds, param=tuple(), popsize=50, elite=0.2, mutprob=0.2, maxiter=3, disp=False):
        self.fitness = fitness  # 适应度函数
        self.bounds = bounds    # 范围限制
        self.param = param      # 适应度函数的其他参数
        self.popsize = popsize  # 种群规模
        self.elite = elite      # 优势比例
        self.mutprob = mutprob  # 变异率
        self.maxiter = maxiter  # 最大迭代次数
        self.disp = disp        # 是否打印相关信息

    def __elite_select(self, pop, select_num):
        '''精英选择'''
        scores = sorted([(self.fitness(vec, *self.param), vec) for vec in pop])
        ranked = [vec for score, vec in scores]
        return ranked[:select_num]  # 返回数组前十个元素（适应度函数返回的是负值）

    def sapga(self):
        '''
        单亲遗传算法主程序，输入的 bounds 应该是一个取值的闭范围，且所有的 bounds 都应该相等
        '''

        topelite = int(self.elite * self.popsize)

        x_min = self.bounds[0][0]
        x_max = self.bounds[0][1]

        pop = []
        for i in range(self.popsize):   # 随机生成50个个体，matlab里洗50次牌
            pop.append(random.sample(
                range(x_min, x_max + 1), len(self.bounds)))

        for i in range(self.maxiter):
            pop = self.__elite_select(pop, topelite)  # 选出精英个体，10个
            if self.disp:
                print(
                    f"This is NO.{i+1} iteration, the optimal solution is {pop[0]}, f(x) = {self.fitness(pop[0], *self.param)}")

            # 变异 or 交叉，最后一代不交叉变异了
            while len(pop) < self.popsize and i != self.maxiter - 1:
                variant = random.randint(0, topelite - 1)   # 变异哪个位置
                if random.random() < self.mutprob:
                    pop.append(self.__single_parent_mutate(
                        pop[variant].copy()))  # 随机选择一个个体进行变异
                else:
                    pop.append(self.__single_parent_recombina(
                        pop[variant].copy()))  # 随机选择一个个体进行重组
        print(
            f"Optimal Solution:{pop[0]}, Fitness Value:{self.fitness(pop[0], *self.param)}")
        return pop[0]

    def __single_parent_mutate(self, vec):
        '''变异操作，随机修改为一个不重复的值，若为完全指派矩阵，则变异操作等同于进行重组操作'''
        if len(range(self.bounds[0][0], self.bounds[0][1] + 1)) == len(vec) or round(random.random()):
            if round(random.random()):  # 轮换算子
                i = random.randint(1, len(vec) - 1)
                vec = vec[i:] + vec[:i]
            else:   # 重排列算子
                vec = random.sample(vec, len(vec))
        else:
            i = random.randint(0, len(self.bounds) - 1)
            vec[i] = random.sample(
                set(range(self.bounds[0][1] + 1)) - set(vec), 1)
        return vec

    def __single_parent_recombina(self, vec):
        '''交叉操作，任取两个维度作交换，同时有 1/2 概率继续交换'''
        i = random.sample(range(len(vec)), 2)
        vec[i[0]], vec[i[1]] = vec[i[1]], vec[i[0]]
        if round(random.random()):
            vec = self.__single_parent_recombina(vec)
        return vec
