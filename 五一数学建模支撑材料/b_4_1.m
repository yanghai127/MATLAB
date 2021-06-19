%%
surf([],[],[]);
ylabel('事件类别');
xlabel('人口密度');
zlabel('事件密度');
hold on;
y=ones(1,10000);
yy=ones(1,15);
for i=1:7
    x=polyfit(t1,p(:,i)',2);
    plot3(t1,yy.*i,p(:,i)','ko')
    plot3(t2,y.*i,polyval(x,t2),'LineWidth',2);
end

%%
t1=pp;
t2=linspace(0,1.7,10000);
x=polyfit(t1,p(:,7)',2);
plot(t1,p(:,1)','ko');
grid on
xlabel('人口密度', 'fontsize',12)
ylabel('事件密度','fontsize',12)
set(gca,'LineWidth',2);

%%
surf(1:7,[1:14]',a(1:14,:));
pe=[6.62,8.76,5.56,6.07,9.24,6.58,7.73,6.09,7.76,5.40,8.79,5.86,9.80,7.50,15.90];
format long;
pp=pe./km;
pp1=[pp',p];
pp1=sortrows(pp1);
surf(1:7,pp1(:,1),pp1(:,2:8));
xlabel('事件类别');
ylabel('人口密度');
zlabel('事件密度');
