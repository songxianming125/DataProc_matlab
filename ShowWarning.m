function ShowWarning(showmode,warnmessage,handles)
if showmode
    warnstr=getappdata(0,'MyErr');
    setappdata(0,'MyErr',[])
else
    warnstr=warnmessage;
end

if isempty(warnstr)
%     warnstr=strcat('no warning message');
    return
end
%display
                    
WarningString=get(handles.lbWarning,'String');


if isempty(WarningString)
    if iscell(warnstr)
        WarningString={warnstr{:}};
    else
        WarningString={warnstr};
    end
else
    if ~iscell(WarningString)
        WarningString={WarningString};
    end
    
    if iscell(warnstr)
        WarningString={WarningString{:},warnstr{:}};
    else
        WarningString(length(WarningString)+1)={warnstr};
    end
end

set(handles.lbWarning,'String',WarningString);
set(handles.lbWarning,'Value',length(WarningString));

