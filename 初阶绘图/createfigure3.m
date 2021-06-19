function createfigure3(X1, Y1)
%CREATEFIGURE3(X1, Y1)
%  X1:  x 数据的向量
%  Y1:  y 数据的向量

%  由 MATLAB 于 02-Apr-2021 18:51:39 自动生成

% 创建 figure
figure1 = figure('Color',[1 1 1]);

% 创建 axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% 创建 plot
plot(X1,Y1,'DisplayName','data1');

% 取消以下行的注释以保留坐标区的 X 范围
% xlim(axes1,[0 7]);
% 取消以下行的注释以保留坐标区的 Y 范围
% ylim(axes1,[-0.990651475314052 1.00934852468595]);
box(axes1,'on');
% 创建 legend
legend(axes1,'show');

