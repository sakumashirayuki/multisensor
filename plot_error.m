function plot_error(error_array)
%输入error_array应为1*迭代次数
figure;
[col,row] = size(error_array);
%绘图坐标x
x = 1:row;
plot(x,error_array);
end