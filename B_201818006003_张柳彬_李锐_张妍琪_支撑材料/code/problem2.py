'''
问题二求解算法程序

调试寻优步骤
1.在带有交互式和功能的python编辑器(如Spyder)中执行此函数文件
2.运行下方单亲遗传算法(论文表4-3)，其中 param 为传入的固定参数(工程固定信息)，第一个维度4表示<=4为第一道工序
第 1 组：分别使用1-2-1调度模式和2-1-2调度模式
SAPGA(fitness1, [[1, 8] for i in range(8)], param=[4, 20, 33, 46, 400, 378, 25, 28, 31]).sapga()
SAPGA(fitness2, [[1, 8] for i in range(8)], param=[4, 20, 33, 46, 400, 378, 25, 28, 31]).sapga()
SAPGA(fitness1, [[1, 8] for i in range(8)], param=[5, 20, 33, 46, 400, 378, 25, 28, 31]).sapga()
SAPGA(fitness2, [[1, 8] for i in range(8)], param=[5, 20, 33, 46, 400, 378, 25, 28, 31]).sapga()

# 最优结果：N1 = 4 时，[1,2,1,2,1,2,1,2] 为最优方案，零件个数为253

第 2 组：分别使用1-2-1调度模式和2-1-2调度模式
SAPGA(fitness1, [[1, 8] for i in range(8)], param=[2, 23, 41, 59, 280, 500, 30, 30, 35]).sapga()
SAPGA(fitness2, [[1, 8] for i in range(8)], param=[2, 23, 41, 59, 280, 500, 30, 30, 35]).sapga()
SAPGA(fitness1, [[1, 8] for i in range(8)], param=[3, 23, 41, 59, 280, 500, 30, 30, 35]).sapga()
SAPGA(fitness2, [[1, 8] for i in range(8)], param=[3, 23, 41, 59, 280, 500, 30, 30, 35]).sapga()

# 最优结果：N1 = 3时，[2,2,1,2,1,2,1,2] 为最优方案，零件个数为198

第 3 组：分别使用1-2-1调度模式和2-1-2调度模式
SAPGA(fitness1, [[1, 8] for i in range(8)], param=[5, 18, 32, 46, 455, 182, 25, 27, 32]).sapga()
SAPGA(fitness2, [[1, 8] for i in range(8)], param=[5, 18, 32, 46, 455, 182, 25, 27, 32]).sapga()
SAPGA(fitness1, [[1, 8] for i in range(8)], param=[6, 18, 32, 46, 455, 182, 25, 27, 32]).sapga()
SAPGA(fitness2, [[1, 8] for i in range(8)], param=[6, 18, 32, 46, 455, 182, 25, 27, 32]).sapga()

# 最优结果：N1 = 5时，[1,1,2,1,2,1,1,2]为最优方案，零件个数为239

'''
# 人一能之己十之，人十能之己百之
import os   # 引入这个模块可以对文件或文件夹进行操作
import pandas as pd     # 常用数据统计模块
from GeneticAlgorithms import SAPGA     # 引入自定义的遗传算法函数


def I(num):
    # 车床所在位置的映射函数
    if num % 2 == 0:
        # 若为偶数
        return int(num/2 - 1)
    else:
        return int((num - 1) / 2)


def w(w_it, t_pass):
    # 计算 i 机床 t 时刻经过 t_pass 时间后的任务剩余执行时间
    return w_it - t_pass if w_it - t_pass > 0 else 0


def updata_w(w_its, t_pass):    # 各CNC等待时间以元组形式储存在列表中返回
    return dict([(wit_key, w(wit_value, t_pass)) for wit_key, wit_value in w_its.items()])


def sort_serve_time(dist):
    # 传入字典，按照value从小到大排序并返回
    return sorted(dist.items(), key=lambda x: x[1])


