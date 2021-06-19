%% 种群竞争模型
clear,clc;
%rabbitFox=@(t,x)[x(1)*(2-0.01*x(2));x(2)*(-1+0.01*x(1))];
rabbitFox=@(t,x)[2*x(1)*(1-x(1)/400-0.005*x(2));x(2)*(-1+0.01*x(1))];
% 积分范围 0~30，初始值分别为300，150，x为所有解，t为每一个积分点
[t,x]=ode45(rabbitFox,[0,50],[300,150]);
subplot(1,2,1);plot(t,x(:,1),'-',t,x(:,2),'-*');
legend('x1(t)-兔子','x2(t)-狐狸');
xlabel('时间');ylabel('物种数量');
grid on;
% 画相位图
subplot(1,2,2);plot(x(:,1),x(:,2));
xlabel('兔子数量');ylabel('狐狸数量');
grid on;