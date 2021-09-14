%% 线性规划模型
clear,clc;
% 基于求解器求解
% min z=0.04x1+0.15x2+0.1x3+0.125x4
c=[0.04 0.15 0.1 0.125]';
A=[-0.03 -0.3 0 -0.15;
    0.14 0 0 0.07];
b=[32 42]';
aeq=[0.05 0 0.2 0.1];
beq=24;
lb=zeros(4,1);
[x, fval]=linprog(c,A,b,aeq,beq,lb);

% max z=2*x1+3*x2-5*x3
c=[-2 -3 5]';
A=[-2 5 1;
    1 3 1;];
b=[-10 12]';
aeq=[1 1 1];
beq=7;
lb=[0 0 0];
[x,fval]=linprog(c,A,b,aeq,beq,lb);
% 注意求最大值要把fval改成负的

% 机床利润问题，基于求解器求解
c=[4;3];
A=[2 1;1 1;0 1];
b=[10;8;7];
lb=[0;0];
[x,fval]=linprog(-c,A,b,[],[],lb);
x
y=-fval

% 基于问题求解，迭代求解，自动选择求解器
clear,clc;
prob = optimproblem('ObjectiveSense','max');
c = [4;3]; b = [10;8;7];
a = [2 1;1 1;0 1];
x = optimvar('x',2,'LowerBound',0);     % 决策变量
prob.Objective = c'*x;                  % 目标函数
prob.Constraints.con = a*x<=b;          % 约束条件，不能混合使用
[sol,fval,flag,out] = solve(prob)       % fval返回最优解
sol.x                                   % 显示决策变量的值
y = fval

% 带绝对值
% 某些非线性规划的问题也可以变换为线性规划问题求解
c = [1:4]';
b = [-2 -1 -1/2]';
a = [1 -1 -1 1;1 -1 1 -3;1 -1 -2 3];
prob = optimproblem;
u = optimvar('u',4,'LowerBound',0);
v = optimvar('v',4,'LowerBound',0);
prob.Objective = sum(c'*(u+v));
prob.Constraints.con = a*(u-v)<=b;
[sol,fval,flag,out] = solve(prob)
x = sol.u-sol.v

% 整数规划问题
prob = optimproblem;
x = optimvar('x',6,'Type','integer','LowerBound',0);
prob.Objective = sum(x);
con = optimconstr(6);
a = [35 40 50 45 55 30];
con(1) = x(1)+x(6)>=35;
for i = 1:5
    con(i+1)=x(i)+x(i+1)>=a(i+1);
end
prob.Constraints.con=con;
[sol, fval, flag] = solve(prob)
sol.x

% 0-1规划
prob = optimproblem;
x = optimvar('x',4,5,'Type','integer','LowerBound',0,'UpperBound',1);
c = load('data2_6.txt');
prob.Objective = sum(sum(c.*x));
prob.Constraints.con1 = sum(x,1) == 1;
prob.Constraints.con2 = sum(x,2) <= 2;
[sol,fval,flag] = solve(prob)
sol.x

% 网点建供应站
clc
prob = optimproblem;
a = [9.4888	8.7928	11.5960	11.5643	5.6756	9.8497	9.1756	13.1385	15.4663	15.5464;
    5.6817	10.3868	3.9294	4.4325	9.9658	17.6632	6.1517	11.8569	8.8721	15.5868];
n = 10;
d = dist(a);    % 求最短路径
% x代表某个位置是否建立网点
x = optimvar('x',n,'Type','integer','LowerBound',0,'UpperBound',1);
% yij代表第j个网点被第i个供应站覆盖
y = optimvar('y',n,n,'Type','integer','LowerBound',0,'UpperBound',1);
prob.Objective = sum(x);
% 注意向量的维度，维度必须一致，最好都用小于等于描述
con1 = [1<=sum(y)'; sum(y,2)<=5];
% 不在初始化时加入约束，注意声明约束数量
con2 = optimconstr(2*n*n);
con3 = optimconstr(n);
k = 0;
for i = 1:n
    for j = 1:n
        k = k+1;
        con2(k*2-1) = d(i,j)*y(i,j)<=10*x(i);
        con2(k*2) = y(i,j)<=x(i);
    end
    con3(i) = x(i)==y(i,i);
end
prob.Constraints.con1 = con1;
prob.Constraints.con2 = con2;
prob.Constraints.con3 = con3;
[sol,fval,flag] = solve(prob);
xx = sol.x
yy = sol.y






