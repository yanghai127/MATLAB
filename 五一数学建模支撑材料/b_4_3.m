%% 
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
p=zeros(15,7);
km=[90,120,88,75,111,85,113,93,125,74,132,128,119,89,10];

% p代表各类事件密度，未除总周数，扩大了100倍
for i=1:15
    for j=1:7
       p(i,j)=a(i,j)*100/km(i); 
    end
end
clear i j;

pe=[6.62,8.76,5.56,6.07,9.24,6.58,7.73,6.09,7.76,5.40,8.79,5.86,9.80,7.50,15.90];
format long;
% pp代表人口密度
pp=pe./km;
plot(pp(1:14),p(1:14,1)','ko');
xlabel('人口密度', 'fontsize',12)
ylabel('事件密度','fontsize',12)
grid on
set(gca,'LineWidth',2);



