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

