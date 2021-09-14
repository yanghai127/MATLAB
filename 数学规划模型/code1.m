%% 求函数的最大值,非线性规划问题
clear,clc;
p=optimproblem('ObjectiveSense','max');
x1=optimvar('x1',1,'LowerBound',-3,'UpperBound',12.1);
x2=optimvar('x2',1,'LowerBound',4.1,'UpperBound',5.8);
p.Objective = 21.5+x1*sin(4*pi*x1)+x2*sin(20*pi*x2);
x0.x1=unifrnd(-3,12.1);
x0.x2=unifrnd(4.1,5.8);
[sol,fval,flag,out] = solve(p,x0);
fval
