%���㳣������
clear
%[X1,Z1] = meshgrid(1.1:.1:2.1,0.8:-0.1:-0.8);
% [X1,Z1] = meshgrid(1.0:.02:2.4,1.5:-0.02:-1.5);
[X1,Z1] = meshgrid(0.6:.02:2.4,1.5:-0.02:-1.5);
%��ʼ��������Ȧϵͳ
%������Ȧ����11�飨��������ֵ�Ĳ�ͬ���ۣ�,������1=OH, 2=VF, 3=RF, 4=uMP1, 5=uMP2, 6=uMP3, 7=uMC,
%8=lMP1, 9=lMP2, 10=lMP3, 11=lMC,
CoilType=11;%������Ȧ
%I2(1:CoilType)=[0 0.8 0 1 1 0 0 0 0 0 0];%�����ĵ���ֵ
for i=1:CoilType;
    [X2,Z2,NCoil]=SetSourceXZ(i);
    F(i)={MMutInductance(X1,Z1,X2,Z2,NCoil)};  %cell array
end
clear X2 Z2 i CoilType NCoil
save D:\2A\myLibFluxCoef

