function s=getOffset(hfig)
s=0;
hLines=getappdata(hfig,'hLines');
x1=get(hLines(1),'XData');
y1=get(hLines(1),'YData');

x2=get(hLines(2),'XData');
y2=get(hLines(2),'YData');

dlg_title = 'select two time position by mouse click';
prompt = {'offset value'};
def     = {num2str(0)};
num_lines= 1;
answer = inputdlg(prompt,dlg_title,num_lines,def);
offset=str2double(answer{1});


[position1,~]=ginput(1);
[position2,~]=ginput(1);

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


avg1=mean(z1);
avg2=mean(z2);
% y1=y1+offset-avg1;
% y2=y2+offset-avg2;
y1=y1+offset;
y2=y2+offset;

setappdata(hfig,'offset',offset)



%% least square root
n=min(length(t1),length(t2));
k=reshape(z1,[n 1])\reshape(z2,[n 1]);
y1=y1.*k;


set(hLines(1),'YData',y1);
set(hLines(2),'YData',y2);


dlg_title = 'show coef';
prompt = {'k'};
def     = {num2str(k)};
num_lines= 1;
s  = inputdlg(prompt,dlg_title,num_lines,def);
% dlg_title = 'show the offset information';
% prompt = {'line1 offset','line2 offset'};
% def     = {num2str(offset-avg1),num2str(offset-avg2)};
% num_lines= 1;
% s  = inputdlg(prompt,dlg_title,num_lines,def);

