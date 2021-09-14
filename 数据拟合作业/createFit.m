function [fitresult, gof] = createFit(year, population)

% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( year, population );

% Set up fittype and options.
ft = fittype( 'exp2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Normalize = 'on';
opts.StartPoint = [0 0.00458525437833502 1.51042333121638e-194 0.227258507300303];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure( 'Name', '指数逼近(Exp2)' );
h = plot( fitresult, xData, yData , 'o');
legend( h, '原始数据点', '拟合曲线(Exp2)', 'Location', 'southeast');
% Label axes
xlabel('年份');
ylabel('人口数量(10^4)');
grid on


