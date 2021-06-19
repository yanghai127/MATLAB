%% 在不同空间上各类事件的事件密度
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
for i=1:15
    for j=1:7
       p(i,j)=a(i,j)*100/km(i); 
    end
end
clear i j;
surf(1:7,[1:15]',a);
xlabel('事件类别');
ylabel('地区');
zlabel('事件密度');
