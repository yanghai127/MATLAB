%% 灵敏度分析

%改变负重：
t=[0:24];
money1=xlsread('sensitivity.xlsx','sheet1','A2:A26');
plot(t,money1,'b');%负重减少10%的剩余资金数
hold on;
money2=xlsread('sensitivity.xlsx','sheet1','B2:B26');
plot(t,money2,'r');%负重不变的剩余资金数
hold on;
money3=xlsread('sensitivity.xlsx','sheet1','C2:C26');
plot(t,money3,'g');%负重增加10%的剩余资金数
legend('负重减小10%','负重不变','负重增大10%')

%% 改变初始资金：
t=[0:24];
money1=xlsread('sensitivity.xlsx','sheet1','E2:E26');
plot(t,money1,'b');%初始资金减少10%的剩余资金数
hold on;
money2=xlsread('sensitivity.xlsx','sheet1','F2:F26');
plot(t,money2,'r');%初始资金不变的剩余资金数
hold on;
money3=xlsread('sensitivity.xlsx','sheet1','G2:G26');
plot(t,money3,'g');%初始资金增加10%的剩余资金数
legend('初始资金减少10%','初始资金不变','初始资金增加10%')











