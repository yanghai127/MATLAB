%% 小区开放前
clc, clear;
T=3030; % 循环次数
P=0.3; % 随机慢化概率
v_max=6; % 最大速度
L=1800; % 网格的数量
dens=0.002; % 给定初始车辆密度
p=1; % 统计流量密度数组
while dens <= 1
    N=fix(dens*L); % N代表车辆数目
    m=1;
    % 产生初始随机速度
    cells_sudu=randperm(N);
    for i=1:N
        cells_sudu(i)=mod(cells_sudu(i),v_max+1);
    end
    % 产生初始随机位置
    [a,b]=find(randperm(L)<=N);
    cells_weizhi=b;
    %变化规则
    for i=1:T
        %定义车头间距
        if cells_weizhi(N)>cells_weizhi(1)
            headways(N)=L-cells_weizhi(N)+cells_weizhi(1)-1;
        else
            headways(N)=cells_weizhi(1)-cells_weizhi(N)-1;
        end
        for j=N-1:-1:1
            if cells_weizhi(j+1)>cells_weizhi(j)
                headways(j)=cells_weizhi(j+1)-cells_weizhi(j)-1;
            else
                headways(j)=L+cells_weizhi(j+1)-cells_weizhi(j)-1;
            end
        end
        %速度变化
        cells_suduNS1=min([v_max-1,cells_sudu(1),max(0,headways(1)-1)]); %NS 规则下第一辆车的速度估计值
        cells_sudu(N)=min([v_max,cells_sudu(N)+1,headways(N)+cells_suduNS1]); %NS 规则下第 N 辆车的速度估计值
        for j=N-1:-1:1
            cells_suduNS=min([v_max-1,cells_sudu(j+1),max(0,headways(j+1)-1)]); %NS 规则下前一辆车的速度估计值
            cells_sudu(j)=min([v_max,cells_sudu(j)+1,headways(j)+cells_suduNS]); %NS 规则下第 j 辆车的前一辆车的速度估计值
        end
        %以概率 P 随机慢化
        if rand()<P
            cells_sudu=max(cells_sudu-1,0); %随机慢化规则下的速度变化
        end
        %位置更新
        for j=N:-1:1
            cells_weizhi(j)=cells_weizhi(j)+cells_sudu(j);
            if cells_weizhi(j)>=L
                cells_weizhi(j)=cells_weizhi(j)-L; %NS 规则下第 j 辆车的位置更新
            end
        end
        %采集数据作图
        if i>L+1000 %采用每组的后 30 个变量取平均
            speed(m)=sum(cells_sudu)/N; %求取平均速度
            m=m+1;
        end
    end
    flow(p)=(sum(speed)/30)*dens; %不同密度下的流量数组
    density(p)=dens;
    dens=dens+0.01;
    p=p+1;
end
plot(density,flow)