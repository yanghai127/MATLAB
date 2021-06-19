%% 数值微分
clear,clc;
x=[0,sort(2*pi*rand(1,5000)),2*pi];
y=sin(x);
f1=diff(y)./diff(x);
f2=cos(x(1:end-1));
plot(x(1:end-1),f1,x(1:end-1),f2);
d=norm(f1-f2); %欧几里得范数
disp(d);

%% 数值积分
clear,clc;
format long;
f=@(x)4./(1+x.^2);
[i,n]=quad(f,0,1,1.1e-8);
i
n
[i,n]=quadl(f,0,1,1.1e-8);
i
n
(atan(1)-asin(0)).*4
format;

%% 基于全局自适应积分方法
clear,clc;
i=integral(@fe,1,exp(1))

%% 梯形积分方法
clear,clc;
x=1:6;
y=[6,8,11,7,5,2];
plot(x,y,'-ko');
grid on; % 显示网格线
axis([1,6,0,11]);
i1=trapz(x,y)
i2=sum(diff(x).*(y(1:end-1)+y(2:end))/2)

%% 平面桁架结构受力分析
alpha=sqrt(2)/2;
A= [0,1,0,0,0,-1,0,0,0,0,0,0,0;
    0,0,1,0,0,0,0,0,0,0,0,0,0;
    alpha,0,0,-1,-alpha,0,0,0,0,0,0,0,0;
    alpha,0,1,0,alpha,0,0,0,0,0,0,0,0;
    0,0,0,1,0,0,0,-1,0,0,0,0,0;
    0,0,0,0,0,0,1,0,0,0,0,0,0;
    0,0,0,0,alpha,1,0,0,-alpha,-1,0,0,0;
    0,0,0,0,alpha,0,1,0,alpha,0,0,0,0;
    0,0,0,0,0,0,0,0,0,1,0,0,-1;
    0,0,0,0,0,0,0,0,0,0,1,0,0;
    0,0,0,0,0,0,0,1,alpha,0,0,-alpha,0;
    0,0,0,0,0,0,0,0,alpha,0,1,alpha,0;
    0,0,0,0,0,0,0,0,0,0,0,alpha,1;];
b=[0;10;0;0;0;0;0;15;0;20;0;0;0];
f=A\b;
disp(f);
% 正数表示拉力，负数表示压力

%% 小行星运行轨道计算问题
clear,clc;
xi=[1.02,0.87,0.67,0.44,0.16];
yi=[0.39,0.27,0.18,0.13,0.13];
A=zeros(length(xi));
for i=1:length(xi)
    A(i,:)=[xi(i)*xi(i),2*xi(i)*yi(i),yi(i)*yi(i),2*xi(i),2*yi(i)];
end
b=-ones(length(xi),1);
ai=A\b;
f=@(x,y)2.4645*x.^2-0.8846*x.*y+6.4917*y.^2-1.3638*x-7.2016*y+1;
h=ezplot(f,[-0.5,1.2,0,1.2]);

%% 非线性方程数值求解
clear,clc;
f=@(x)x-1./x+5;
x1=fzero(f,-5)
x2=fzero(f,1)
x3=fzero(f,0.1)
fplot(f,[-6,2]);
grid on;

%% 函数极值计算
clear;
f=@(x)0.4*x(2)+x(1)^2+x(2)^2-x(1)*x(2)+1/30*x(1)^3;
x0=[0.5;0.5];
A=[-1,-0.5;-0.5,-1];
b=[-0.4;-0.5];
lb=[0;0];
option=optimset('Display','off');
[xmin,fmin]=fmincon(f,x0,A,b,[],[],lb,[],[],option)

%% 仓库选址
clear,clc;
x0=[10 30 16.667 0.555 22.2221];
y0=[10 50 29 29.888 49.988];
count=[10 18 20 14 25];
f=@(x)sum(sqrt((x0-x(1)).^2+(y0-x(2)).^2).*count);
option=optimset('Display','off');
[xmin,fmin]=fminunc(f,[5;5],option)
plot(x0,y0,'o',xmin(1),xmin(2),'*');

%% 仓库选址第二问
clear,clc;
x0=[10 30 16.667 0.555 22.2221];
y0=[10 50 29 29.888 49.988];
count=[10 18 20 14 25];
f=@(x)sum(sqrt((x0-x(1)).^2+(y0-x(2)).^2).*count);
option=optimset('Display','off');
[xmin,fmin]=fmincon(f,[15;30],[],[],[],[],[],[],'funny')
plot(x0,y0,'o',xmin(1),xmin(2),'*');

%% 求解常微分方程初值问题
clear,clc;
f=@(t,x)[-2,0;0,1]*[x(2);x(1)];
% [0,20]是积分范围
[t,x]=ode45(f,[0,20],[1,0]);
subplot(2,2,1);plot(t,x(:,2));
subplot(2,2,2);plot(x(:,2),x(:,1));

%% 火焰传播模型 刚性问题
clear,clc;
lamda=1e-5;
f=@(t,y)y^2-y^3;
tic;[t,y]=ode15s(f,[0,2/lamda],lamda);toc % 当初始值很小时必须用刚性函数
disp(['ode15s计算的点数' num2str(length(t))]);
