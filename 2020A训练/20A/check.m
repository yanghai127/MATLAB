function result = check(deltat,v,T)
% 判断是否符合制程条件
len2=floor (435.5/v/deltat);
len3=floor (339.5/v/deltat);
result=1; % 符合条件为1，反之为0
cnt1=0 ;
cnt2=0;
cnt3=0;
cnt4=0;

for i=2:len3
    grad=(T(i)-T(i-1))/deltat; % 计算导数
    if (grad<0 || grad>3)
        result=0;
    end
    if (T(i)>=150 && T(i-1)<150)
        cnt1=i;
    end
    if (T(i)>180 && T(i-1)<=180)
        cnt2=i-1;
    end
    if (T(i)>217 && T(i-1)<=217 )
        cnt3=i;
    end
end

for i=len3+1:len2
    grad=(T(i)-T(i-1))/deltat;
    if (abs(grad)>3)
        result=0;
    end
    if(T(i)<=217 && T(i-1)>217)
        cnt4=i-1;
    end
end

% 判断在150°C~190°C的时间是否符合
if (deltat* (cnt2-cnt1)<60 || deltat* (cnt2-cnt1)>120)
    result=0;
end

% 各判断大于217°C的时间是否符合。
if (deltat* (cnt4-cnt3)<40 || deltat* (cnt4-cnt3)>90)
    result=0;
end
% 判断峰值是否符合

if(T(len3)<240 || T(len3)>250)
    result=0;
end

end

