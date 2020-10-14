
function [code,machinenumber]=registerdlg(defUser,defPsw)
Color = get(0,'DefaultUicontrolBackgroundcolor');
Height = 9.5;
Title = 'register';
Pass = 0;
 set(0,'Units','characters')
% set(0,'Units','pixels')
Screen = get(0,'screensize');
Position = [Screen(3)/2-17.5 Screen(4)/2-4.75 43 Height];
set(0,'Units','pixels')

% Create the GUI
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

% Texts
gui.login_text = uicontrol(gui.main,'Style','text','FontSize',8,'HorizontalAlign','left','Units','characters','String','0:hl2a,1:localdas,2:exl50,3:east,4:hl2m','Position',[1 7.65 40 1]);
gui.password_text = uicontrol(gui.main,'Style','text','FontSize',8,'HorizontalAlign','left','Units','characters','String','register code','Position',[1 4.15 40 1]);
% 0=hl2a,1=localdas,2=exl50,3=east,4=hl2m
% Edits
gui.edit1 = uicontrol(gui.main,'Style','popupmenu','FontSize',8,'HorizontalAlign','left','BackgroundColor','white','Units','characters','String',defUser,'Position',[1 6.02 40 1.7]);
set(gui.edit1,'string', {'0','1','2','3','4'});
gui.edit2 = uicontrol(gui.main,'Style','edit','FontSize',8,'HorizontalAlign','left','BackgroundColor','white','Units','characters','String','','Position',[1 2.52 40 1.7],'KeyPressFcn',{@KeyPress_Function,gui.main},'Userdata','');

SizePass = size(defPsw); % Find the number of asterixes
if SizePass(2) > 0
    asterix(1,1:SizePass(2)) = '*'; % Create a string of asterixes the same size as the password
    set(gui.edit2,'String',asterix) % Set the text in the password edit box to the asterix string
    set(gui.edit2,'UserData',defPsw) % Set the text in the password edit box to the asterix string
end
% Buttons
gui.OK = uicontrol(gui.main,'Style','push','FontSize',8,'Units','characters','String','OK','Position',[12 .2 10 1.7],'Callback',{@OK,gui.main});
gui.Cancel = uicontrol(gui.main,'Style','push','FontSize',8,'Units','characters','String','Cancel','Position',[23 .2 10 1.7],'Callback',{@Cancel,gui.main});

setappdata(0,'logindlg',gui) % Save handle data
setappdata(gui.main,'Check',0) % Error check setup. If Check remains 0 an empty cell array will be returned

if Pass == 0
    uicontrol(gui.edit1) % Make the first edit box active
else
    uicontrol(gui.edit2)  % Make the second edit box active if the first isn't present
end

% Pause the GUI and wait for a button to be pressed
uiwait(gui.main)

Check = getappdata(gui.main,'Check'); % Check to see if a button was pressed

% Format output
if Check == 1
    code = get(gui.edit1,'value')-1;  % base from 0
    machinenumber = get(gui.edit2,'Userdata');
else % If OK wasn't pressed output nothing
    code = [];
    machinenumber = [];
end

delete(gui.main) % Close the GUI
setappdata(0,'logindlg',[]) % Erase handles from memory

%% Hide Password
function KeyPress_Function(h,eventdata,fig)
% Function to replace all characters in the password edit box with
% asterixes
password = get(h,'Userdata');
key = get(fig,'currentkey');

switch key
    case 'backspace'
        password = password(1:end-1); % Delete the last character in the password
    case 'return'  % This cannot be done through callback without making tab to the same thing
        gui = getappdata(0,'logindlg');
        OK([],[],gui.main);
    case 'tab'  % Avoid tab triggering the OK button
        gui = getappdata(0,'logindlg');
        uicontrol(gui.OK);
    otherwise
        password = [password get(fig,'currentcharacter')]; % Add the typed character to the password
end

SizePass = size(password); % Find the number of asterixes
if SizePass(2) > 0
    asterix(1,1:SizePass(2)) = '*'; % Create a string of asterixes the same size as the password
    set(h,'String',asterix) % Set the text in the password edit box to the asterix string
else
    set(h,'String','')
end

set(h,'Userdata',password) % Store the password in its current state

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