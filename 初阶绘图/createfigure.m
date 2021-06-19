function createfigure(X1, Y1)
%CREATEFIGURE(X1, Y1)
%  X1:  x 数据的向量
%  Y1:  y 数据的向量

%  由 MATLAB 于 02-Apr-2021 18:03:54 自动生成

% 创建 figure
figure1 = figure('Color',...
    [0.894117653369904 0.941176474094391 0.901960790157318]);

% 创建 axes
axes1 = axes('Parent',figure1,...
    'Position',[0.128751560549313 0.106951219512195 0.775 0.815]);
hold(axes1,'on');

% 创建 plot
plot(X1,Y1,'ZDataSource','','Color',[0 0 0]);

% 创建 xlabel
xlabel('x','LineStyle','none','EdgeColor',[1 1 1],...
    'HorizontalAlignment','right',...
    'FontSize',11);

% 创建 title
title('y = sin(x)');

% 取消以下行的注释以保留坐标区的 X 范围
% xlim(axes1,[0 6.29]);
box(axes1,'on');
% 设置其余坐标区属性
set(axes1,'Color',[0.894117653369904 0.941176474094391 0.901960790157318],...
    'FontName','华文楷体','FontWeight','bold','XAxisLocation','origin','XColor',...
    [0 0 0],'XGrid','on','XTick',[0 3.1415926 6.2831852 6.29],'XTickLabel',...
    {'0','\pi','2\pi',''},'YColor',[0 0 0],'YGrid','on','ZColor',[0 0 0]);
