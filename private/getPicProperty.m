function [n,ha,MyPicStruct,hXLabel,PicDescription,HeightNumber,M,figLBWH,BkLeft,BkBottom,BkWidth,BkHeight]=getPicProperty(hfig);
% global ha MyPicStruct PicDescription HeightNumber


n=[];
hXLabel=[];
M=[];
figLBWH=[];
BkLeft=[];
BkBottom=[];
BkWidth=[];
BkHeight=[];

MyPicStruct=getappdata(hfig,'MyPicStruct');
PicDescription=getappdata(hfig,'PicDescription');
HeightNumber=getappdata(hfig,'HeightNumber');
ha=getappdata(hfig,'ha');
% 


if isempty(MyPicStruct) || isempty(PicDescription) || isempty(HeightNumber)
%     msgbox('structure is empty!')
    return
end




M=length(HeightNumber);
n=length(PicDescription);

%an other way to find hXLabel
L={PicDescription(1:n).Location};
L1=cell2mat(L);
hXLabel=ha(end);%for all

figLBWH=get(hfig,'position');%get the size of the picture


BkLeft=figLBWH(3)*MyPicStruct.myleft;
BkBottom=32+figLBWH(4)*MyPicStruct.mybottom;
BkHeight=figLBWH(4)*MyPicStruct.myheight;
% if MyPicStruct.Oscillograph==1;
%     BkWidth=figLBWH(3)*(MyPicStruct.mywidth-0.1);
% else
     BkWidth=figLBWH(3)*MyPicStruct.mywidth;
% end
