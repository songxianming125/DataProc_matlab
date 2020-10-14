function y=SetLabelBar(MyPicStruct,isHorizontal,Name,index)
global hfig
% y=annotation(hfig,'textbox',[0.1 0.1 0.1 0.1],'EraseMode','xor','BackgroundColor','w');

y=[];
hLabel=axes('Units','pixels','Tag',Name,'Position',[1 1 1 1]);%,'replace'
setappdata(hLabel,'isHorizontal',isHorizontal);
X=[0 1 1 0];
Y=[0 0 1 1];
if mod(index,2)==1
    myColor=MyPicStruct.LeftShadowColor;
else
    myColor=MyPicStruct.RightShadowColor;
end

%[cm,cn]=size(myColor);
if length(myColor)>1
    format='%e';
    [C(1:3),count,errs]=sscanf(myColor,format);
else
    C=myColor;
end
%C=myColor;


if MyPicStruct.MyTransparencyValue>0.9
    hp=patch(X,Y,C,'EraseMode','xor');
else
    hp=patch(X,Y,C);
    alpha(MyPicStruct.MyTransparencyValue);% for print only, xor not wysiwyg
end

set(hp,'Tag',strcat(Name,'p'));


set(hLabel,'Color','none','XColor','w','YColor','w','XTick',[],'YTick',[]);
box on

y=hLabel;


return
PicPos=get(hfig,'Position');
% annotation(hfig,'textbox',[myLeft/PicPos(3) BkBottom/PicPos(4) myWidth/PicPos(3) BkHeight/PicPos(4)],'FaceAlpha',ShadowTransparencyValue,'BackgroundColor',ShadowColor,'EdgeColor','none')
annotation(hfig,'textbox',[myLeft/PicPos(3) BkBottom/PicPos(4) myWidth/PicPos(3) BkHeight/PicPos(4)],'EraseMode','xor','BackgroundColor','w')
s=0;

