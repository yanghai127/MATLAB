function volume = pillar(Do,Di,height)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
if nargin==2
    height=1;
end
volume=abs(Do.^2-Di.^2).*height*pi/4;
end

