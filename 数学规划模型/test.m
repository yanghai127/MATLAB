%% 命令测试
clear,clc,close all

% 注意函数实体要放在使用的命令后面
fplot(@Afun1,[-3, 3])
Afun1(5)

% 函数没必要单独放到一个文件里
function y=Afun1(x)
    y=(x+1).*(x<1)+(1+1./x).*(x>=1);
end
