%% 综合污染指数
clear,clc;
name='第二问.xls';
X=xlsread(name,'Sheet2','A1:H24');

% 三次样条插值补数据
x=1:8;
new_x=1:0.5:8;
NEW_X=zeros(24,15);
for i=1:24
    new_y=spline(x,X(i,x),new_x);
    NEW_X(i,:)=new_y;
end
X=NEW_X;

% 求解综合污染指数
res=zeros(4,15);        % 综合污染指数表
S_res=zeros(4,15);      % 排名表
ss=[5 20 8.5 2 30 300];
for i=1:15
    test=reshape(X(:,i),6,4);
    for j=[2 4 6]
        M=max(test(j,:));
        test(j,:)=M-test(j,:);
    end
    M=max(abs(test(3,:)-8.5));
    test(3,:)=1 - abs(test(3,:)-8.5)/M;
    
     % 对do、cod、ph、盐度、透明度进行单项评价
    M=repmat(ss',1,4);
    p=test./M;
    pp=((max(p).^2+mean(p).^2)/2).^0.5;  % 综合评价
    res(:,i)=pp';
    [S_pp,index]=sort(pp);
    S_res(:,i)=index';
end

% 绘图
x=1:15;
plot(x,res(1,:),'-*',x,res(2,:),'-o',x,res(3,:),'-p',x,res(4,:),'-x')
legend('1号池塘','2号池塘','3号池塘','4号池塘')
grid on
xlabel('周数')
ylabel('综合污染指数')
