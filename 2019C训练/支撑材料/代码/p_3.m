phi=zeros(size(2:2:100));
j=0;
for i=2:2:100
    j=j+1;
    phi(j)=myfun(i);
end
m=2:2:100;%每次泊车数量
phi=3600*phi;%计算每小时的车流量
plot (m, phi ,'r.')
grid on
xlabel('泊车数/个')
ylabel('乘车效率(辆/小时)')

function f=myfun(m)
k=2;
ar = zeros(1,m);
t = zeros(1,1500);
for n=1:1500 % 模拟1500次取均值
    for i=1:m
        mu=30+m*2.5;
        ar(i)=exprnd(mu);%指数分布
    end
    r=max(ar);
    t(n)=r+2*(m*5/(3600/1000)/k+1*(m-k));
end
f=m/mean(t);
end