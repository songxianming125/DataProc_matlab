function [y,x,varargout]=GetNewCurve4Add(CurrentShot,CurrentChannel,DataFlag,varargin)
%DataFlag  0=HL2A   ;1=HL2A  ;3=Tore Supra Data
%[y,x,CurrentSysName,Unit]=GetNewCurve4Add(CurrentShot,CurrentChannel,DataFlag,CurrentDataFile,CurrentDasInf,CurrentSysName);


y=[];
x=[];
z=[];
CurrentSysName=[];
Unit=[];
CurrentChannels=CurrentChannel;

switch DataFlag
    
    case 0
        %ip,dv,dh. special process for composite channel
        switch lower(CurrentChannel(1))
            %control the output mode from smoothstatus
            % @=smooth !=zerodrift, -=baseline _=fft
            case {'@','!','-','_'} 
                switch nargout
                    case 4
                        [y,x,CurrentSysName,Unit]=GetCurveByFormula(CurrentShot,CurrentChannel,'',varargin{:});
                    case 5
                        [y,x,CurrentSysName,Unit,CurrentChannels]=GetCurveByFormula(CurrentShot,CurrentChannel,'',varargin{:});
                    case 6
                        [y,x,CurrentSysName,Unit,CurrentChannels,z]=GetCurveByFormula(CurrentShot,CurrentChannel,'',varargin{:});
                end
            case '$'
                CurrentChannel=strtok(CurrentChannel,'$');
                j=strfind(CurrentChannel,':');
                %two way to input the curve
                if j %for two variable case
                    MyX=CurrentChannel(1:j-1);
                    x=evalin('base',MyX);
                    MyY=CurrentChannel(j+1:length(CurrentChannel));
                    y=evalin('base',MyY);
                else %for one variable case
                    myVar=CurrentChannel;
                    MyXY=evalin('base',myVar);
                    x=MyXY(:,1);
                    [m1,n1]=size(MyXY);
                    y=MyXY(:,2:n1);
                end
                switch nargout
                    case 3
                        varargout{1}='bas';
                    case 4
                        varargout{1}='bas';
                        varargout{2}='au';
                end%switch
            otherwise
                if length(varargin)==2
                    [y,x,CurrentSysName,Unit,CurrentChannels]=hl2adb(CurrentShot,CurrentChannel,'','','','',varargin{1},varargin{2});
                elseif length(varargin)==3
                    [y,x,CurrentSysName,Unit,CurrentChannels]=hl2adb(CurrentShot,CurrentChannel,'','','',varargin{3});
                else
                    [y,x,CurrentSysName,Unit,CurrentChannels]=hl2adb(CurrentShot,CurrentChannel);
                end
                switch nargout
                    case 3
                        varargout{1}=CurrentSysName;
                    case 4
                        varargout{1}=CurrentSysName;
                        varargout{2}=Unit;
                    case 5
                        varargout{1}=CurrentSysName;
                        varargout{2}=Unit;
                        varargout{3}=CurrentChannels;
                end%switch
        end
    case 1
        
        
        switch lower(CurrentChannel(1))
            case {'@','!','-','_'} 
                [y,x,CurrentSysName,Unit,CurrentChannels,z]=GetCurveByFormula(CurrentShot,CurrentChannel,'',varargin{:});
            case '#'%browser vector curve
                    [y,x,CurrentSysName,Unit]=GetCurveFromVector(CurrentShot,CurrentChannel);
            otherwise
                    [y,x,CurrentSysName,Unit]=hl2adb(CurrentShot,CurrentChannel,'','','','',varargin{1},varargin{2});
        end
                    
    case 3
        [y,x]=hl2adb(CurrentShot,CurrentChannel,'','','','',varargin{1},varargin{2});
                    
    case 2
        
        if lower(CurrentChannel(1:2))=='da'
            %??? check channel
            y=evalin('base',CurrentChannel);
            if isempty(y)
                warnstr=strcat(num2str(CurrentShot),'/',CurrentChannels,' is not existed');
                warndlg(warnstr)
            return
        end
            MyX='data.gene.temps';
            x=evalin('base',MyX);
        elseif lower(CurrentChannel(1:2))=='qp'
            %temp take data from workspace
            y=evalin('base',CurrentChannel);
            if isempty(y)
                warnstr=strcat(num2str(CurrentShot),'/',CurrentChannels,' is not existed');
                warndlg(warnstr);
                return
            end
            MyX='t';
            x=evalin('base',MyX);

        else
            [y,x]=tsbase(CurrentShot,CurrentChannel);
            if isempty(y)
                SetCurrentChannel=strcat('APOLO;',CurrentChannel,';VALEURS');
                v=tsmat(CurrentShot,SetCurrentChannel);
                if ~isempty(v)
                    x=v(:,1);
                    y=v(:,2);
                end
            end
    
            if upper(CurrentChannel(1:2))=='GE'
                x=getRightTime(CurrentShot);
            end
        end
    if isempty(y)
        myVar=CurrentChannel;
        MyX=strcat(myVar,'(:,1)');
        x=evalin('base',MyX);
        MyY=strcat(myVar,'(:,2)');
        y=evalin('base',MyY);
    end
end
%% out
switch nargout
    case 3
        varargout{1}=CurrentSysName;
    case 4
        varargout{1}=CurrentSysName;
        varargout{2}=Unit;
    case 5
        varargout{1}=CurrentSysName;
        varargout{2}=Unit;
        varargout{3}=CurrentChannels;
    case 6
        varargout{1}=CurrentSysName;
        varargout{2}=Unit;
        varargout{3}=CurrentChannels;
        varargout{4}=z;
end%switch
end







