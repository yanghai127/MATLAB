#include <iostream>
using namespace std;

const int N = 1e6 + 10;
int q[N];

int main()
{
    int m;
    cout << "请输入当前车辆数：";
    cin >> m;
    double p = m / 3600.0;
    cout << "概率：" << p << endl;
    int ok = 5;
    double zwait = 0;
    while (ok--)
    {
        int T = 0, t = -1, count = 0, wait = 0, jj = 0;
        int hh = 0, tt = -1;
        while (hh <= tt || T <= 3600)
        {
            // 判断是否入队
            if (T <= 3600)
            {
                double yyds = rand() % 1000 / 1000.0;
                if (yyds <= p)
                {
                    cout << yyds << endl;
                    if (tt - hh <= 350)
                    {
                        q[++tt] = T;
                        count++;
                    }
                    else
                    {
                        jj++;
                    }
                }
            }
            // 时间++
            T++, t++;
            // 判断是否出队
            if (!(t % 90))
            {
                wait += T - q[hh];
                hh++; // 出队
            }
        }
        zwait += wait / 60.0 / count;
        // cout << "拒绝数量：" << jj << endl;
        // cout << "车辆数：" << count << endl;
    }
    cout << "等待时间：" << zwait / 5 << endl;
    return 0;
}