def main1(M1, M2, M3, f1, f2, Tw, T_奇, T_偶, serve_list, **kwargs):  # main函数返回成品的个数
    # 1-2-1 调度模式
    # 初始化参数
    global table    # 声明全局变量，局部修改全局修改
    M1, M2, M3, f1, f2, Tw = M1, M2, M3, f1, f2, Tw
    T1 = T3 = T5 = T7 = T_奇
    T2 = T4 = T6 = T8 = T_偶

    t = 0
    I_t = 0  # RGV 所在的位置
    M0 = 0
    t_max = 8 * 60 * 60
    try:
        if kwargs.get('table'):
            pass
        else:
            table = pd.DataFrame(
                columns=['工序1的 CNC 编号', '上料开始时间(1)', '下料开始时间(1)', '工序2的 CNC 编号', '上料开始时间(2)', '下料开始时间(2)'])
    except Exception:
        table = kwargs.get('table')

    # 将两类机床分别创建一个字典，格式： CNC编号-剩余时间。
    w_its1 = {}
    w_its2 = {}
    for serve in enumerate(serve_list):
        if serve[1] == 1:
            w_its1[serve[0] + 1] = 0
        else:
            w_its2[serve[0] + 1] = 0
    if len(w_its1) == 0 or len(w_its2) == 0:
        print(f'运行完毕，总加工零件数为：0')
        return 0

    n = 0
    # 先开始依次对所有空闲的1号机床进行上料
    for index in w_its1.keys():
        n += 1
        alpha1 = eval(f'M{abs(I(index) - I_t)}')
        table.at[n, '工序1的 CNC 编号'] = int(index)
        table.at[n, '上料开始时间(1)'] = t + alpha1 + w(w_its1[index], alpha1)
        beta1 = eval(f'T{index}') + w(w_its1[index], alpha1)
        I_t = I(index)  # 新的RGV位置
        t += alpha1 + beta1  # 新的系统时间
        w_its1[index] = f1 + alpha1 + beta1  # 更新时间表
        w_its1 = updata_w(w_its1, alpha1 + beta1)

    # 对加工时间遍历
    while t <= t_max:
        w_its1_sorted = sort_serve_time(w_its1)    # 排序后会变成列表，键值对变为元组
        Rtk = []    # 候选路径
        for CNC_i in w_its2.keys():
            # 取出前k个时间对应的机床编号
            Rtk.append((w_its1_sorted[0][0], CNC_i, w_its1_sorted[1][0]))

        varphi = []  # 目标函数值

        # 动态规划寻找最优路径  这个循环用到了回溯的思想
        for ri in Rtk:
            t_virtual = t   # 虚拟时间
            I_t_virtual = I_t   # 虚拟RGP地点
            j = 0
            w_its1_virtual = w_its1.copy()
            w_its2_virtual = w_its2.copy()
            while j <= 2:
                alphaj = eval(f'M{abs(I(ri[j]) - I_t_virtual)}')    # 移动时间
                betaj = eval(f'T{ri[j]}') + Tw * (j % 2) + \
                    w(eval(f'w_its{int(j % 2) + 1}_virtual[ri[j]]'), alphaj)
                t_virtual += alphaj + betaj  # 新的系统时间
                I_t_virtual = I(ri[j])    # 新的RGV位置
                # 更新时间表
                exec(
                    f"w_its{int(j % 2)+1}_virtual[ri[j]] = eval(f'f{int(j % 2) + 1}') + alphaj + betaj - Tw* (j%2)")
                w_its1_virtual = updata_w(w_its1_virtual, alphaj + betaj)
                w_its2_virtual = updata_w(w_its2_virtual, alphaj + betaj)
                j += 1

            varphi.append(t_virtual)

        move_index = []  # 储存最小路径代价
        for j in range(len(varphi)):
            if varphi[j] == min(varphi):
                move_index.append(Rtk[j])

        move_point = []  # 最优机床方案
        for move_index_road in move_index:
            move_point.extend(move_index_road[:2])
            if move_index_road[0] % 2 == 1:
                # 如果是奇数号则直接输出结果
                move_point = move_index_road[:2]    # 取前两个数就行了，预测三步走两步
                break

        n += 1
        # 确定最终结果，更新参数
        alpha1 = eval(f'M{abs(I(move_point[0]) - I_t)}')    # 移动到最优地点所需的时间
        table.at[n, '工序1的 CNC 编号'] = int(move_point[0])
        table.at[n, '上料开始时间(1)'] = t + alpha1 + \
            w(w_its1[move_point[0]], alpha1)

        beta1 = eval(f'T{move_point[0]}') + w(w_its1[move_point[0]], alpha1)
        I_t = I(move_point[0])
        t += alpha1 + beta1
        w_its1[move_point[0]] = f1 + alpha1 + beta1
        w_its1 = updata_w(w_its1, alpha1 + beta1)
        w_its2 = updata_w(w_its2, alpha1 + beta1)

        # 确定最终结果，更新参数
        alpha2 = eval(f'M{abs(I(move_point[1]) - I_t)}')    # 移动到最优地点所需的时间
        last_n = table.loc[table['工序1的 CNC 编号'] ==
                           move_point[0]].index[-2]  # 当前工序2加工的产品时哪个CNC编号
        table.at[last_n, '工序2的 CNC 编号'] = int(move_point[1])
        table.at[last_n, '上料开始时间(2)'] = t + alpha2 + \
            w(w_its2[move_point[1]], alpha2)

        beta2 = eval(f'T{move_point[1]}') + Tw + \
            w(w_its2[move_point[1]], alpha2)
        I_t = I(move_point[1])
        t += alpha2 + beta2
        w_its2[move_point[1]] = f2 + alpha2 + beta2 - Tw
        w_its1 = updata_w(w_its1, alpha2 + beta2)
        w_its2 = updata_w(w_its2, alpha2 + beta2)

    # 填充表格
    for i in range(1, len(table)+1):
        for j in range(i + 1, len(table) + 1):
            if table.at[i, '工序1的 CNC 编号'] == table.at[j, '工序1的 CNC 编号']:
                table.at[i, '下料开始时间(1)'] = table.at[j, '上料开始时间(1)']
                break

        for j in range(i + 1, len(table) + 1):
            if table.at[i, '工序2的 CNC 编号'] == table.at[j, '工序2的 CNC 编号']:
                table.at[i, '下料开始时间(2)'] = table.at[j, '上料开始时间(2)']
                break

    # 收尾处理，最后一块不一定处理的完
    if t + Tw + f2 > t_max:
        n_adj = len(table) - len(table[table.iloc[:, -1].isna()]) - 1
        print(f'运行完毕，总加工零件数为：{n_adj}')
    else:
        n_adj = len(table) - len(table[table.iloc[:, -1].isna()])
        print(f'运行完毕，总加工零件数为：{n_adj}')
    return n_adj


