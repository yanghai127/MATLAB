#include<iostream>
#include<map>
using namespace std;
map<pair<int,int>,bool>mp;
const int qua[6]={0,2,1,2,1,3};			// 将图中的6个特殊点分为4类
										// 按标号顺序记在该数组中
										// 0起点，1村庄，2矿山，3终点
const int dist[6][6]={{0,7,8,9,9,11},	// 6个特殊点之间的距离矩阵 
					  {7,0,1,3,4,4},
					  {8,1,0,2,3,3},
					  {9,3,2,0,1,2},
					  {9,4,3,1,0,2},
					  {11,4,3,2,2,0}};
const int f[4][4]={{0,1,1,1},			// 6类特殊点互相到达的决策情况 
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
const int n=6;				// 共有6个特殊点 
const int maxm=1200;		// 背包容量 
const int coins=10000;		// 起始总资产 
const int base=1000;		// 挖矿每日收益 
const int date=30;			// 截止日期 
int costx[32][6][6];		// 第d天从第i点走到第j点所消耗的水 
int costy[32][6][6];		// 第d天从第i点走到第j点所消耗的食物 
int days[32][6][6];			// 第d天从第i点走到第j点所需要的实际天数 
int ans=0;
int rec[32];
// 每一天所到达的点的标记-1代表此时处于最短路径上的某个普通点或此时已经到达终点
// 其余的数字 分别代表当前玩家位于对应的特殊点 对应情况如qua数组所示 
int act[32];
// 每一天的特殊行动情况 2代表挖矿 1代表于矿山停止行动 0代表在村庄购买 
int ansx[32];				// ansx与ansact是最优解路径和最优解路径上的行为 
int ansact[32];
int ansg,ansh;				// ansg和ansh是最优解对应的初始水和食物的资源量 
int g,h;					// 用于枚举的初始水与食物资源量 

void dfs(int day,int now,int nm,int c,int x,int y,int type)
{
	act[day]=type;
	rec[day]=now;
	
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
	if(day>=date)
	{
		act[day]=-1;
		rec[day]=-1;
		return;
	}
	if(qua[now]==1)
		nm=maxm-mx*x-my*y;
	for(int i=0;i<n;i++)
		if(f[qua[now]][qua[i]])
		{
			int tx=costx[day][now][i];
			int ty=costy[day][now][i];
			int ucost=c;
			int ux,uy;
			int um=nm;
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
	if(qua[now]==2)
	{
		int attday=day;
		int tx=sx[wea[attday]];
		int ty=sy[wea[attday]];
		attday++;
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
		nm-=tx*mx+ty*my;
		c-=2*tx*cx+2*ty*cy;
		if(nm>=0&&c>=0)
			dfs(attday,now,nm,c,x,y,1);
		
		attday=day;
		tx=sx[wea[attday]]*2;
		ty=sy[wea[attday]]*2;
		attday++;
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
		nm-=tx*mx+ty*my;
		c-=2*tx*cx+2*ty*cy;
		c+=base;
		if(nm>=0&&c>=0)
			dfs(attday,now,nm,c,x,y,2);
	}
	rec[day]=-1;
	act[day]=-1;
}
int main()
{
	for(int d=0;d<=date;d++)
	{
		rec[d]=-1;
		act[d]=-1;
	}
	for(int d=0;d<date;d++)
		for(int i=0;i<n;i++)
			for(int j=0;j<n;j++)
				if(f[qua[i]][qua[j]])
				{
					int now=0,count=0,sumx=0,sumy=0;
					while(count<dist[i][j])
					{
						if(wea[now+d]!=3)
						{
							count++;
							sumx+=2*sx[wea[now+d]];
							sumy+=2*sy[wea[now+d]];
						}
						else
						{
							sumx+=sx[wea[now+d]];
							sumy+=sy[wea[now+d]];
						}
						now++;
						if(now+d>=date)
							break;
					}
					if(count<dis[i][j])
					{
						sumx=sumy=20000;
						now=30;
					}
					costx[d][i][j]=sumx;
					costy[d][i][j]=sumy;
					days[d][i][j]=now;
				}
	for(int i=0;i<=maxm;i+=mx)
	{
		g=i/mx;
		h=(maxm-i)/my;
		if(!mp[make_pair(g,h)])
			dfs(0,0,0,coins-g*cx-h*cy,g,h,-1);
		mp[make_pair(g,h)]=1;
	}
	for(int i=0;i<=date;i++)
		cout<<i<<":"<<ansx[i]<<";"<<ansact[i]<<endl;
	cout<<endl;
	cout<<ans<<" "<<ansg<<" "<<ansh<<endl;
}

 
