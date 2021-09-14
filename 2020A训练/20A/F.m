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

