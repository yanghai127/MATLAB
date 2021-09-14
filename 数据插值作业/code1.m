%% 常用的插值函数
clear,clc;
x=-pi:pi;
y=sin(x);
new_x=-pi:0.1:pi;
new_y=pchip(x,sin(x),new_x);
figure(1); % figure防止窗口被覆盖
plot(x, sin(x), 'o', new_x, new_y, 'b-','LineWidth',1);
new_y=spline(x,sin(x),new_x);
hold on;
grid on;
plot(new_x,new_y,'r-','LineWidth',1);
xlabel('x轴');ylabel('y轴');
legend('原数据','三次埃尔米特插值','三次样条插值','location','southeast');
