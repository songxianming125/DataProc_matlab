function isSuccess=setZDrange(varargin)
global  zdTstart zdTend handles
isSuccess=0;
if nargin>=2
    if ~isempty(varargin{1}) && isnumeric(varargin{1})
         zdTstart=varargin{1};
    end
    
    if ~isempty(varargin{2}) && isnumeric(varargin{2})
         zdTend=varargin{2};
    end
    
    
    if ~isempty(zdTstart) && ~isempty(zdTend)
        if  zdTend>zdTstart
            isSuccess=1;
        elseif  zdTend<zdTstart
            Tend=zdTend;
            zdTend=zdTstart;
            zdTstart=Tend;
            isSuccess=1;
        end
    end
else
    if strmatch(get(handles.R1,'String'),'editmode')
        zdTend=str2double(get(handles.xRight,'String'));
        zdTstart=str2double(get(handles.xLeft,'String'));
    elseif strmatch(get(handles.R1,'String'),'popupmenu')
        Lstring=get(handles.xLeft,'string');
        Rstring=get(handles.xRight,'string');
        zdTend=str2double(Rstring{get(handles.xRight,'value')});
        zdTstart=str2double(Lstring{get(handles.xLeft,'value')});
    end
    if ~isempty(zdTstart) && ~isempty(zdTend)
        if  zdTend>zdTstart
            isSuccess=1;
        elseif  zdTend<zdTstart
            Tend=zdTend;
            zdTend=zdTstart;
            zdTstart=Tend;
            isSuccess=1;
        end
    end
    
end