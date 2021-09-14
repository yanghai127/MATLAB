function result=func(v, T1, T2, T3, T4)
% 根据温度和速度计算面积，问题3的目标函数
Tt=T(57.4, 43.7,v/60, T1, T2, T3,T4,0.00678);
maxT=max(Tt);
len5=length(Tt);
cnt1=0;
cnt2=0;
sum=0;
for i=2:len5
    if(Tt(i-1)<=217 && Tt (i)>217)
        cnt1=i;
    end
    if(Tt(i)==maxT)
        cnt2=i;
    end
end
for i=2:len5
    if (i>=cnt1 && i<=cnt2-1)
        sum=sum+0.01*(Tt(i)-217);
    end
end
result = sum;
end