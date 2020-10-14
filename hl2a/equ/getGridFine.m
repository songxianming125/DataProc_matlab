function [X1,Y1]=getGridFine
%%
%       This program set the zero dimension parameters of plasma                  
%       Developed by Song xianming 2013.11.16 
%
% input description
%
% alphaIndex  GS power index for get plasma current density
% X1 and Y1: grid coordinates for GS equation problem



%%
%%
[xNum,yNum,XStart,XStep,XEnd,YStart,YStep,YEnd]=getGridPara(4);
% [xNum,yNum,XStart,XStep,XEnd,YStart,YStep,YEnd]=getGridPara(16);
[X1,Y1] = meshgrid(XStart:XStep:XEnd,YStart:YStep:YEnd);  %field point

