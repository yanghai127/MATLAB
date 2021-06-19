#include<iostream>
#include<map>
#include<time.h> 
#include<stdlib.h>
using namespace std;
map<pair<int,int>,bool>mp;
const int qua[4]={0,1,2,3};


const int dist[4][4]={{0,5,5,8},
					{5,0,2,3},
					{5,2,0,3},
					{8,3,3,0}};
const int f[4][4]={{0,1,1,1},
					{0,0,1,1},
					{0,1,0,1},
					{0,0,0,0}};
int wea[30]={2,2,1,3,1,2,2,1,2,2,
			1,2,1,2,2,2,3,1,2,2,
			1,1,2,1,3,2,1,1,2,2};
const int dis[26][26]={
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,1,2,3,4,1,2,3,4,5,2,3,4,5,6,3,4,5,6,7,4,5,6,7,8,
0,1,0,1,2,3,2,1,2,3,4,3,2,3,4,5,4,3,4,5,6,5,4,5,6,7,
0,2,1,0,1,2,3,2,1,2,3,4,3,2,3,4,5,4,3,4,5,6,5,4,5,6,
0,3,2,1,0,1,4,3,2,1,2,5,4,3,2,3,6,5,4,3,4,7,6,5,4,5,
0,4,3,2,1,0,5,4,3,2,1,6,5,4,3,2,7,6,5,4,3,8,7,6,5,4,
0,1,2,3,4,5,0,1,2,3,4,1,2,3,4,5,2,3,4,5,6,3,4,5,6,7,
0,2,1,2,3,4,1,0,1,2,3,2,1,2,3,4,3,2,3,4,5,4,3,4,5,6,
0,3,2,1,2,3,2,1,0,1,2,3,2,1,2,3,4,3,2,3,4,5,4,3,4,5,
0,4,3,2,1,2,3,2,1,0,1,4,3,2,1,2,5,4,3,2,3,6,5,4,3,4,
0,5,4,3,2,1,4,3,2,1,0,5,4,3,2,1,6,5,4,3,2,7,6,5,4,3,
0,2,3,4,5,6,1,2,3,4,5,0,1,2,3,4,1,2,3,4,5,2,3,4,5,6,
0,3,2,3,4,5,2,1,2,3,4,1,0,1,2,3,2,1,2,3,4,3,2,3,4,5,
0,4,3,2,3,4,3,2,1,2,3,2,1,0,1,2,3,2,1,2,3,4,3,2,3,4,
0,5,4,3,2,3,4,3,2,1,2,3,2,1,0,1,4,3,2,1,2,5,4,3,2,3,
0,6,5,4,3,2,5,4,3,2,1,4,3,2,1,0,5,4,3,2,1,6,5,4,3,2,
0,3,4,5,6,7,2,3,4,5,6,1,2,3,4,5,0,1,2,3,4,1,2,3,4,5,
0,4,3,4,5,6,3,2,3,4,5,2,1,2,3,4,1,0,1,2,3,2,1,2,3,4,
0,5,4,3,4,5,4,3,2,3,4,3,2,1,2,3,2,1,0,1,2,3,2,1,2,3,
0,6,5,4,3,4,5,4,3,2,3,4,3,2,1,2,3,2,1,0,1,4,3,2,1,2,
0,7,6,5,4,3,6,5,4,3,2,5,4,3,2,1,4,3,2,1,0,5,4,3,2,1,
0,4,5,6,7,8,3,4,5,6,7,2,3,4,5,6,1,2,3,4,5,0,1,2,3,4,
0,5,4,5,6,7,4,3,4,5,6,3,2,3,4,5,2,1,2,3,4,1,0,1,2,3,
0,6,5,4,5,6,5,4,3,4,5,4,3,2,3,4,3,2,1,2,3,2,1,0,1,2,
0,7,6,5,4,5,6,5,4,3,4,5,4,3,2,3,4,3,2,1,2,3,2,1,0,1,
0,8,7,6,5,4,7,6,5,4,3,6,5,4,3,2,5,4,3,2,1,4,3,2,1,0
};

const int quai[4]={1,14,18,25};
const int mx=3,my=2;
const int cx=5,cy=10;
const int sx[4]={0,3,9,10};
const int sy[4]={0,4,9,10};
const int n=4;				// 共有4个特殊点 
const int maxm=1200;		// 背包容量 
const int coins=10000;		// 起始总资产 
const int base=1000;		// 挖矿每日收益 
const int date=30;			// 截止日期 
int costx[32][4][4];		// 第d天从第i点走到第j点所消耗的水 
int costy[32][4][4];		// 第d天从第i点走到第j点所消耗的食物 
int days[32][4][4];			// 第d天从第i点走到第j点所需要的实际天数 
int ans=0;					// ans用来存储剩余资金量，最后结果即本题答案 
int rec[32];				// 枚举不同情况下每天所在位置，会不断更新 

// 每一天所到达的点的标记-1代表此时处于最短路径上的某个普通点或此时已经到达终点
// 其余的数字 分别代表当前玩家位于对应的特殊点 对应情况如qua数组所示 
int act[32];				// 枚举不同情况下每天的行动，会不断更新 
// 每一天的特殊行动情况 2代表挖矿 1代表于矿山停止行动 0代表在村庄购买 
int ansx[32];				// ansx与ansact是最优解路径和最优解路径上的行为 
int ansact[32];
int ansg,ansh;				// ansg和ansh是最优解对应的初始水和食物的资源量 

