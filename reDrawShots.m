function s=reDrawShots(hObject, eventdata,handles)
global  PicDescription
% set the total shot number for comparing
% press enter in shot edit control
CancelMod([], eventdata, handles)
hcfg=getappdata(gcf,'hcfg');
hCurves=hcfg.hCurves;
PicDescription=getPicDescription(hCurves);
s=1;