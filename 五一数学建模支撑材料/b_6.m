%%
% 计算各区事件数量的权值pr
clear,clc;
format long;
areasum=[157 117 92 153 245 153 196 14 105 73 155 180 101 216 99 1641];
asum=sum(areasum);
TH=zeros(1,15);
for i=1:15
    TH(i)=areasum(i)/asum;
end
clear ans asum i pr;
% 计算在各区域建立消防站后对各区的影响力，越小代表影响力越强
name='邻接矩阵.xlsx';
% sp代表各区域之间的最短距离
sp=xlsread(name,1);
clear name;
% S代表各区域分别到其它各区域的距离之和
S=sum(sp);
H=zeros(15,15);
for i=1:15
    test=sp(:,i)./S(i);
    H(i,:)=test';
    
end
sir=zeros(15,15);
for i=1:15
    for j=1:15
        if sp(i,j)~=0
            sir(i,j)=1/sp(i,j);
        end
    end
end
clear i test;
% 计算人口密度pp
pe=[6.62,8.76,5.56,6.07,9.24,6.58,7.73,6.09,7.76,5.40,8.79,5.86,9.80,7.50,15.90];
km=[90,120,88,75,111,85,113,93,125,74,132,128,119,89,10];
pp=pe./km;
clear pe km;
% 计算第三个消防站贡献值
C=zeros(1,15);
for i=1:15
    C(1,i)=sum(sir(i,:).*H(10,:).*H(14,:).*H(4,:).*H(11,:).*pp.*TH)*10000;
end
C(1,10)=0;
C(1,14)=0;
C(1,4)=0;
C(1,11)=0;
i=1:15;
bar(i,C);
title('各地区贡献值');
xlabel('地区');
ylabel('贡献值');
clear i;