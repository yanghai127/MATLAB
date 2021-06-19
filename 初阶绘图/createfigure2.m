function createfigure2(x,y1)
%CREATEFIGURE2(y1)
%  Y1:  y 数据的向量

%  由 MATLAB 于 02-Apr-2021 18:46:36 自动生成

% 创建 figure
figure1 = figure('Color',[1 1 1]);

% 创建 axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% 创建 plot
plot(x,y1,'DisplayName','y');

box(axes1,'on');
% 创建 legend
legend(axes1,'show');

