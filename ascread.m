function b = ascread(filename)      %read my file
format long;
fi = fopen(filename,'r');       %openfile  'r'读出参数
if fi < 0
  error(sprintf('File %s not found', filename))
end

templine = 1; %
a = sscanf(fgetl(fi), '%d');%%fgetl从已经打开的文件中读取一行，并且丢掉末尾的换行符。
templine = templine +1;

if length(a)==1
    points=a(1);
end

pointlist = zeros(3,points);

for vnum = 1 : points
  coord = sscanf(fgetl(fi), '%e %e %e');
  if length(coord) ~= 3
    errmsg = sprintf('Each vertex line must contain three coordinates (error on line %d)', templine);
    error(errmsg);
  end
  templine = templine +1;
  pointlist(:,vnum) = coord;
end
b = cell({points;pointlist});