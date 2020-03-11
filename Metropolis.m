function [Rn,Tn,en,Yn,Temperaturen]=Metropolis(Temp,Disturb,Temperature,rate)
%输入形式为R,T,Y,e
%Temperature为退火温度
%只有在接受新解时进行降温
%输出新温度
dC = Disturb{4} - Temp{4};
if dC < 0 %如果目标函数减小，接受该变换
    Rn = Disturb{1};
    Tn = Disturb{2};
    Yn = Disturb{3};
    en = Disturb{4};
    Temperaturen = Temperature*rate;
elseif exp(-dC/Temperature) >= rand %以exp(-dC/Temperature)概率接受新解
        Rn = Disturb{1};
        Tn = Disturb{2};
        Yn = Disturb{3};
        en = Disturb{4};
        Temperaturen = Temperature*rate;
else %保持旧解
    Rn = Temp{1};
    Tn = Temp{2};
    Yn = Temp{3};
    en = Temp{4};    
    Temperaturen = Temperature;
end
end