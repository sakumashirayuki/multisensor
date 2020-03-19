function reconstruction(point_out)
tri_out = delaunay(point_out(:,1),point_out(:,2),point_out(:,3));
% tri_in  = delaunay(point_in(:,1),point_in(:,2),point_in(:,3));
qm_out  = trisurf(tri_out,point_out(:,1),point_out(:,2),point_out(:,3),'LineStyle','none');
hold on;
material shiny  % dull shiny
colormap([0.5 0.5 0.5]);    %��ɫ   bone ��ɫ���ɫ    cool ���Ũ��ɫ  copper ��ͭɫ��Ũ��ɫ  flag ������ڽ���  gray �Ҷ�  hot �ں�ư�  hsv ����ɫ jet ��ͷ��β�ı���ɫ pink �ۺ�ɫprism ����ɫ
alpha(qm_out,0.25);%͸����
light('position',[0 -10 1.5],'style','infinite')   %'local' 'infinite'
lighting phong;  % flat gouraud phong none