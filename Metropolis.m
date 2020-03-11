function [Rn,Tn,en,Yn,Temperaturen]=Metropolis(Temp,Disturb,Temperature,rate)
%������ʽΪR,T,Y,e
%TemperatureΪ�˻��¶�
%ֻ���ڽ����½�ʱ���н���
%������¶�
dC = Disturb{4} - Temp{4};
if dC < 0 %���Ŀ�꺯����С�����ܸñ任
    Rn = Disturb{1};
    Tn = Disturb{2};
    Yn = Disturb{3};
    en = Disturb{4};
    Temperaturen = Temperature*rate;
elseif exp(-dC/Temperature) >= rand %��exp(-dC/Temperature)���ʽ����½�
        Rn = Disturb{1};
        Tn = Disturb{2};
        Yn = Disturb{3};
        en = Disturb{4};
        Temperaturen = Temperature*rate;
else %���־ɽ�
    Rn = Temp{1};
    Tn = Temp{2};
    Yn = Temp{3};
    en = Temp{4};    
    Temperaturen = Temperature;
end
end