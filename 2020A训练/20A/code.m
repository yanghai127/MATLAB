%%
% 分段三次埃尔米特插值
x = -pi:pi; y = sin(x); 
new_x = -pi:0.1:pi;
p = pchip(x,y,new_x);
figure(1); % 同一个脚本文件里想画多个图，需要编号，否则只显示最后一个图
plot(x, y, 'o', new_x, p, 'r-')

% plot函数用法:
% plot(x1,y1,x2,y2) 
% 线方式： - 实线 :点线 -. 虚点线 - - 波折线 
% 点方式： . 圆点  + 加号  * 星号  x x形  o 小圆  p 五角星号
% 颜色： y黄； r红； g绿； b蓝； w白； k黑； m紫； c青


% 三次样条插值和分段三次埃尔米特插值的对比
x = -pi:pi; 
y = sin(x); 
new_x = -pi:0.1:pi;
p1 = pchip(x,y,new_x);   %分段三次埃尔米特插值
p2 = spline(x,y,new_x);  %三次样条插值
figure(2);
plot(x,y,'o',new_x,p1,'r-',new_x,p2,'b-')
legend('样本点','三次埃尔米特插值','三次样条插值','Location','SouthEast')
% 'Location'用来指定标注显示的位置


% n维数据的插值
x = -pi:pi; y = sin(x); 
new_x = -pi:0.1:pi;
p = interpn (x, y, new_x, 'spline');
% 等价于 p = spline(x, y, new_x);
figure(3);
plot(x, y, 'o', new_x, p, 'r-')

% 人口预测（注意：一般很少使用插值算法来预测，后面有更适合预测的算法，如灰色预测、拟合预测等）
population=[133126,133770,134413,135069,135738,136427,137122,137866,138639, 139538];
year = 2009:2018;
p1 = pchip(year, population, 2019:2021)  %分段三次埃尔米特插值预测
p2 = spline(year, population, 2019:2021) %三次样条插值预测
figure(4);
plot(year, population,'o',2019:2021,p1,'r*-',2019:2021,p2,'bx-')
legend('样本点','三次埃尔米特插值预测','三次样条插值预测','Location','SouthEast')