def main2(M1, M2, M3, f1, f2, Tw, T_奇, T_偶, serve_list, **kwargs):
    # 1-2-1 调度模式
    # 初始化参数
    M1, M2, M3, f1, f2, Tw = M1, M2, M3, f1, f2, Tw
    T1 = T3 = T5 = T7 = T_奇
    T2 = T4 = T6 = T8 = T_偶

    t = 0
    I_t = 0  # RGV 所在的位置
    M0 = 0
    t_max = 8 * 60 * 60

    try:
        if kwargs.get('table'):
            pass
        else:
            table = pd.DataFrame(
                columns=['工序1的 CNC 编号', '上料开始时间(1)', '下料开始时间(1)', '工序2的 CNC 编号', '上料开始时间(2)', '下料开始时间(2)'])
    except Exception:
        table = kwargs.get('table')

    # 将两类机床分别创建一个字典，格式： CNC编号-剩余时间。
    w_its1 = {}
    w_its2 = {}
    for serve in enumerate(serve_list):
        if serve[1] == 1:
            w_its1[serve[0] + 1] = 0
        else:
            w_its2[serve[0] + 1] = 0

    if len(w_its1) == 0 or len(w_its2) == 0:
        print(f'运行完毕，总加工零件数为：0')
        return 0
    n = 0
    # 先开始依次对所有空闲的1号机床进行上料

    for index in w_its1.keys():
        n += 1
        alpha1 = eval(f'M{abs(I(index) - I_t)}')
        table.at[n, '工序1的 CNC 编号'] = int(index)
        table.at[n, '上料开始时间(1)'] = t + alpha1 + w(w_its1[index], alpha1)
        beta1 = eval(f'T{index}') + Tw + w(w_its1[index], alpha1)
        I_t = I(index)  # 新的RGV位置
        t += alpha1 + beta1  # 新的系统时间
        w_its1[index] = f1 + alpha1 + beta1 - Tw  # 更新时间表
        w_its1 = updata_w(w_its1, alpha1 + beta1)

    # 接着，走向最先结束的一个1号机床，开始进行2-1-2寻优
    n += 1
    index = list(w_its1.keys())[0]
    alpha1 = eval(f'M{abs(I(index) - I_t)}')
    table.at[n, '工序1的 CNC 编号'] = int(index)
    table.at[n, '上料开始时间(1)'] = t + alpha1 + w(w_its1[index], alpha1)
    beta1 = eval(f'T{index}') + Tw + w(w_its1[index], alpha1)
    I_t = I(index)  # 新的RGV位置
    t += alpha1 + beta1  # 新的系统时间
    w_its1[index] = f1 + alpha1 + beta1 - Tw  # 更新时间表
    w_its1 = updata_w(w_its1, alpha1 + beta1)
    last_n = index

    # 对加工时间遍历
    while t <= t_max:
        w_its2_sorted = sort_serve_time(w_its2)    # 对时间进行排序

        Rtk = []    # 候选路径
        for CNC_i in w_its1.keys():
            # 取出前k个时间对应的机床编号
            Rtk.append((w_its2_sorted[0][0], CNC_i, w_its2_sorted[1][0]))

        varphi = []  # 目标函数值

        # 动态规划寻找最优路径
        for ri in Rtk:
            t_virtual = t   # 虚拟时间
            I_t_virtual = I_t   # 虚拟RGP地点
            j = 0
            w_its1_virtual = w_its1.copy()
            w_its2_virtual = w_its2.copy()

            while j <= 2:
                alphaj = eval(f'M{abs(I(ri[j]) - I_t_virtual)}')
                betaj = eval(
                    f'T{ri[j]}') + Tw + w(eval(f'w_its{int(not(j % 2)) + 1}_virtual[ri[j]]'), alphaj)
                t_virtual += alphaj + betaj  # 新的系统时间
                I_t_virtual = I(ri[j])    # 新的RGV位置
                # 更新时间表
                exec(
                    f"w_its{int(not(j%2))+1}_virtual[ri[j]] = eval(f'f{int(not(j%2)) + 1}') + alphaj + betaj - Tw")
                w_its1_virtual = updata_w(w_its1_virtual, alphaj + betaj)
                w_its2_virtual = updata_w(w_its2_virtual, alphaj + betaj)
                j += 1

            varphi.append(t_virtual)

        move_index = []  # 储存最小路径代价
        for j in range(len(varphi)):
            if varphi[j] == min(varphi):
                move_index.append(Rtk[j])

        move_point = []  # 最优机床方案
        for move_index_road in move_index:
            move_point.extend(move_index_road[:2])
            if move_index_road[0] % 2 == 1:
                # 如果是奇数号则直接输出结果
                move_point = move_index_road[:2]
                break

        n += 1
        # 确定最终结果，更新参数
        alpha1 = eval(f'M{abs(I(move_point[0]) - I_t)}')    # 移动到最优地点所需的时间
        last_n = table.loc[table['工序1的 CNC 编号'] ==
                           last_n].index[-1]  # 当前工序2加工的产品时哪个CNC编号
        table.at[last_n, '工序2的 CNC 编号'] = int(move_point[0])
        table.at[last_n, '上料开始时间(2)'] = t + alpha1 + \
            w(w_its2[move_point[0]], alpha1)

        beta1 = eval(f'T{move_point[0]}') + Tw + \
            w(w_its2[move_point[0]], alpha1)
        I_t = I(move_point[0])
        t += alpha1 + beta1
        w_its2[move_point[0]] = f2 + alpha1 + beta1 - Tw
        w_its1 = updata_w(w_its1, alpha1 + beta1)
        w_its2 = updata_w(w_its2, alpha1 + beta1)

        # 确定最终结果，更新参数
        alpha2 = eval(f'M{abs(I(move_point[1]) - I_t)}')    # 移动到最优地点所需的时间
        table.at[n, '工序1的 CNC 编号'] = int(move_point[1])
        table.at[n, '上料开始时间(1)'] = t + alpha2 + \
            w(w_its1[move_point[1]], alpha2)

        beta2 = eval(f'T{move_point[1]}') + Tw + \
            w(w_its1[move_point[1]], alpha2)
        I_t = I(move_point[1])
        t += alpha2 + beta2
        w_its1[move_point[1]] = f1 + alpha2 + beta2 - Tw
        w_its1 = updata_w(w_its1, alpha2 + beta2)
        w_its2 = updata_w(w_its2, alpha2 + beta2)

        last_n = move_point[1]

    # 填充表格
    for i in range(1, len(table)+1):
        for j in range(i + 1, len(table) + 1):
            if table.at[i, '工序1的 CNC 编号'] == table.at[j, '工序1的 CNC 编号']:
                table.at[i, '下料开始时间(1)'] = table.at[j, '上料开始时间(1)']
                break

        for j in range(i + 1, len(table) + 1):
            if table.at[i, '工序2的 CNC 编号'] == table.at[j, '工序2的 CNC 编号']:
                table.at[i, '下料开始时间(2)'] = table.at[j, '上料开始时间(2)']
                break

    if table.dropna().iloc[-1, -1] + Tw + f2 > t_max:
        n_adj = len(table) - len(table[table.iloc[:, -1].isna()]) - 1
        print(f'运行完毕，总加工零件数为：{n_adj}')
    else:
        n_adj = len(table) - len(table[table.iloc[:, -1].isna()])
        print(f'运行完毕，总加工零件数为：{n_adj}')
    return n_adj

