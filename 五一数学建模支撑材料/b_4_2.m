%% 绘制三维各类事件密度与人口密度关系的拟合曲线
clear;
opts = spreadsheetImportOptions("NumVariables", 2);
opts.Sheet = "Sheet1";
opts.DataRange = "D2:E3684";
opts.VariableNames = ["area", "cla"];
opts.VariableTypes = ["string", "categorical"];
opts = setvaropts(opts, "area", "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["area", "cla"], "EmptyFieldRule", "auto");
tab = readtable("附件2：某地消防救援出警数据.xlsx", opts, "UseExcel", false);
clear opts;
a=zeros(15,7);
h=height(tab);
disp(h)
for i=1:h
    r=char(tab{i,1})-64;
    if r==16
        r=r-1;
    end
    c=char(tab{i,2})-9311;
    a(r,c)=a(r,c)+1;
end
clear tab r c i h;
format long;
p=zeros(15,7);
km=[90,120,88,75,111,85,113,93,125,74,132,128,119,89,10];
for i=1:15
    for j=1:7
       p(i,j)=a(i,j)*100/km(i); 
    end
end
clear i j;

surf(1:7,[1:14]',a(1:14,:));
pe=[6.62,8.76,5.56,6.07,9.24,6.58,7.73,6.09,7.76,5.40,8.79,5.86,9.80,7.50,15.90];
pp=pe./km;

t1=pp;
t2=linspace(0,1.7,10000);
x=polyfit(t1,p(:,7)',2);

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