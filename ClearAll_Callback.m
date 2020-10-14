function ClearAll_Callback(hObject, eventdata, handles)
global MyPicStruct PicDescription MyCurves HeightNumber  WidthNumber
global hfig NumShot
% tic
% profile on

%%
% rootDP=getDProot;
% temp=[rootDP filesep 'temp'];
% cd(temp);
% delete *.*
% cd(rootDP)

MyPath=[getDProot('configuration') filesep];


MyCurveList=get(handles.lbCurves,'String');

% aging and backup the cfg file
for CurrentConfiguration=1:3
    FileNameSource=strcat(num2str(CurrentConfiguration),'Last.mat');
    cfgFileSource=strcat(MyPath,FileNameSource);
    FileNameDestination=strcat(num2str(CurrentConfiguration+1),'Last.mat');
    cfgFileDestination=strcat(MyPath,FileNameDestination);
    if exist(cfgFileSource,'file')
        copyfile(cfgFileSource,cfgFileDestination,'f')
    end
end



FileNameSource=strcat(num2str(1),'Last.mat');
cfgFileSource=strcat(MyPath,FileNameSource);
save(cfgFileSource, 'MyCurveList','MyPicStruct','PicDescription','HeightNumber','WidthNumber')


%%


set(handles.lbCurves,'UserData',[]);%
set(handles.lbWarning,'String',[]);%
set(handles.lbCurves,'String',[]);%
set(handles.lbChannels,'String',[]);%clear
set(handles.lbChannels,'UserData',[]);
set(handles.DrawCurves,'UserData',[]);
set(handles.DrawCurves,'Enable','off');
set(handles.UpdateShot,'Enable','off');
MyCurves=[];
PicDescription=[];
hfig=[];
%MyPicStruct=[];
HeightNumber=[];
WidthNumber=[];
NumShot=0;
set(handles.LayoutMode,'value',1) % last for comparieng ;defining the mode from 0 to 7




k=get(gcf,'currentkey');
if strmatch('f6',k,'exact');
    ClearFigureReserveSome
end
hLine=findobj(handles.aBrowser,'type','line');
if ~isempty(hLine)
    if ishandle(hLine)
        delete(hLine);
    end
end
%evalin('base','clear all; clc;');
evalin('base','clc;');

MyPicStruct=View2Struct(handles);
figure(findobj('type','figure','Tag','DP'));
