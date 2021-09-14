%% 水塔水位问题
clear,clc;
name='某小镇某天的水塔水位.xlsx';
X=xlsread(name,'Sheet1','D1:E24');

x=X(:,1);
y=X(:,2);
figure('Name','水塔水位vs时间')
plot(x,y,'o');
xlabel('time(s)')
ylabel('foot(10^-^2)')

grid on
new_x=0:0.1:93270;
new_y=spline(x,y,new_x);
hold on
plot(new_x,new_y);
plot(35930,new_y(359301),'rp',39332,new_y(393321),'bp')
plot(79154,new_y(791541),'rp',82649,new_y(826491),'bp')
legend('原始数据点','三次样条插值','开始点1','结束点1','开始点2','结束点2','Location','northwest');

% 计算斜率1
dx1=diff(x(1:11));dy1=diff(y(1:11));
k1=dy1./dx1;
% 计算斜率2
dx2=diff(x(11:22));dy2=diff(y(11:22));
k2=dy2./dx2;
% 计算斜率3
dx3=diff(x(22:end));dy3=diff(y(22:end));
k3=dy3./dx3;
% 计算平均斜率
k=[k1;k2;k3];
disp('不上水时平均斜率：')
k=mean(k)

% 计算两次上水的平均斜率
kk1=(new_y(393321)-new_y(359301))/3400;
kk2=(new_y(826491)-new_y(791541))/3495;
disp('上水时平均斜率：')
kk=(kk1+kk2)/2
% 计算真实上水速率
disp('真实上水速率：')
kkk=kk-k

% 计算一次上水的上水量
disp('水塔上水量：')
res=kkk*7200
disp('总用水量：')
zong=new_y(864001)-y(1)+res*2




