%% 插值作业
clear,clc;
name='附件1-附件7.xls';
sheet='附件2 其它数据';
a=xlsread(name,sheet,'C5:J12');
b=xlsread(name,sheet,'C15:J17');
X=[a;b];
ylable={'轮虫(10^6/L)','溶氧(mg/l)','COD(mg/l)','水温(C)','PH值',...
    '盐度','透明度(cm)','总碱度','氯离子','透明度','生物量'};
[r,c]=size(X);
x=1:c;
new_x=1:0.1:c;
for i=1:r
    subplot(3,4,i);
    y=X(i,:);
    new_y=pchip(x,y,new_x);
    plot(x,y,'o',new_x,new_y,'-b');
    new_y=spline(x,y,new_x);
    hold on;
    grid on;
    plot(new_x,new_y,'-r');
    ylabel(ylable{i});
end
legend('原数据','三次埃尔米特插值','三次样条插值','Location','southeast');