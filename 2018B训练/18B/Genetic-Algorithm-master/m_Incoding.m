function pop=m_Incoding(binPop,irange_l)
%% 解码
%染色体包含的参数数量
pop=zeros(1,length(binPop));
for n=1:size(binPop,2)
    Matrix = binPop{n};
    pop(n) = bin2dec(Matrix);
end
pop = pop./10^6+irange_l;
