%% topsis法
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

% 正向化去量纲，x+6n（x属于{2,4,6}）行属于极小型，3+6n行属于中间型（8.5）
res=zeros(4,15);
S_res=zeros(4,15);
i1=[2 4 6];
for i=1:15
    test=reshape(X(:,i),6,4);
    for j=i1
        M=max(test(j,:));
        test(j,:)=M-test(j,:);
    end
    M=max(abs(test(3,:)-8.5));
    test(3,:)=1 - abs(test(3,:)-8.5)/M;
    %标准化
    [r,c]=size(test);
    M = sum(test.*test,2).^0.5;
    M = repmat(M,1,c);
    test = test./M;
    % 计算欧式距离
    D_Max = sum((test - repmat(max(test,[],2),1,c)) .^ 2) .^ 0.5;
    D_Min = sum((test - repmat(min(test,[],2),1,c)) .^ 2) .^ 0.5;
    S = D_Min ./ (D_Max+D_Min);
    res(:,i)=S';
    [S_sort,index] = sort(S,'descend');
    S_res(:,i)=index';
end

% 绘图
x=1:15;
plot(x,res(1,:),'-*',x,res(2,:),'-o',x,res(3,:),'-p',x,res(4,:),'-x')
legend('1号池塘','2号池塘','3号池塘','4号池塘','Location','northwest')
grid on
xlabel('周数')
ylabel('得分')