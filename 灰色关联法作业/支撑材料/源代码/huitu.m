function huitu(xvector1, yvector1)

figure1 = figure;

% 创建 axes
axes1 = axes('Parent',figure1,...
    'Position',[0.13 0.11 0.799214929214929 0.815]);
hold(axes1,'on');

% 创建 bar
bar1 = bar(xvector1,yvector1,'DisplayName','stand_S');
baseline1 = get(bar1,'BaseLine');
set(baseline1,'Visible','on');

% 创建 ylabel
ylabel('加权灰色关联度');

% 创建 xlabel
xlabel('生产矿井');

box(axes1,'on');
hold(axes1,'off');
% 设置其余坐标区属性
set(axes1,'FontName','宋体','FontWeight','bold','XTick',[1 2 3 4 5],...
    'XTickLabel',{'白家庄矿','杜尔坪矿','西铭矿','官地矿','西曲矿'},'YGrid','on');
