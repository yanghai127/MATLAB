function Handles
%HANDLES 此处显示有关此函数的摘要
%   此处显示详细说明
clear,close,clc;
f=@(x) exp(-2*x);
x=0:0.1:2;
plot(x,f(x));
end

