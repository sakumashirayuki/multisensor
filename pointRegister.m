function register_LA=pointRegister(data,R,T,method)
% output size is n-dimension * number of points
switch method
    case 'reg3D'
        %输入是n-dimension * number of points
        [~,rowL]=size(data);%rowL为点数
        Onerow = ones(1,rowL);
        register_LA = [R,T]*[data;Onerow];
    case 'icp_3dbasic'
        %输入是number of points*n-dimension
        data = data';
        [colL,~]=size(data);
        Onecol = ones(colL,1);
        register_LA = [data,Onecol]*[R';T'];
        %register_LA is number of points*n-dimension
        register_LA = register_LA';
    otherwise
        print('error');
end
end