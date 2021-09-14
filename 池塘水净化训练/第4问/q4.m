%% 鱼类身长与体重的拟合模型
clear,clc;
name='第四问.xls';
LY=xlsread(name,'附件6 鱼体重体长','B3:C522');
YY=xlsread(name,'附件6 鱼体重体长','E3:F443');
% 拟合
LY1=LY(:,1);
LY2=LY(:,2);
YY1=YY(:,1);
YY2=YY(:,2);



