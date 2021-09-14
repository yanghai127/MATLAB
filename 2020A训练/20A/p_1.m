%% 第一问主函数
clear,clc;
Ts=xlsread('附件.xlsx','Sheet1','B2:B710');
xTs=xlsread('附件.xlsx','Sheet1','A2:A710');
sum1=0;
sum2=0;
min1=inf;
best1=0;
best2=0;
min2=inf;
best3=0;
deltat=0.01;
v=7/6;
len0=floor(235.5/v/deltat);
len1=floor(339.5/v/deltat);
len=floor(435.5/v/deltat);
tn=zeros(1,len);

for i=1:len
    tn(i)=i*deltat;
end

for j=1:1000
    temp=T(0.1*j,50,7/6,175,195,235,255,0.005);
    for i=1:len0
        if(tn(i)>=19 && mod(i,50)==0)
            sum1=sum1+(temp(i)-Ts((i-1850)/50))^2;
        end
    end
    if(sum1<min1)
        min1=sum1;
        best1=0.1*j;
    end
    sum1=0;
end

min=inf;

for j=1:1000
    temp=T (best1,0.1*j, 7/6, 175, 195, 235,255,0.005);
    for i=len0+1:len1
        if (mod(i,50)==0)
            sum1=sum1+(temp(i)-Ts((i-1850)/50))^2;
        end
    end
    if (sum1<min)
        min=sum1;
        best2=0.1*j;
    end
    sum1=0;
end

for j=1:1000
    temp=T(best1,best2,7/6,175,195,235,255,2e-3+5e-6*j);
    for i=len1+1:len
        if (mod(i,50)==0)
            sum2=sum2+(temp(i)-Ts((i-2100)/50))^2;
        end
    end
    if (sum2 <min2)
        min2=sum2;
        best3=2e-3+5e-6*j;
    end
    sum2=0;
end

v=78/60;% 这里更改速度
len=floor(435.5/v/deltat);
tn=zeros(1,len);

for i=1:len
    tn (i)=i*deltat;
end

result=T(best1,best2,v,173,198,230,254,best3);% 这里更改温度
plot(tn,result);
% plot(tn,result,'b',tn,spline(xTs,Ts,tn),'r');
% legend('模型结果','实际数据','Location','southeast')
xlabel('t/s')
ylabel('T/°C')
index=1;
resy=zeros(1,670);
for i=1:length(result)
    if mod(i,50)==0
        resy(index)=result(i);
        index=index+1;
    end
end
resx=linspace(0.5,335,670);
ress=[resx',resy'];
% xlswrite('result.csv',ress,'result','A2');

%%
function result = F(t,v,T1,T2,T3,T4)
% 计算当前的环境温度
% v:移动速度;Ti:第i个不同温区的温度
t1=25/v;
t2=t1+(30.5*5+5*4)/v;
t3=t2+(5+30.5)/v;
t4=t3+(5+30.5)/v;
t5=t4+(5*2+30.5*2)/v;

if(t<t1-(T1-25)/20)
    T=25;
elseif (t>t1-(T1-25)/20 && t<=t1)
    T=175-(t1-t)/(T1-25)*20*150;
elseif (t>t1 && t<=t2)
    T=T1;
elseif (t>t2 && t<=t2+5/v)
    T= (t-t2)*v/5*(T2-T1)+T1;
elseif (t>t2+5/v && t<=t3)
    T=T2;
elseif (t>t3 && t<=t3+5/v)
    T=(t-t3)*v/5*(T3-T2)+T2;
elseif (t>t3+5/v && t<=t4)
    T=T3;
elseif (t>t4 && t<=t4+5/v)
    T=(t-t4)*v/5*(T4-T3) +T3;
elseif (t>t4+5/v && t<=t5)
    T=T4;
elseif (t>t5 && t<=t5+20/v)
    T= (t-t5)*v/20*(25-T4)+T4;
else
    T=25;
end
result=T;
end

%%
function result = T(RC1,RC2,v,T1,T2,T3,T4,h)
% 求解PCB板中心温度变化曲线
% RC1，RC2：两个是时间常数；v：移动速度；Ti：第i个温区的温度；h：对流换热系数；
deltat=0.01;
len1=floor(339.5/v/deltat);
len0=floor(235.5/v/deltat);
len=floor(435.5/v/deltat);
tn=zeros(1,len);
for i=1:len
    tn (i)=i*deltat;
end
T=ones(1,25)*25;
for i=2:len0
    T(i)=T(i-1)+(F(tn(i),v,T1,T2,T3,T4)-T(i-1))*(1-exp(-deltat/RC1));
end
for i=len0+1:len1
    T(i)=T(i-1)+(F(tn(i),v,T1,T2,T3,T4)-T(i-1))*(1-exp(-deltat/RC2));
end

for i=len1+1:len
    T(i)=T(i-1)+(F(tn(i),v,T1,T2,T3,T4)-T(i-1))*h*deltat;
end
result=T;
end

