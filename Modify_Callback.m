function Modify_Callback(hObject, eventdata, handles)
%songxm
%modify the important parameter



Color = get(0,'DefaultUicontrolBackgroundcolor');
Height = 9.5;
Title = 'Modify the property of DrawCurves';
Pass = 0;
set(0,'Units','characters')
Screen = get(0,'screensize');
Position = [Screen(3)/2-17.5 Screen(4)/2-4.75 65 Height];
set(0,'Units','pixels')
gui.main = dialog('HandleVisibility','on',...
    'IntegerHandle','off',...
    'Menubar','none',...
    'NumberTitle','off',...
    'Name','Login',...
    'Tag','logindlg',...
    'Color',Color,...
    'Units','characters',...
    'Userdata','logindlg',...
    'Position',Position);

% Set the title
set(gui.main,'Name',Title,'CloseRequestFcn',{@Cancel,gui.main},'KeyPressFcn',{@Escape,gui.main},'WindowStyle','normal')

gui.OK = uicontrol(gui.main,'Style','push','FontSize',8,'Units','characters','String','OK','Position',[12 .2 10 1.7],'Callback',{@OK,gui.main});
gui.Cancel = uicontrol(gui.main,'Style','push','FontSize',8,'Units','characters','String','Cancel','Position',[23 .2 10 1.7],'Callback',{@Cancel,gui.main});

gui.MyPicStruct = uicontrol(gui.main,'Style','push','FontSize',8,'Units','characters','String','MyPicStruct','Position',[1 3.2 30 1.7],'Callback',{@MyPicStructFcn,gui.main});
gui.PicDescription = uicontrol(gui.main,'Style','push','FontSize',8,'Units','characters','String','PicDescription','Position',[35 3.2 30 1.7],'Callback',{@PicDescriptionFcn,gui.main});
uiwait(gui.main)


delete(gui.main) % Close the GUI
setappdata(0,'logindlg',[]) % Erase handles from memory
%clear all
%i=1;

%% Cancel
function Cancel(h,eventdata,fig)
uiresume(fig)

%% OK
function OK(h,eventdata,fig)
% Set the check and resume
setappdata(fig,'Check',1)
uiresume(fig)

%% Escape
function Escape(h,eventdata,fig)
% Close the login if the escape button is pushed and neither edit box is
% active
key = get(fig,'currentkey');

if isempty(strfind(key,'escape')) == 0 && h == fig
    Cancel([],[],fig)
end

function MyPicStructFcn(h,eventdata,fig)
global MyPicStruct
assignin('base','MyPicStruct',MyPicStruct);

function PicDescriptionFcn(h,eventdata,fig)
global PicDescription
assignin('base','PicDescription',PicDescription);

