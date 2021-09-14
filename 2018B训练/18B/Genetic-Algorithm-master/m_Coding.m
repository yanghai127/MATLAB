function binPop=m_Coding(pop,pop_length,irange_l)
%% 二进制编码（生成染色体）
% 输入：pop--种群
%      pop_length--编码长度
pop=round((pop-irange_l)*10^6);
for n=1:size(pop,2) %循环
        dec2binpop{n}=dec2bin(pop(n));%dec2bin的输出为字符向量；
        lengthpop=length(dec2binpop{n});%dec2binpop是cell数组
        for s=1:pop_length-lengthpop %补零
            dec2binpop{n}=['0' dec2binpop{n}];
        end
    binPop{n}=dec2binpop{n};   %取dec2binpop的第1行
end

    