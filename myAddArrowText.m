function s=myAddArrowText()
global hfig MyPicStruct
set(groot,'defaultLineLineWidth',3)

dlg_title = 'Add a Shadow';
prompt = {'x1','x2','y1','y2','LineSpec','text'};
def     = {num2str(MyPicStruct.xleft),num2str(MyPicStruct.xright),'0','0', '--ro','comment'};
num_lines= 1;
answer  = inputdlg(prompt,dlg_title,num_lines,def);

x1=str2double(answer{1});
x2=str2double(answer{2});
y1=str2double(answer{3});
y2=str2double(answer{4});


LineSpec=answer{5};
mycomment=answer{6};

hold on
plot([x1 x2],[y1 y2],LineSpec)


myArrowText=annotation(hfig,'textarrow',[0.3 0.3],[0.4 0.4],'String',mycomment);
% set(hshadow,'EdgeColor','none','BackgroundColor',ShadowColor,'FaceAlpha',ShadowTransparencyValue)%,'EraseMode ','xor')%,'FaceAlpha',ShadowTransparencyValue
s=0;


return

