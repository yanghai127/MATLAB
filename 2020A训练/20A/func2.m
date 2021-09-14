function result=func2(v, T1, T2, T3, T4)
% º∆À„∂‘≥∆∂»
Tt=T(57.4, 43.7,v/60, T1, T2, T3,T4,0.00678);
cnt1=0;
cnt2=0;
cnt3=0;
maxT=max (Tt);
len=length(Tt);
for i=2: len
    if(Tt(i-1)<=217 && Tt(i)>217)
        cnt1=i ;
    end
    if(Tt(i-1)>217 && Tt (i)<=217)
        cnt3=i-1;
    end
    if (Tt (i)==maxT)
        cnt2=i;
    end
end
n=floor(((cnt2-cnt1) + (cnt3-cnt2))/2);
sum=0;
for i=1:n
    sum=sum+(Tt(cnt2-i)-Tt(cnt2+i))^2; 
end
result=sum/n;
end