# 单亲遗传算法适应度函数


def fitness1(x, N1, M1, M2, M3, f1, f2, Tw, T_奇, T_偶):    # good
    # 适应度函数1，解析 x 编码序列 为车床安排方案，运行main1
    serve_list = [1 if cnc_mode <= N1 else 2 for cnc_mode in x]     # 解码
    return - main1(M1, M2, M3, f1, f2, Tw, T_奇, T_偶, serve_list)


def fitness2(x, N1, M1, M2, M3, f1, f2, Tw, T_奇, T_偶):
    # 适应度函数2，解析 x 编码序列 为车床安排方案，运行main2
    serve_list = [1 if cnc_mode <= N1 else 2 for cnc_mode in x]     # x基于洗牌算法
    return - main2(M1, M2, M3, f1, f2, Tw, T_奇, T_偶, serve_list)


if __name__ == '__main__':
    # 调试过程见上文，此处给出输出解的代码
    data1 = pd.DataFrame(
        columns=['工序1的 CNC 编号', '上料开始时间(1)', '下料开始时间(1)', '工序2的 CNC 编号', '上料开始时间(2)', '下料开始时间(2)'])  # 252 个零件
    main1(20, 33, 46, 400, 378, 25, 28, 31, [
          1, 2, 2, 1, 2, 1, 2, 1], table=data1)

    data2 = pd.DataFrame(
        columns=['工序1的 CNC 编号', '上料开始时间(1)', '下料开始时间(1)', '工序2的 CNC 编号', '上料开始时间(2)', '下料开始时间(2)'])  # 197 个零件
    main1(23, 41, 59, 280, 500, 30, 30, 35, [
          2, 2, 2, 1, 1, 2, 1, 2], table=data2)

    data3 = pd.DataFrame(
        columns=['工序1的 CNC 编号', '上料开始时间(1)', '下料开始时间(1)', '工序2的 CNC 编号', '上料开始时间(2)', '下料开始时间(2)'])  # 239 个零件
    main1(18, 32, 46, 455, 182, 25, 27, 32, [
          1, 1, 2, 1, 2, 1, 1, 2], table=data3)

    excel_writer = pd.ExcelWriter(f'{os.getcwd()}/../table/Case_2_result.xlsx')
    data1.to_excel(excel_writer, '第1组')
    data2.to_excel(excel_writer, '第2组')
    data3.to_excel(excel_writer, '第3组')
    excel_writer.save()
