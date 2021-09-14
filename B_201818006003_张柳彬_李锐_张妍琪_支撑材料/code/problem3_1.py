'''问题 3-1 仿真求解算法的主程序'''
import os
import pandas as pd
import itertools
import random

def I(num):
    # 车床所在位置的映射函数
    if num % 2 == 0:
        # 若为偶数
        return int(num/2 - 1)
    else:
        return int((num - 1) /2)

def w(w_it,t_pass):
    # 计算 i 机床 t 时刻经过 t_pass 时间后的任务剩余执行时间
    return w_it - t_pass if w_it - t_pass >0 else 0

def updata_w(w_its, t_pass):
    return [w(wit,t_pass) for wit in w_its]

def main(M1,M2,M3,f0,Tw,T_奇,T_偶,table,error_table,k = 3):
    # 初始化参数
    M1, M2, M3, f0, Tw = M1, M2, M3, f0, Tw
    T1 = T3 = T5 = T7 = T_奇
    T2 = T4 = T6 = T8 = T_偶

    t = 0
    k = k  # 预判 k 个机床
    I_t = 0  # RGV 所在的位置
    M0 = 0
    t_max = 8 * 60 * 60
    w_its = [0] * 8

    n = 0
    while t <= t_max:
        n += 1
        w_its_sorted = sorted(w_its)    # 对时间进行排序

        Stk = []    # 候选集
        for CNC_i in range(1,9):
            if w_its[CNC_i - 1] in w_its_sorted[:k] and len(Stk) < k:
                Stk.append(CNC_i)   # 取出前k个时间对应的机床编号

        Rtk = list(itertools.permutations(Stk, k))  # 候选路径
        varphi = [] # 目标函数值

        # 动态规划寻找最优路径
        for ri in Rtk:
            t_virtual = t   # 虚拟时间
            I_t_virtual = I_t   # 虚拟RGP地点
            j = 0
            w_its_virtual = w_its.copy()
            while j <= k - 1:
                ifTw = False
                if ri[j] in table['加工 CNC 编号']:
                    ifTw = True
                alphaj = eval(f'M{abs(I(ri[j]) - I_t_virtual)}')
                betaj = eval(f'T{ri[j]}') + Tw*ifTw + w(w_its_virtual[ri[j] - 1], alphaj)
                t_virtual += alphaj + betaj  # 新的系统时间
                I_t_virtual = I(ri[j])    # 新的RGV位置
                w_its_virtual[ri[j] - 1] = f0 + alphaj + betaj - Tw*ifTw  # 更新时间表
                w_its_virtual = updata_w(w_its_virtual,alphaj + betaj)
                j+=1
            varphi.append(t_virtual)

        move_index = [] # 储存最小路径代价
        for j in range(len(varphi)):
            if varphi[j] == min(varphi):
                move_index.append(Rtk[j])

        move_point = [] # 最优机床方案
        for move_index_road in move_index:
            move_point.append(move_index_road[0])
            if move_index_road[0] % 2 == 1:
                # 如果是奇数号则直接输出结果
                move_point = [move_index_road[0]]
                break

        # 确定最终结果，更新参数
        alpha1 = eval(f'M{abs(I(move_point[0]) - I_t)}')    # 移动到最优地点所需的时间
        ifTw = False
        if int(move_point[0]) in table['加工 CNC 编号']:
            ifTw = True

        table.at[n,'加工 CNC 编号'] = int(move_point[0])
        table.at[n,'上料开始时间'] = t + alpha1 + w(w_its[move_point[0] - 1], alpha1)
        print(f'CNC 机床编号: {move_point[0]}, 上料开始时间:{t + alpha1 + w(w_its[move_point[0] - 1], alpha1)}')
        beta1 = eval(f'T{move_point[0]}') + Tw*ifTw + w(w_its[move_point[0] - 1], alpha1)
        I_t = I(move_point[0])
        t +=  alpha1 + beta1
        w_its[move_point[0] - 1] = f0 + alpha1 + beta1 - Tw*ifTw
        w_its = updata_w(w_its, alpha1 + beta1)

        # 此处进行均匀分布仿真判断
        if random.random() <= 0.01:
            # 0.01的 概率发生故障
            # t_error 表示在工作周期中机床损坏的时间点，发生故障时，从作业开始时间进行判断。
            t_error = random.sample(range(f0), 1)[0]
            T_r = random.randint(10 * 60,20 * 60)
            w_its[move_point[0] - 1] = T_r - t_error

            # 记录故障信息
            error_table.at[n,'故障CNC编号'] = move_point[0]
            error_table.at[n,'故障开始时间'] = table.at[n,'上料开始时间'] + t_error
            error_table.at[n,'故障结束时间'] = table.at[n,'上料开始时间'] + t_error + T_r

    # 填充表格
    for i in range(1,len(table)+1):
        for j in range(i + 1, len(table) + 1):
            if table.at[i,'加工 CNC 编号'] == table.at[j,'加工 CNC 编号']:
                table.at[i,'下料开始时间'] = table.at[j,'上料开始时间']
                break

    if table.dropna().iloc[-1,-1] + Tw + f0 > t_max:
        n_adj = len(table) - len(table[table.iloc[:,-1].isna()]) - 1 - len(error_table)
        print(f'运行完毕，总加工零件数为：{n_adj}')
    else:
        n_adj = len(table) - len(table[table.iloc[:,-1].isna()]) - len(error_table)
        print(f'运行完毕，总加工零件数为：{n_adj}')

if __name__ == '__main__':

    data1 = pd.DataFrame(columns=['加工 CNC 编号', '上料开始时间', '下料开始时间'])
    error1 = pd.DataFrame(columns=['故障CNC编号', '故障开始时间','故障结束时间'])
    data2 = pd.DataFrame(columns=['加工 CNC 编号', '上料开始时间', '下料开始时间'])
    error2 = pd.DataFrame(columns=['故障CNC编号', '故障开始时间', '故障结束时间'])
    data3 = pd.DataFrame(columns=['加工 CNC 编号', '上料开始时间', '下料开始时间'])
    error3 = pd.DataFrame(columns=['故障CNC编号', '故障开始时间', '故障结束时间'])

    main(20,33,46,560,25,28,31,data1,error1)
    main(23,41,59,580,30,30,35,data2,error2)
    main(18,32,46,545,25,27,32,data3,error3)

