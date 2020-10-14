function showFull(hObject, eventdata, handles)


hcfg=getappdata(gcf,'hcfg');
hCurves=hcfg.hCurves;
sBtn=hcfg.sBtn;
hfconfiguration=hcfg.hfconfiguration;
set(hCurves(:,:),{'visible'},{'on'})
set(sBtn(:),{'visible'},{'on'})
set(hcfg.hModify,'enable','on')

set(hfconfiguration,'Position',getappdata(hfconfiguration,'size2'))
