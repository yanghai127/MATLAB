function gm(A)
syms a b;
c=[a b]';
B=cumsum(A);  % 原始数据累加
n=length(A);
for i=1:(n-1)
    C(i)=(B(i)+B(i+1))/2;  % 生成累加矩阵
end
% 计算待定参数的值
D=A;D(1)=[];
D=D';
E=[-C;ones(1,n-1)];
c=inv(E*E')*E*D;
c=c';
a=c(1);b=c(2);
% 预测后续数据
F=[];F(1)=A(1);
for i=2:(n+12)
    F(i)=(A(1)-b/a)/exp(a*(i-1))+b/a ;
end
G=[];G(1)=A(1);
for i=2:(n+12)
    G(i)=F(i)-F(i-1); %得到预测出来的数据
end 
t1=1:48;
t2=1:60;
G, a, b % 输出预测值，发展系数和灰色作用量

% 灰色预测
subplot(1,2,1);
plot(t1,A,'ko', 'LineWidth',2)
hold on
grid on
plot(t2,G,'k', 'LineWidth',2)
xlabel('月份', 'fontsize',12)
ylabel('接警量','fontsize',12)
set(gca,'LineWidth',2);
% 曲线拟合
subplot(1,2,2);
p=polyfit(t1,A,2);
plot(t1,A,'ko',t2,polyval(p,t2),'k','LineWidth',2);
hold on
grid on
xlabel('月份', 'fontsize',12)
ylabel('接警量','fontsize',12)
set(gca,'LineWidth',2);
end

