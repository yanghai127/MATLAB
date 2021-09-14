%% 数据拟合
clear,clc;
name='data2.xlsx';
X=xlsread(name,'A2:B11');
year=X(:,1);
population=X(:,2);
[fitresult, gof] = createFit(year, population)

