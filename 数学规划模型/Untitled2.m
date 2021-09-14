%%
clc, clear
%矩阵a为已知条件索引矩阵，例如第1行1,2,2表示（1,2）处填入数字2
a=[1,2,2; 1,5,3; 1,8,4; 2,1,6; 2,9,3; 3,3,4; 3,7,5
    4,4,8; 4,6,6; 5,1,8; 5,5,1; 5,9,6; 6,4,7; 6,6,5
    7,3,7; 7,7,6; 8,1,4; 8,9,8; 9,2,3; 9,5,4; 9,8,2];
x=optimvar('x',9,9,9,'Type','integer','LowerBound',0,'UpperBound',1);
p=optimproblem('Objective',sum(x,'all'));
p.Constraints.c1=sum(x,1)==1;
p.Constraints.c2=sum(x,2)==1;
p.Constraints.c3=sum(x,3)==1;
con4=[];                %第4类约束条件初始化
for k=1:9
    for u=0:3:6
        for v=0:3:6
            con4=[con4; sum(x([1+u:3+u],[1+v:3+v],k),'all')==1];
        end
    end
end
for i=1:length(a)
    con4=[con4; x(a(i,1),a(i,2),a(i,3))==1];
end
p.Constraints.c4=con4;
[s,f]=solve(p)