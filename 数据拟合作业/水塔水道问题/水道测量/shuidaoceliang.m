%% 水道测量
clear,clc;
name='水道测量数据.xlsx';
X=xlsread(name,'A2:C15');
x=X(1:end-1,1)';
y=X(1:end-1,2)';
z=X(1:end-1,3)';

% 初始化数据
new_x=75:0.5:200;
new_y=-50:0.5:150;

z1=spline(x,z,new_x);
z2=spline(y,z,new_y);

new_z=zeros(length(new_x),length(new_y));
for i=1:length(new_x)
    for j=1:length(new_y)
        new_z(i,j)=(z1(i)+z2(j))/2;
    end
end
zz=5*ones(length(new_y),length(new_x));
createfigure(new_x,new_y,new_z',zz)
