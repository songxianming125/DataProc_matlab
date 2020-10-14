function s=SetFigureProperty(hObject, eventdata,handles);
%%%********************************************************%%%
%%%       This program is to Set the property of figure   %%%
%%%    such as floating mode, gap mode, legend mode       %%%
%%%      Developed by Song xianming 2008/08/15/            %%%
%%%********************************************************%%%
%%%********************************************************%%%
%%%********************************************************%%%
%%%********************************************************%%%
global hfig MyPicStruct PicDescription
s=0;%not ok
dlg_title = 'Set Figure Property';
prompt = {'Grid on or off','0=Legend 1=YLabel 2=text','0=exp 1=no exp','Set the digital number','0=no gap 1=gap','YTickNum 3 or 5','none tex latex'};
def   = {MyPicStruct.GridMode,num2str(MyPicStruct.LegendYLabelMode),num2str(MyPicStruct.FloatingMode),num2str(MyPicStruct.RightDigit),num2str(MyPicStruct.GapMode),num2str(MyPicStruct.YTickNum),MyPicStruct.Interpreter};
num_lines= 1;
answer  = inputdlg(prompt,dlg_title,num_lines,def);
if isempty(answer)
    ShowWarning(0,'no property change',handles)
    return
end
MyPicStruct.GridMode=answer{1};
MyPicStruct.LegendYLabelMode=str2num(answer{2});
MyPicStruct.FloatingMode=str2num(answer{3});
MyPicStruct.RightDigit=str2num(answer{4});
MyPicStruct.GapMode=str2num(answer{5});
MyPicStruct.YTickNum=str2num(answer{6});
MyPicStruct.Interpreter=answer{7};
MyPicStruct.Modified=0;

% PicDescription=[];
DrawCurves_Callback(hfig, eventdata, handles)
s=1;%ok