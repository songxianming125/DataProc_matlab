function s=upload(x,y,varargin)
%% load the workspace t:y curve to DP
% developed by Dr. SONG Xianming
global   MyCurves handles
s=1;
if isstruct(handles) && ishandle(handles.DP)
    try
        
        signalName='y';
        Unit='au';
        TimeUnit='s';
        CurrentShot=0;%for uniform

        
        %% preparing the signal name and signal unit, time unit
        if nargin>=3
            CurrentChannel=varargin{1};
        end
        if nargin>=4
            Unit=varargin{2};
        end
        if nargin>=5
            TimeUnit=varargin{3};
        end
        
        
        
        
        MyCurveList=get(handles.lbCurves,'String');
        [m,n]=size(MyCurves);%
        CurrentChannelNum=n;
        
         
        if isempty(y)
            ShowWarning(CurrentShot,strcat('no curve/', myVar),handles)
            return
        end
        
        
        
        
        x=reshape(x,length(x),1);
        y=reshape(y,length(x),[]);
        
        
        
        
        
        
        [~,n1]=size(y);
        IndexStart=1;
        if n1>1
            IndexEnd=n1;
        else
            IndexEnd=1;
        end
        
        
        
        
        
        
        CurrentSysName='';
        Unit='au';
        NickName=CurrentChannel;
        
        for CurrentIndex=IndexStart:IndexEnd
            if IndexStart==IndexEnd
                nMyCurveList=strcat('00000',CurrentSysName,'\',CurrentChannel);
                %c=AddNewCurve(x(:,1),y(:,1),num2str(CurrentShot),NickName,Unit);
                c=AddNewCurve(x,y,num2str(CurrentShot),NickName,Unit);
            else
                nMyCurveList=strcat('00000',CurrentSysName,'\',CurrentChannel,'%',num2str(CurrentIndex));
                c=AddNewCurve(x(:,1),y(:,CurrentIndex),num2str(CurrentShot),strcat(NickName,'%',num2str(CurrentIndex)),Unit);
            end
            CurrentChannelNum=CurrentChannelNum+1;
            if CurrentChannelNum>1
                MyCurves(CurrentChannelNum)=c;
                MyCurveList(CurrentChannelNum)={nMyCurveList};
            else
                MyCurves=c;
                MyCurveList={nMyCurveList};
            end
        end%CurrentIndex
        s=SetMyCurves(MyCurveList);
    catch
        ShowWarning(CurrentShot,strcat('no curve/', nMyCurveList),handles)
    end
    
else
    msgbox('DP is not opende!')
    return
end


end

