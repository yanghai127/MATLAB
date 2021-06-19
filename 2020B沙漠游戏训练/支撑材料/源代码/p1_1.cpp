#include<iostream>
#include<map>
using namespace std;
map<pair<int,int>,bool>mp;
const int qua[4]={0,1,2,3};				// 将图中的4个特殊点分为4类
										// 按标号顺序记在该数组中
										// 0起点，1村庄，2矿山，3终点
const int dist[4][4]={{0,6,8,3},		// 4个特殊点之间的距离矩阵 
					  {6,0,2,3},
					  {8,2,0,5},
					  {3,3,5,0}};
const int f[4][4]={{0,1,1,1},			// 4类特殊点互相到达的决策情况 
				   {0,0,1,1},
				   {0,1,0,1},
				   {0,0,0,0}};
const int wea[30]={2,2,1,3,1,2,3,1,2,2,	// 天气情况,1,2,3分别代表晴朗、高温和沙暴 
				   3,2,1,2,2,2,3,3,2,2,
				   1,1,2,1,3,2,1,1,2,2};

const int mx=3,my=2;					// mx和my分别是水和食物的重量
const int cx=5,cy=10;					// cx和cy分别是水和食物的基准价格
const int sx[4]={0,5,8,10};	
							//sx中下标为1-3的元素分别指晴朗,高温,沙暴天气下水的基础消耗 
const int sy[4]={0,7,6,10};
							//sy中下标为1-3的元素分别指晴朗,高温,沙暴天气下食物的基础消耗 
const int n=4;				// 共有4个特殊点 
const int maxm=1200;		// 背包容量 
const int coins=10000;		// 起始总资产 
const int base=1000;		// 挖矿每日收益 
const int date=30;			// 截止日期 
int costx[32][4][4];		// 第d天从第i点走到第j点所消耗的水 
int costy[32][4][4];		// 第d天从第i点走到第j点所消耗的食物 
int days[32][4][4];			// 第d天从第i点走到第j点所需要的实际天数 

int rec[32];				// 枚举不同情况下每天所在位置，会不断更新 
// 每一天所到达的点的标记-1代表此时处于最短路径上的某个普通点或此时已经到达终点
// 其余的数字 分别代表当前玩家位于对应的特殊点 对应情况如qua数组所示 
int act[32];				// 枚举不同情况下每天的行动，会不断更新 
// 每一天的特殊行动情况 2代表挖矿 1代表于矿山停止行动 0代表在村庄购买 
int ansx[32];				// ansx与ansact是最优解路径和最优解路径上的行为 
int ansact[32];
int ansg,ansh;				// ansg和ansh是最优解对应的初始水和食物的资源量 
int ans=0;					// ans用来存储剩余资金量，最后结果即本题答案 
int g,h;					// 用于枚举的初始水与食物资源量 

