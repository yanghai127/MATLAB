function createfigure(xdata1, ydata1, zdata1, zdata2)

% 创建 figure
figure1 = figure;

% 创建 axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% 创建 surf
surf(xdata1,ydata1,zdata1,'Parent',axes1,'LineStyle',':',...
    'EdgeColor',[0.313725501298904 0.313725501298904 0.313725501298904]);

% 创建 surf
surf(xdata1,ydata1,zdata2,'Parent',axes1,...
    'EdgeColor',[0.501960813999176 0.501960813999176 0.501960813999176]);

% 创建 zlabel
zlabel('水深(英尺)');

% 创建 ylabel
ylabel('y(码)');

% 创建 xlabel
xlabel('x(码)');

view(axes1,[-37.5 30]);
grid(axes1,'on');
hold(axes1,'off');
