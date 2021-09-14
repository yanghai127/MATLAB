'''问题 3 仿真求解算法的评价，由于是多次实验，代码运行时间较长'''
from problem3_1 import main as main1
from PlotParam import Plot_parms
import matplotlib.pyplot as plt
import pandas as pd

fenzu1 = [];fenzu2 = [];fenzu3 = []
for i in range(100):
    print(i)
    data1 = pd.DataFrame(columns=['加工 CNC 编号', '上料开始时间', '下料开始时间'])
    error1 = pd.DataFrame(columns=['故障CNC编号', '故障开始时间','故障结束时间'])
    data2 = pd.DataFrame(columns=['加工 CNC 编号', '上料开始时间', '下料开始时间'])
    error2 = pd.DataFrame(columns=['故障CNC编号', '故障开始时间', '故障结束时间'])
    data3 = pd.DataFrame(columns=['加工 CNC 编号', '上料开始时间', '下料开始时间'])
    error3 = pd.DataFrame(columns=['故障CNC编号', '故障开始时间', '故障结束时间'])

    fenzu1.append(main1(20,33,46,560,25,28,31,data1,error1))
    fenzu2.append(main1(23,41,59,580,30,30,35,data2,error2))
    fenzu3.append(main1(18,32,46,545,25,27,32,data3,error3))

plt.figure()
ax = plt.figure(figsize=(5, 2.8)).add_subplot(111)
ax.plot(range(len(fenzu1)), fenzu1, label='分组 1',color='#4f81bd',)
ax.plot(range(len(fenzu2)), fenzu2, label='分组 2',color='#c0504d')
ax.plot(range(len(fenzu3)), fenzu3, label='分组 3',color='#9bbb59')

img = Plot_parms(ax)
img.style_default()
img.update_font(ylabel='加工成料个数')
img.run(name='result_3_1 评价')

