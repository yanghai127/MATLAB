%% 求解第一问的动态规划算法
clear,clc

main(20, 33, 46, 560, 25, 28, 31, "第1组")
main(23, 41, 59, 580, 30, 30, 35, "第2组")
main(18, 32, 46, 545, 25, 27, 32, "第3组")

function main(M1,M2,M3,f0,Tw,T_ji,T_ou,name)
    NN=[];
    CNC_No=[];
    start=[];
    tail=[];
    k = 3;
    t_max=8*3600;
    t=0;
    T1=T_ji;T3=T_ji;T5=T_ji;T7=T_ji;
    T2=T_ou;T4=T_ou;T6=T_ou;T8=T_ou;
    I_t=0;
    M0=0;
    w_its=zeros(1,8);   % 初始化等待数组
    n=0;        % 当前加工的CNC的编号
    
    % 算法思路:对等待时间进行升序排序，取出前k个CNC的下标进行全排列，得到路径集合
    % 求得每种路径的所需时间，取时间最短的路径第一步作为当下行动方案
    while t<=t_max
        n = n+1;
        [~,index]=sort(w_its);
        Stk=index(1:k);
        % 接下来找出stk的全排列作为路径集合
        Rtk = perms(Stk);   % 候选路径集合
        varphi = zeros(1,size(Rtk,1));  % 记录各路径的完成时刻
        for i = 1:size(Rtk,1)
            r = Rtk(i,:);
            t_test=t;
            I_t_test=I_t;
            w_its_test = w_its;
            j=1;
            while j<=k
                ifTw=false;
                if sum(CNC_No == r(j))>0
                    ifTw = true;
                end
                % 计算总时间
                alphaj = eval("M"+abs(I(r(j))-I_t_test));
                betaj = eval("T"+r(j)) + Tw*ifTw + w(w_its_test(r(j)), alphaj);
                t_test = t_test + alphaj + betaj;
                I_t_test = I(r(j));
                w_its_test = updata_w(w_its_test,alphaj+betaj);
                w_its_test(r(j)) = f0 - ifTw*Tw;
                j = j+1;
            end
            varphi(i) = t_test;
        end
        % 至此路径搜索完毕，开始寻找最短路径
        [~,index]=min(varphi);
        r = Rtk(index,1);   % 最优选择
        ifTw=false;
        if sum(CNC_No == r)>0
            ifTw = true;
        end
        % 计算总时间
        alphaj = eval("M"+abs(I(r)-I_t));
        start = [start;t+alphaj+w(w_its(r), alphaj)];
        if sum(CNC_No == r) > 0
            tail = [tail;t+alphaj+w(w_its(r), alphaj)];
        end
        betaj = eval("T"+r) + Tw*ifTw + w(w_its(r), alphaj);
        t = t + alphaj + betaj;
        I_t = I(r);
        w_its = updata_w(w_its,alphaj+betaj);
        w_its(r) = f0 - ifTw*Tw;
        NN = [NN;n];
        CNC_No = [CNC_No;r];
    end
    table=[NN,CNC_No,start];
    xlswrite("Case_1_result.xls",table,name,"A2");
    xlswrite("Case_1_result.xls",tail,name,"D2");
end

function index = I(num)
    if floor(num/2) == num/2
        index = num/2 - 1;
    else
        index = (num - 1) / 2;
    end
end

function test = updata_w(a,b)
    test = zeros(1,length(a));
    for i = 1:length(a)
        test(i) = w(a(i),b);
    end
end

function time = w(a,b)
    if a>b
        time = a- b;
    else 
        time = 0;
    end
end