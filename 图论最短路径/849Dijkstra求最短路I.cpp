#include <iostream>
#include <cstring>
#include <algorithm>

using namespace std;

const int N = 505, INF = 0x3f3f3f3f;

int n, m;
int g[N][N], dist[N], d[N];
bool st[N];

int dijkstra()
{
    memset(dist, 0x3f, sizeof dist);
    dist[1] = 0; // dist数组代表1号点到其它各点的距离，1号点到1号点的距离初始化为0

    for (int i = 1; i <= n; i++)
    {
        int t = -1;
        for (int j = 1; j <= n; j++) // 找中转点t
            if (!st[j] && (t == -1 || dist[t] > dist[j]))
                t = j;

        for (int j = 1; j <= n; j++) // 利用中转点更新源点到其它点的距离
            if (dist[j] > dist[t] + g[t][j])
            {
                dist[j] = dist[t] + g[t][j];
                d[j] = t;
            }

        st[t] = true;
    }
    return dist[n] == INF ? -1 : dist[n];
}

void digui(int i)
{
    if (d[i])
    {
        digui(d[i]);
        printf("%d ", d[i]);
    }
}

int main()
{
    scanf("%d%d", &n, &m);
    memset(g, 0x3f, sizeof g); // 邻接矩阵初始化为无穷大

    int a, b, c;
    while (m--) // 读入邻接矩阵
    {
        scanf("%d%d%d", &a, &b, &c);
        g[a][b] = min(g[a][b], c);
    }

    printf("%d\n", dijkstra());
    digui(n);

    return 0;
}