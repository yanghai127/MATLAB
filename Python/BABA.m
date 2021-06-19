%% 阿里巴巴与百度云股票最低值
clear,clc;
a = xlsread("BABAraw.csv","BABAraw","B2:G252");
b = size(a);
date = [1:251];
plot(date,a(:,3),"-","linewidth",2);
xlabel("天数");
ylabel("最低价");
set(gca,"linewidth",2);
legend('BABA:Low随Date的变化曲线');
hold on;

a = xlsread("BIDUraw.csv","BIDUraw","B2:G252");
b = size(a);
plot(date,a(:,3),"-","linewidth",2);
legend('BABA','BIDU');