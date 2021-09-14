%% 蒙特卡罗思想学习
tic
clear,clc;
% 浦丰投针实验模拟
% rand、randi
l=0.8;
a=1.5;
m=0;
n=100000;
x=rand(n,1)*a/2;    % 位于[0,a/2]区间中
phi=rand(n,1)*pi/2; % 位于[0,pi/2]区间中
for i=1:n
    if x(i) <= l*sin(phi(i))/2  % 代表针线相交
        m=m+1;
    end
end
p=m/n;
pai=1/(p*a/(2*l));
disp(['圆周率近似为：',num2str(pai)])

% 三门问题
m=0;
mm=0;
car=randi([1,3],n,1);
pick=randi([1,3],n,1);
for i=1:n
    if car(i)==pick(i)
        m=m+1;
        mm=mm+1;
    else
        test=car(i);
        while(test==car(i))
            test=randi([1,3],1);
        end
        if test==pick(i)
            mm=mm+1;
        end
    end
end
p=m/n;
pp=mm/n;
disp(['不换门概率：',num2str(p)])    % 1/3=1/3
disp(['换门概率：',num2str(pp)])     % 1/3+2/3/2=2/3

% 模拟排队
% normrnd、exprnd、floor、ceil、round、fix
% 为什么顾客到来的时间服从指数分布呢？指数分布是泊松过程的事件间隔的分布
h=60*8;
day=1;
zwait=0;
zi=0;
while(day<=100)
    t=exprnd(10);               % 第一个顾客到来时刻，指数分布
    c=t+ceil(normrnd(10,2));    % 第一个顾客服务结束时刻，正态分布
    wait=0;                     % 总等待时间
    i=0;
    % 总时间
    while t<=h
        i=i+1;
        t=t+exprnd(10);  	% 第i+1个顾客的到来时刻
        if t<c
            wait=wait+c-t;  % 加上第i+1个顾客需要等待的时间
            c=c+ceil(normrnd(10,2));    % 第i+1个顾客服务结束时刻
        else
            c=t+ceil(normrnd(10,2));    % 第i+1个顾客服务结束时刻
        end
    end
    day=day+1;
    zi=zi+i;
    zwait=zwait+wait;
end
disp(['平均每天服务人数：',num2str(zi/100)])
disp(['平均每天等待时间：',num2str(zwait/100),'分钟'])

% 有约束的非线性规划问题
% unifrnd
format long
% 范围越小、数据越多、精度越高
x1=unifrnd(20,30,n,1);
x2=unifrnd(10,20,n,1);
x3=unifrnd(-10,16,n,1);
fmax=-inf;
X=zeros(1,3);
for i=1:n
    x=[x1(i),x2(i),x3(i)];
    test=x(1)*x(2)*x(3);
    if(test>fmax && x(1)+2*x(2)+2*x(3)<=72)
        fmax=test;
        X=x;
    end
end
disp('有约束的最大值为：')
disp(fmax)
disp(['对应的x1、x2、x3：',num2str(X(1)),' ',num2str(X(2)),' ',num2str(X(3))])

% 0-1规划，蒙特卡洛==玄学思想
% 这种不断更新迭代获取最优解的思想很重要，时间期望最小等于爆搜
min_money = inf;
min_res = zeros(1,5);
% M_ij代表第i家商店第j本书的售价
M = [18	 39	29  48	59
    24	 45	23	54	44
    22	 45	23	53	53
    28	 47	17	57	47
    24  42	24	47	59
    27	 48	20	55	53];
freight = [10 15 15 10 10 15];
for k = 1:n
    res = randi([1, 6],1,5);     % 根据书来看，下标代表第几本书
    index = unique(res);         % 用到了哪些书店
    money = sum(freight(index)); % 计算运费
    % 计算总花费：运费 + 五本书的售价
    for i = 1:5
        money = money + M(res(i),i);
    end
    % 更新
    if money < min_money
        min_money = money;
        min_res = res;
    end
end
% 最终价格：18+39+48+17+47+20=189
disp(['最终价格：',num2str(min_money)])
disp(['最终结果：',num2str(min_res)])