int g,h;

double e[4]={0};
double p[4]={0,17.0/30,1.0/3,1.0/10};
double pi[10];

int main()
{
//	srand((unsigned)time(NULL));
//	int count3=0;
//	for(int i=1;i<=30;i++){
//		if(count3==3){
//			wea[i]=rand()%2+1;
//		}else{
//			wea[i]=rand()%3+1;
//			if(wea[i]==3){
//				count3++;
//			}
//		}
//	}
	
	for(int i=1;i<=30;i++){
		cout<<wea[i]<<" ";
	}
	
	
	for(int i=1;i<=2;i++){
		e[1]=e[1]+p[i]*(2*sx[i]*cx+2*sy[i]*cy);
	}
	
	for(int i=1;i<=3;i++){
		e[3]=e[3]+p[i]*(2*sx[i]*cx+2*sy[i]*cy);
	} 
	
	double ew=3*3*p[1]+3*9*p[2]+3*10*p[3],ef=3*4*p[1]+3*9*p[2]+3*10*p[3];
	for(int i=1;i<=3;i++){
		for(int j=1;j<=3;j++){
			if(j!=3){
				pi[(i-1)*3+j]=(base-sx[i]*cx-sy[i]*cy-2*sx[j]*cx-2*sy[j]*cy)*p[i]*p[j];
			}else{
				pi[(i-1)*3+j]=(base-sx[i]*cx-sy[i]*cy-(2*3*cx+2*4*cy)*p[1]-(2*9*cx+2*9*cy)*p[2])*p[i]*p[j];
			}
		}
	}
	for(int i=1;i<=9;i++){
		e[2]=e[2]+pi[i];
	}
	
	int tmax=30,nd=3,T0=tmax-dis[1][quai[2]]-dis[quai[2]][n]-nd;
	int bw=178,bf=333;
	for(int d=0;d<date;d++)
		for(int i=0;i<n;i++)
			for(int j=0;j<n;j++)
				if(f[qua[i]][qua[j]]){
					int now=0,count=0,sumx=0,sumy=0;
					while(count<dist[i][j]){
						if(wea[now+d]!=3){
							count++;
							sumx+=2*sx[wea[now+d]];
							sumy+=2*sy[wea[now+d]];
						}else{
							sumx+=sx[wea[now+d]];
							sumy+=sy[wea[now+d]];
						}
						now++;
						if(now+d>=date)
							break;
					}
					if(count<dist[i][j]){
						sumx=sumy=20000;
						now=30;
					}
					costx[d][i][j]=sumx;
					costy[d][i][j]=sumy;
					days[d][i][j]=now;
				}
	double T0_1=min((bw-costx[0][0][1]-(dis[quai[1]-1][quai[2]]+dis[quai[2]][25])*(2*3*p[1]+2*9*p[2]))/ew,
	(bf-costy[0][0][1]-(dis[quai[1]-1][quai[2]]+dis[quai[2]][25])*(2*4*p[1]+2*9*p[2]))/ef);
	
	
	int i=1,t_m=0;
	double maxx=-99999999;
	while(i<=T0-T0_1){
		if(i*e[2]>e[1]*(dist[0][1]+dist[1][2]-dist[0][2])+2*i*e[3]&&mx*(bw-costx[0][0][1]+
		i*ew)+my*(bf-costy[0][0][1]+i*ef)<=maxm){
			if(i*e[2]-e[1]*(dist[0][1]+dist[1][2]-dist[0][2])-2*i*e[3]>maxx){
				maxx=i*e[2]-e[1]*(dist[0][1]+dist[1][2]-dist[0][2])-2*i*e[3];
				t_m=i;
			}
		} 
		i=i+1;
	} 
	
	
	int dayss=0;
	int nc=coins;
	nc=nc-cx*bw-cy*bf;
	cout<<nc<<"\n";
	bw=bw-costx[0][0][1];
	bf=bf-costy[0][0][1];
	dayss=dayss+days[0][0][1];
	
	bw=bw+t_m*ew;
	bf=bf+t_m*ef;
	cout<<t_m*ew<<" "<<t_m*ef<<endl;
	
	nc=nc-t_m*ew*2*cx-t_m*ef*2*cy;
	
	bw=bw-costx[dayss][1][2];
	bf=bf-costy[dayss][1][2];
	dayss=dayss+days[dayss][1][2];
	int k=0;
	for(;;k++){
		bw=bw-3*sx[wea[dayss+k]];
		bf=bf-3*sy[wea[dayss+k]];
		
		if(date-k<=days[dayss+k][2][3]||bw<=2*9*dist[2][3]||bf<=2*9*dist[2][3]){
			bw=bw+3*sx[wea[dayss+k]];
			bf=bf+3*sy[wea[dayss+k]];
			break;
		}
	}
	k=k-1;
	nc=nc+base*k;
	cout<<bw<<" "<<bf<<endl;
	cout<<k<<" "<<nc<<" "<<endl;
}




