function [xNum,yNum,XStart,XStep,XEnd,YStart,YStep,YEnd]=getGridPara(nLevel)
%%
%       This program set the grid parameter                 
%       Developed by Song xianming 2013.11.16 
%
% input description
% nLevel=1 is the basic one
%
% alphaIndex  GS power index for get plasma current density
% X1 and Y1: grid coordinates for GS equation problem



%%

xNum=32*nLevel;
yNum=64*nLevel;
% %% 2M


% XStart=1.0;
% XStep=1.5/xNum;
% XEnd=2.5;
% YStart=1.4;
% YStep=-2.8/yNum;
% YEnd=-1.4;


%% 2A
XStart=1.18;
XEnd=2.08;
XStep=(XEnd-XStart)/xNum;

YStart=0.9;
YEnd=-0.9;
YStep=(YEnd-YStart)/yNum;


