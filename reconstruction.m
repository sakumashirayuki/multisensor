function reconstruction(point_out)
tri_out = delaunay(point_out(:,1),point_out(:,2),point_out(:,3));
% tri_in  = delaunay(point_in(:,1),point_in(:,2),point_in(:,3));
qm_out  = trisurf(tri_out,point_out(:,1),point_out(:,2),point_out(:,3),'LineStyle','none');
hold on;
material shiny  % dull shiny
colormap([0.5 0.5 0.5]);    %上色   bone 蓝色凋灰色    cool 青红浓淡色  copper 青铜色调浓淡色  flag 红白兰黑交错  gray 灰度  hot 黑红黄白  hsv 饱和色 jet 蓝头红尾的饱和色 pink 粉红色prism 光谱色
alpha(qm_out,0.25);%透明度
light('position',[0 -10 1.5],'style','infinite')   %'local' 'infinite'
lighting phong;  % flat gouraud phong none