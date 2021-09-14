%% 计算spearman相关系数和显著性水平P,仅适用于n>30的大样本
% 没有MATLAB自带的函数准
function [R,P] = fun_spearman(X,kind)

    % 判断参数个数，默认双尾检验
    if nargin == 1
        kind = 2;
    end
    
    % 计算等级矩阵D
    [r,c]=size(X);
    [~,D]=sort(X);
    [~,D]=sort(D);
    % 对相同的数据等级进行处理
    for i=1:c
        DX=D(:,i);
        for j=1:r
            a=(X(:,i)==X(j,i));         % 得到逻辑向量a
            DX(a==1)=sum(DX.*a)/sum(a); % 对名次进行处理
        end
        D(:,i)=DX;
    end
    
    % 计算相关系数R
    R=eye(c);
    for i=1:c-1
        for j=i+1:c
%             R(i,j)=1-6*sum((D(:,i)-D(:,j)).^2)/(r*(r*r-1));
            % 下面这个更准确一些，本质还是皮尔逊相关系数
            a=corrcoef(D(:,i),D(:,j));
            R(i,j)=a(1,2);
            R(j,i)=R(i,j);
        end
    end
    
    % 假设检验
    if kind~=1 && kind~=2
        disp('Kind参数输入错误，显著性水平P计算失败')
    else
        P=eye(c); % 初始化
        for i=1:c-1
            for j=i+1:c
                z=abs(R(i,j))*sqrt(r-1);
                P(i,j)=(1-normcdf(z))*kind;
                P(j,i)=P(i,j);
            end
        end
    end

end

