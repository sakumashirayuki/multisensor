% ÓÃÓÚreg3DµÄ²âÊÔ
file1 = 'bun045.asc';
file2 = 'bun000.asc';
data1 = ascread(file1);%40097points
data2 = ascread(file2);%40256points
%[s,R,T,e,it] = reg3D('bun045.asc','bun000.asc')
[s,R,T,e,it] = reg3D(data1,data2)
