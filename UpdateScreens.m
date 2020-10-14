function UpdateScreens(CurrentShot)
global  MyPicStruct MyCurves PageAxisNumbers hfig handles
%get the control parameter
%MyPicStruct=View2Struct(handles);
z=[];
MyPicStruct=View2Struct(handles);

MyPicStruct.PicTitle=num2str(CurrentShot);


sMyCurveList=get(handles.lbCurves,'String');
[m,n]=size(sMyCurveList);
[m1,n1]=size(MyCurves);


CurrentChannelNum=0;
% hwait=waitbar(0,'please wait ...');

machine=getappdata(0,'machine');
[server,~] = getIpTree4Machine(machine);

CurrentChannel=sMyCurveList{1};

% mdsopen(strTreeName,CurrentShot);
patternname='\w*$';
CurrentChannel = regexpi(CurrentChannel, patternname, 'match','once');
strTreeName=getTreeName(machine,CurrentChannel); %

strTreeName=strTreeName{1}; %



%% connect and open
initServerTree(server,strTreeName,CurrentShot)

for i=1:length(hfig);
    for j=1:PageAxisNumbers
        iCurve=(i-1)*PageAxisNumbers+j;
        CurrentChannel=sMyCurveList{iCurve};
        
        % mdsopen(strTreeName,CurrentShot);
        patternname='\w*$';
        CurrentChannel = regexpi(CurrentChannel, patternname, 'match','once');
        
        [y,x,Unit]=db(CurrentChannel);

        CurrentSysName=strTreeName;
        
        NickName=CurrentChannel;
        nMyCurveList=strcat(num2str(CurrentShot),CurrentSysName,'\',CurrentChannel);
        if lower(CurrentChannel(1))==':' %d->:
            c=AddNewCurve(x(:,1),y(:,MyIndex),num2str(CurrentShot),NickName,Unit,z);
        else
            c=AddNewCurve(x(:,1),y(:,1),num2str(CurrentShot),NickName,Unit,z);
        end
        
        
        CurrentChannelNum=CurrentChannelNum+1;
        if CurrentChannelNum>1
            MyCurves(CurrentChannelNum)=c;
            MyCurveList(CurrentChannelNum)={nMyCurveList};
        else
            MyCurves=c;
            MyCurveList={nMyCurveList};
        end
        
        % ha=getappdata(hfig(i),'hAxis');
        hLines=getappdata(hfig(i),'hLines');
        set(hLines(j),'XData',x,'YData',y);  %x and y are always cell

        

%         waitbar(i/m);
    end
    
   ha=getappdata(hfig(i),'hAxis');
   
   hTitle=get(ha,'Title');
   
   if iscell(hTitle)
       set(hTitle{1},{'String'},{['Shot: ' MyPicStruct.PicTitle]});
   else
       set(hTitle(1),{'String'},{['Shot: ' MyPicStruct.PicTitle]});
   end
   
   figure(hfig(i)) 
   drawnow;
end
%% close and disconnect
initServerTree;

% close(hwait)



