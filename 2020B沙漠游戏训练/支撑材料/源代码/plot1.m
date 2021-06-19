%% 绘制第一关挖矿时剩余资金变化情况的Matlab源代码
t=[0:24];
money=xlsread('Result.xlsx','sheet1','C4:C28');
plot(t,money,'b')%第一关剩余资金

%% 绘制第二关挖矿时剩余资金变化情况的Matlab源代码
t=[0:30];
money=xlsread('Result.xlsx','sheet1','I4:I34');
plot(t,money,'b')%第二关剩余资金
