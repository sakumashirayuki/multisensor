function plot_error(error_array)
%����error_arrayӦΪ1*��������
figure;
[col,row] = size(error_array);
%��ͼ����x
x = 1:row;
plot(x,error_array);
end