% 导弹追踪问题
v=200;
dt=0.0000001;
x=[0 20];
y=[0 0];
d=0;
t=0;
m=sqrt(2)/2;
dd=sqrt((y(2)-y(1)).^2+(x(2)-x(1)).^2);
plot(x,y,'.k','MarkerSize',1)
hold on
grid on
axis([0 30 0 8])
k=0;
while(dd>0.0001)
    t=t+dt;
    d=d+3*v*dt;
    x(2)=20+t*v*m;
    y(2)=t*v*m;
    dd=sqrt((x(2)-x(1))^2+(y(2)-y(1))^2);
    tan_alpha=(y(2)-y(1))/(x(2)-x(1));
    cos_alpha=sqrt(1/(1+tan_alpha^2));
    sin_alpha=sqrt(1-cos_alpha^2);
    x(1)=x(1)+3*v*dt*cos_alpha;
    y(1)=y(1)+3*v*dt*sin_alpha;
    k=k+1;
    if mod(k,1000)==0
        plot(x,y,'.k','MarkerSize',1);
        hold on
        pause(0.0001);
    end
    if d>50
        disp('导弹没有击中B船');
        break;
    elseif dd<0.0001
        text(x(1),y(1),'击中B船')
        disp(['导弹飞行',num2str(d),'个单位后击中B船'])
        disp(['导弹飞行的时间为：',num2str(t*60),'分钟'])
        disp(['击中B船坐标为：',num2str(x(1)),' ',num2str(y(1))])
    end
end

% 简易TSP旅行商问题
% randperm
coord =[0.6683 0.6195 0.4    0.2439 0.1707 0.2293 0.5171 0.8732 0.6878 0.8488 ;
        0.2536 0.2634 0.4439 0.1463 0.2293 0.761  0.9414 0.6536 0.5219 0.3609]';
n = size(coord,1);  % 代表城市个数
figure(2)
plot(coord(:,1),coord(:,2),'o');
for i = 1:n
    % 标注城市编号（加0.01把文字往右上方移一点）
    text(coord(i,1)+0.01,coord(i,2)+0.01,num2str(i))
end
hold on
grid on
d = zeros(n);       % 初始化两个城市的距离矩阵全为0
for i = 2:n
    for j = 1:i
        % 城市i的横坐标为x_i，纵坐标为y_i
        coord_i = coord(i,:);
        x_i = coord_i(1);
        y_i = coord_i(2);
        % 城市j的横坐标为x_j，纵坐标为y_j
        coord_j = coord(j,:);
        x_j = coord_j(1);
        y_j = coord_j(2);
        % 计算城市i和j的距离
        d(i,j) = sqrt((x_i-x_j)^2 + (y_i-y_j)^2);
    end
end
d = d+d';           % 生成距离矩阵

min_res = inf;      % 初始化最短距离
min_path = 1:n;     % 初始化最短路径
N = 10000000;        % 模拟次数
for i = 1:N
    result = 0;     % 初始化走过的路程为0
    path = randperm(n);  % 生成一个1-n的随机打乱的序列
    for i = 1:n-1
        result = d(path(i),path(i+1)) + result;	% 按照这个序列不断的更新走过的路程这个值
    end
    result = d(path(1),path(n)) + result;    	% 加上返回距离
    if result < min_res  % 更新最短距离、最短路径
        min_path = path;
        min_res = result;
    end
end
disp('最短路径：')
disp(min_path)
disp(['最短距离：',num2str(min_res)])
min_path = [min_path,min_path(1)];   % 返回起点城市
n = n+1;    % 城市个数加1
for i = 1:n-1
    j = i+1;
    coord_i = coord(min_path(i),:);
    x_i = coord_i(1);
    y_i = coord_i(2);
    coord_j = coord(min_path(j),:);
    x_j = coord_j(1);
    y_j = coord_j(2);
    plot([x_i,x_j],[y_i,y_j],'-')	% 画线段
    pause(0.5)
    hold on
end

toc