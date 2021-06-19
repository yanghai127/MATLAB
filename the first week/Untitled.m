%% 结构化程序式
for i=1:10
    x=linspace(0,10,101);
    plot(x,sin(x+i));
    print(gcf,'-deps',strcat('plot',num2str(i),'.ps'));
end

%%
a=6;
if(rem(a,2)==0)
    disp('a is even');
else
    disp('a is old');
end

%%
num=-1;
switch num
    case -1
        disp(-1);
    case 0
        disp(0);
    case 1
        disp(1);
    otherwise
        disp('other');
end

%%
n=1;
while prod(1:n)<1e100
    n = n + 1;
end
disp(n);

%%
i=1;
sum=0;
while i<1000
    sum=sum+i;
    i=i+1;
end

%%
tic
clear a n;
n=1;
a=zeros(10);
for i=1:2:10
    a(n)=2^i;
    n=n+1;
end
disp(a);
toc

%%
tic
clear a n;
n=1;
for i=1:2:10
    a(n)=2^i;
    n=n+1;
end
disp(a);
toc

%%
%ctrl+c可以跳出运行

%% functions方程


