function [BkLeft,BkBottom,BkWidth,BkHeight]=getAxesProperty(hfig)
% This program is developed by Dr.Song Xianming
% set the Axes property
% LBWH
%Southwestern Institute of Physics, China
%%
global  MyPicStruct
if isempty(MyPicStruct)
    MyPicStruct=MyPicInit;%init by file data
end
figLBWH=get(hfig,'position');%get the size of the picture
BkLeft=figLBWH(3)*MyPicStruct.myleft;
BkBottom=32+figLBWH(4)*MyPicStruct.mybottom;
BkHeight=figLBWH(4)*MyPicStruct.myheight;
BkWidth=figLBWH(3)*MyPicStruct.mywidth;
% end
%%