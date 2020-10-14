
function s=getCalibrationCoef(hfig)
s=0;
hLines=getappdata(hfig,'hLines');
x1=get(hLines(1),'XData');
y1=get(hLines(1),'YData');

x2=get(hLines(2),'XData');
y2=get(hLines(2),'YData');

dlg_title = 'select two time position by mouse click';
prompt = {'select the target, 1=first,2=second'};
def     = {num2str(1)};
num_lines= 1;
selectTarget  = inputdlg(prompt,dlg_title,num_lines,def);




[position1,p1]=ginput(1);
[position2,p2]=ginput(1);

Xmax=max(position1,position2);
Xmin=min(position1,position2);
myTolerance=1e-7;

% [Xmax,ys]=getCurrentCoordinate(Xmax,0,gca);% transfer the screen to coordinate
% [Xmin,ys]=getCurrentCoordinate(Xmin,0,gca);% transfer the screen to coordinate

indexStart1=find(x1>=Xmin-myTolerance,1,'first');
indexStart2=find(x2>=Xmin-myTolerance,1,'first');
indexEnd1=find(x1<=Xmax+myTolerance,1,'last');
indexEnd2=find(x2<=Xmax+myTolerance,1,'last');

t1=x1(indexStart1:indexEnd1);
t2=x2(indexStart2:indexEnd2);


% use the low sampling single as the reference
if length(t1)>length(t2)
    z1=interp1(x1,y1,t2,'nearest');
    z2=y2(indexStart2:indexEnd2);
elseif length(t1)<length(t2)
    z2=interp1(x2,y2,t1,'nearest');
    z1=y1(indexStart1:indexEnd1);
else
    z1=y1(indexStart1:indexEnd1);
    z2=y2(indexStart2:indexEnd2);
end


offset=getappdata(hfig,'offset');
if isempty(offset)
    offset=0;
end



z1=z1-offset;
z2=z2-offset;





%% least square root
n=min(length(t1),length(t2));
k=reshape(z1,[n 1])\reshape(z2,[n 1]);


dlg_title = 'show the calibration information';
prompt = {'fixed offset','calibration coefficient'};

switch str2num(selectTarget{1})
    case 1
        set(hLines(2),'YData',(y2-offset)/k+offset);
        def     = {num2str(offset),num2str(1/k)};
        num_lines= 1;
        s  = inputdlg(prompt,dlg_title,num_lines,def);
    case 2
        set(hLines(1),'YData',(y1-offset)*k+offset);
        def     = {num2str(offset),num2str(k)};
        num_lines= 1;
        s  = inputdlg(prompt,dlg_title,num_lines,def);
end
