% MATLAB的GA工具只求函数的(近似)最小值，需要将目标函数取反
function [ y ] = target(x)
y = -x-10*sin(5*x)-7*cos(4*x);
end

