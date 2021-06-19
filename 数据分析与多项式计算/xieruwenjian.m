%%输出到文件
data=[5 1 1;3 7 4];
[row,col]=size(data); %求矩阵的行数和列数
%打开文件，如果有直接打开，如果没有就会新创建一个
%如果没有指定路径，那么为当前matlab路径
fid=fopen('test.txt','wt');   %可写
for i=1:row
    for j=1:col
        fprintf(fid,'%d',data(i,j));
    end
    fprintf(fid,'\n');
end
fprintf(fid,'Hello world!\n');
fprintf(fid,'%x',hex2dec('ABCD'));
fclose(fid); %别忘记关闭打开的文件