// day代表日期，now代表当前位置，nm代表剩余重量，c代表剩余资金量，
// x代表水箱数，y代表食物箱数，type代表行动(-1代表常规操作)，type代表当天行动
void dfs(int day,int now,int nm,int c,int x,int y,int type)
{
	rec[day]=now;			// 更新位置 
	act[day]=type;			// 更新状态 
	// 如果当前在终点	
	if(qua[now]==3)
	{
		if(ans<=c+x*cx+y*cy)
		{
			ansg=g;
			ansh=h;
			ans=c+x*cx+y*cy;
			for(int i=0;i<=date;i++)
				ansx[i]=rec[i];
			for(int i=0;i<=date;i++)
				ansact[i]=act[i];
		}
		act[day]=-1;
		rec[day]=-1;
		return;
	}
	// 如果超过截止日期 
	if(day>=date)
	{
		act[day]=-1;
		rec[day]=-1;
		return;
	}
	// 如果当前在村庄 
	if(qua[now]==1)
		nm=maxm-mx*x-my*y;				// 计算剩余重量 
	for(int i=0;i<n;i++)
		if(f[qua[now]][qua[i]])
		{
			int tx=costx[day][now][i];	// 水的花销 
			int ty=costy[day][now][i];	// 食物的花销 
			int ucost=c;				// c代表剩余资金 
			int ux,uy;					// ux,uy代表剩余水和食物的数量 
			int um=nm;					// nm代表剩余重量
			
			if(x>=tx)
				ux=x-tx;
			else
			{
				ux=0;
				ucost-=2*(tx-x)*cx;
				um-=(tx-x)*mx;
			}
			
			if(y>=ty)
				uy=y-ty;
			else
			{
				uy=0;
				ucost-=2*(ty-y)*cy;
				um-=(ty-y)*my; 
			}
			
			if(ucost<0||um<0)
				continue;
			dfs(day+days[day][now][i],i,um,ucost,ux,uy,0);
		}
	// 如果当前在矿山 
	if(qua[now]==2)
	{
		int attday=day;					// 先存一下当前日期 
		int tx=sx[wea[attday]];			// 记录当天水的基本消耗 
		int ty=sy[wea[attday]];			// 记录当天食物的基本消耗 
		attday++;
		// 判断水够不够当天基础消耗 
		if(x>=tx)
		{
			x-=tx;
			tx=0;
		}
		else
		{
			tx-=x;
			x=0;
		}
		// 判断食物够不够当天基础消耗 
		if(y>=ty)
		{
			y-=ty;
			ty=0;
		}
		else
		{
			ty-=y;
			y=0;
		}
		// 不够随时购买（任意处都是村庄）		
		nm-=tx*mx+ty*my;
		c-=2*tx*cx+2*ty*cy;
		if(nm>=0&&c>=0)
			dfs(attday,now,nm,c,x,y,1);
		
		attday=day;
		tx=sx[wea[attday]]*2;			// 记录当天挖矿水的消耗 
		ty=sy[wea[attday]]*2;			// 记录当天挖矿食物的消耗 
		attday++;
		// 判断水够不够当天挖矿消耗
		if(x>=tx)
		{
			x-=tx;
			tx=0;
		}
		else
		{
			tx-=x;
			x=0;
		}
		// 判断食物够不够当天挖矿消耗
		if(y>=ty)
		{
			y-=ty;
			ty=0;
		}
		else
		{
			ty-=y;
			y=0;
		}
		// 不够随时购买（任意处都是村庄）
		nm-=tx*mx+ty*my;
		c-=2*tx*cx+2*ty*cy;
		c+=base;
		if(nm>=0&&c>=0)
			dfs(attday,now,nm,c,x,y,2);
	}
	// 回溯 
	rec[day]=-1;
	act[day]=-1;
}
int main()
{	// 初始化位置数组和行动数组 
	for(int d=0;d<=date;d++)
	{
		rec[d]=-1;
		act[d]=-1;
	}
	// 初始化costx,costy,days矩阵，只有四个点 
	for(int d=0;d<date;d++)
		for(int i=0;i<n;i++)
			for(int j=0;j<n;j++)
				if(f[qua[i]][qua[j]]) 		// f是决策矩阵 
				{	// sumx代表消耗水的数量，sumy代表消耗食物的数量 
					int now=0,count=0,sumx=0,sumy=0;
					while(count<dist[i][j])
					{
						if(wea[now+d]!=3)	// 不为沙暴 
						{
							count++;		// count代表行走距离 
							sumx+=2*sx[wea[now+d]];
							sumy+=2*sy[wea[now+d]];
						}
						else
						{
							sumx+=sx[wea[now+d]];
							sumy+=sy[wea[now+d]];
						}
						now++;				// now代表消耗时间 
						if(now+d>=date)		// d代表当前日期 
							break;
					}
					// 第d天从i走不到j的情况 
					if(count<dist[i][j])
					{
						sumx=sumy=20000;	// 随便赋值，超过金额最大量就行 
						now=30;				// 随便赋值，超过29就行 
					}
					costx[d][i][j]=sumx;	// 消耗食物量
					costy[d][i][j]=sumy;	// 消耗水量
					days[d][i][j]=now;		// 消耗天数 
				}

	// 枚举水占的重量 
	for(int i=0;i<=maxm;i+=mx)
	{	// g,h代表初始水和食物的数量 
		g=i/mx;						// 水的数量，向下取整 
		h=(maxm-i)/my;				// 食物数量，向下取整 
		if(!mp[make_pair(g,h)])		// 如果不曾递归过这种情况，就进行递归 
			dfs(0,0,0,coins-g*cx-h*cy,g,h,-1);
		mp[make_pair(g,h)]=true;	// 遍历过就改为true 
	}

	// ansx代表所处位置，ansact代表当前行动 
	for(int i=0;i<=date;i++)
		cout<<i<<":"<<ansx[i]<<";"<<ansact[i]<<endl;
	cout<<endl;
	cout<<ans<<" "<<ansg<<" "<<ansh<<endl;
}

 
