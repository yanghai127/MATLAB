%% 绘制第一关挖矿时剩余资源变化情况的Matlab源代码
t=[0:24];
water=xlsread('Result.xlsx','sheet1','D4:D28');
food=xlsread('Result.xlsx','sheet1','E4:E28');
plot(t,water,'b');
hold on;
plot(t,food,'r');
legend('水','食物')%第一关剩余资源
%% 绘制第一关挖矿时剩余资源变化情况的Matlab源代码
t=[0:30];
water=xlsread('Result.xlsx','sheet1','J4:J34');
food=xlsread('Result.xlsx','sheet1','K4:K34');
plot(t,water,'b');
hold on;
plot(t,food,'r');
legend('水','食物')%第二关剩余资源