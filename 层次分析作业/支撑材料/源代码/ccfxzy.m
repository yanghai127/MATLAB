%% 层次分析作业

disp('请输入判断矩阵A：');
A = input('A=');
n = length(A);
fprintf('\n');

ok = 1;
for i = 1:n - 1
    for j = i + 1
        if A(i, j) * A(j, i) ~= 1
            ok = 0;
            break;
        end
    end
    if ~ok
        break;
    end
end

if ok
    disp('A是正互反矩阵');
    fprintf('\n');
else
    disp('A不是正互反矩阵');
    fprintf('\n');
end

% 算数平均法求权重
Sum_A = sum(A);
SUM_A = repmat(Sum_A, n, 1);
Stand_A = A ./ SUM_A;

disp('算术平均法求权重的结果为：');
disp(sum(Stand_A, 2) ./ n);

% 几何平均法求权重
Prduct_A = prod(A, 2);
Prduct_n_A = Prduct_A .^ (1 / n);
disp('几何平均法求权重的结果为：');
disp(Prduct_n_A ./ sum(Prduct_n_A));

% 特征值法求权重
[V, D] = eig(A);
eig_max = max(D(:));
disp('最大特征值为：');
disp(eig_max);

disp('最大特征值对应的权重向量为：');
[r, c] = find(D == eig_max, 1);
disp(V(:, c));

disp('特征值求权重的结果为：');
disp(V(:, c) ./ sum(V(:, c)));  % 归一化
RI = [0 0.0001 0.52 0.89 1.12 1.26 1.36 1.41 1.46 1.49 1.52 1.54 1.56 1.58 1.59];
CI = (eig_max - n) ./ (n - 1);
CR = CI / RI(1, n);

disp('一致性比例CR：');
disp(CR);

if CR<0.10
    disp('CR<0.10，判断矩阵A的一致性可以接受');
else
    disp('CR >= 0.10，判断矩阵A需要修改');
end

