'''模型3-2调度的实现'''
import random
import os
import pandas as pd


def I(num):
    # 车床所在位置的映射函数
    if num % 2 == 0:
        # 若为偶数
        return int(num / 2 - 1)
    else:
        return int((num - 1) / 2)


def w(w_it, t_pass):
    # 计算 i 机床 t 时刻经过 t_pass 时间后的任务剩余执行时间
    return w_it - t_pass if w_it - t_pass > 0 else 0


def updata_w(w_its, t_pass):
    return dict([(wit_key, w(wit_value, t_pass)) for wit_key, wit_value in w_its.items()])


def sort_serve_time(dist):
    # 传入字典，按照键大小顺序重排序
    return sorted(dist.items(), key=lambda x: x[1])


def main(M1, M2, M3, f1, f2, Tw, T_奇, T_偶, serve_list, table, error_table):
    # 1-2-1 调度模式
    # 初始化参数
    M1, M2, M3, f1, f2, Tw = M1, M2, M3, f1, f2, Tw
    T1 = T3 = T5 = T7 = T_奇
    T2 = T4 = T6 = T8 = T_偶

    t = 0
    I_t = 0  # RGV 所在的位置
    M0 = 0
    t_max = 8 * 60 * 60

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
        if n == 70:
            ind = sort_serve_time(w_its1)[0][0]
            w_its1[ind] = random.randint(60 * 10, 60 * 20)
            error_table.loc[70, '故障CNC编号'] = sort_serve_time(w_its1)[0][0]
            error_table.loc[70, '故障开始时间'] = t
            error_table.loc[70, '故障结束时间'] = t + w_its1[ind]
        if n == 140:
            ind = sort_serve_time(w_its1)[0][0]
            w_its2[ind] = random.randint(60 * 10, 60 * 20)
            error_table.loc[140, '故障CNC编号'] = sort_serve_time(w_its2)[0][0]
            error_table.loc[140, '故障开始时间'] = t
            error_table.loc[140, '故障结束时间'] = t + w_its2[ind]

        w_its1_sorted = sort_serve_time(w_its1)  # 对时间进行排序

        Rtk = []  # 候选路径
        for CNC_i in w_its2.keys():
            # 取出前k个时间对应的机床编号
            Rtk.append((w_its1_sorted[0][0], CNC_i, w_its1_sorted[1][0]))

        varphi = []  # 目标函数值

        # 动态规划寻找最优路径
        for ri in Rtk:
            t_virtual = t  # 虚拟时间
            I_t_virtual = I_t  # 虚拟RGP地点
            j = 0
            w_its1_virtual = w_its1.copy()
            w_its2_virtual = w_its2.copy()

            while j <= 2:
                alphaj = eval(f'M{abs(I(ri[j]) - I_t_virtual)}')
                betaj = eval(f'T{ri[j]}') + Tw * (j % 2) + \
                    w(eval(f'w_its{int(j % 2) + 1}_virtual[ri[j]]'), alphaj)
                t_virtual += alphaj + betaj  # 新的系统时间
                I_t_virtual = I(ri[j])  # 新的RGV位置
                exec(
                    f"w_its{int(j % 2)+1}_virtual[ri[j]] = eval(f'f{int(j % 2) + 1}') + alphaj + betaj - Tw* (j%2)")
                # 更新时间表
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
        alpha1 = eval(f'M{abs(I(move_point[0]) - I_t)}')  # 移动到最优地点所需的时间
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
        alpha2 = eval(f'M{abs(I(move_point[1]) - I_t)}')  # 移动到最优地点所需的时间
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
    for i in range(1, len(table) + 1):
        for j in range(i + 1, len(table) + 1):
            if table.at[i, '工序1的 CNC 编号'] == table.at[j, '工序1的 CNC 编号']:
                table.at[i, '下料开始时间(1)'] = table.at[j, '上料开始时间(1)']
                break

        for j in range(i + 1, len(table) + 1):
            if table.at[i, '工序2的 CNC 编号'] == table.at[j, '工序2的 CNC 编号']:
                table.at[i, '下料开始时间(2)'] = table.at[j, '上料开始时间(2)']
                break

    if t + Tw + f2 > t_max:
        n_adj = len(table) - len(table[table.iloc[:, -1].isna()]) - 1
        print(f'运行完毕，总加工零件数为：{n_adj}')
    else:
        n_adj = len(table) - len(table[table.iloc[:, -1].isna()])
        print(f'运行完毕，总加工零件数为：{n_adj}')
    return n_adj


if __name__ == '__main__':
    data1 = pd.DataFrame()
    error1 = pd.DataFrame(columns=['故障CNC编号', '故障开始时间', '故障结束时间'])
    data2 = pd.DataFrame()
    error2 = pd.DataFrame(columns=['故障CNC编号', '故障开始时间', '故障结束时间'])
    data3 = pd.DataFrame()
    error3 = pd.DataFrame(columns=['故障CNC编号', '故障开始时间', '故障结束时间'])

    main(20, 33, 46, 400, 378, 25, 28, 31, [
         1, 2, 2, 1, 2, 1, 2, 1], data1, error1)
    main(23, 41, 59, 280, 500, 30, 30, 35, [
         2, 2, 2, 1, 1, 2, 1, 2], data2, error2)
    main(18, 32, 46, 455, 182, 25, 27, 32, [
         1, 1, 2, 1, 2, 1, 1, 2], data3, error3)

    excel_writer = pd.ExcelWriter(
        f'{os.getcwd()}/../table/Case_3_result_2.xlsx')
    data1.to_excel(excel_writer, '第1组')
    error1.to_excel(excel_writer, '第1组的故障')
    data2.to_excel(excel_writer, '第2组')
    error2.to_excel(excel_writer, '第2组的故障')
    data3.to_excel(excel_writer, '第3组')
    error3.to_excel(excel_writer, '第3组的故障')
    excel_writer.save()
