function DPF

hInformation=figure('MenuBar','none','Tag','Information','Resize','off','HitTest','off','Name','DPF SELECT FROM DB HL');%,...
%'KeyPressFcn',{@myKeyFunction,UD},...
%'Resize', 'off','WindowButtonUpFcn',{@myButtonUp,UD});

FieldNames={'装置编号';'放电序号';'CtrlCenterlLen';'FileType';'Ver';'MG1_ctlMode';'MG2_ctlMode';'MG3_ctlMode';'TF_ctlMode';'OH_ctlMode';'VF_ctlMode';'RF_ctlMode';'E1_ctlMode';'E2_ctlMode';'E34_ctlMode';'Vac_ctlMode';'Water_ctlMode';'Div_ctlMode';'LHCD_ctlMode';'ECRH_ctlMode';'ICRH_ctlMode';'NBI_ctlMode';'FB';'opFkLoad';'FBMode';'KIp';'KH';'KV';'K1';'K2';'K3';'K4';'FBC';'ZSMode';'LIMode';'TIpD';'THD';'TVD';'InvCosLimit4OH';'InvCosLimit';'InvVolLimit4OH';'InvVolLimit';'KE2byOh';'KE2byE1';'KE1byE2';'TIpI';'THI';'TVI';'TE1D';'TE2D';'TE3D';'TE4D';'TE1I';'TE2I';'TE3I';'TE4I';'Rplasma';'Zplasma';'CIe1Ip';'CIe2Ie1';'Ipmax';'Iohmax';'Tflattop';'CIe3Ie1';'MotorGeneratorLen';'Bt';'BtFlatTop';'MG1';'MG1Speed';'pRiseW1';'StrgExW1';'InvW1';'MG2';'MG2Speed';'pRiseW2';'StrgExW2';'InvW2';'MG3';'MG3Speed';'pRiseW3';'StrgExW3';'InvW3';'KMG3';'TMG3D';'TMG3I';'KIt';'TItD';'TItI';'KMG1';'TMG1D';'TMG1I';'FBItStart';'FBV3Start';'W1';'W2';'W3';'FBW1Start';'MGWinStart';'MGWinEnd';'MaxdW1';'MaxdW2';'MaxdW3';'MotorGenerator39';'MotorGenerator40';'MotorGenerator41';'MotorGenerator42';'MotorGenerator43';'MotorGenerator44';'MotorGenerator45';'MotorGenerator46';'MotorGenerator47';'MotorGenerator48';'MotorGenerator49';'MotorGenerator50';'MotorGenerator51';'MotorGenerator52';'MotorGenerator53';'MotorGenerator54';'MotorGenerator55';'MotorGenerator56';'MotorGenerator57';'MotorGenerator58';'MotorGenerator59';'MotorGenerator60';'MotorGenerator61';'MotorGenerator62';'MotorGenerator63';'MotorGenerator64';'PowerSupplyLen';'OhMode';'RFMode';'MFMode';'TFMode';'CVoltage';'C2IgW';'TF';'OH';'VF';'RF';'E1';'E2';'E34';'RFPolarity';'pOH2InvW';'OHReady';'VFReady';'RFReady';'E1Ready';'E2Ready';'E3Ready';'E4Ready';'FBStart';'IohZeroTime';'Uohp';'Uohn';'Uvf';'Urf';'Ue1';'Ue2';'Ue3';'Ue4';'V3';'OHpBlock';'OHnBlock';'VFBlock';'RFBlock';'E1Block';'E2Block';'E3Block';'E4Block';'IfAddInv';'OHpZS';'OHnZS';'VFZS';'RFpZS';'RFnZS';'E1ZS';'E2ZS';'E3ZS';'E4ZS';'OHpLI';'OHnLI';'VFLI';'RFpLI';'RFnLI';'E1LI';'E2LI';'E3LI';'E4LI';'OHT1';'OHT2';'OHT3';'VacFuelLen';'Puff';'PuffTime';'AddPuff';'AddPuffTime';'PI';'PITime';'MBI';'MBITime';'DIV';'DIVTime';'VAC';'Nrep1';'Tdelay1';'Twidth1';'Vheight1';'Nrep2';'Tdelay2';'Twidth2';'Vheight2';'Nrep3';'Tdelay3';'Twidth3';'Vheight3';'Nrep4';'Tdelay4';'Twidth4';'Vheight4';'Nrep5';'Tdelay5';'Twidth5';'Vheight5';'Nrep6';'Tdelay6';'Twidth6';'Vheight6';'Nrep7';'Tdelay7';'Twidth7';'Vheight7';'Nrep8';'Tdelay8';'Twidth8';'Vheight8';'Nrep9';'Tdelay9';'Twidth9';'Vheight9';'Nrep10';'Tdelay10';'Twidth10';'Vheight10';'Nrep11';'Tdelay11';'Twidth11';'Vheight11';'Nrep12';'Tdelay12';'Twidth12';'Vheight12';'Nrep13';'Tdelay13';'Twidth13';'Vheight13';'MacWaterLen';'LSwitch101';'LSwitch201';'LSwitch301';'LSwitch400';'LSwitch600';'LSwitch700';'LSwitch800';'LSwitch820';'LSwitch840';'LSwitch860';'Mac';'Water';'MacWater14';'MacWater15';'MacWater16';'MacWater17';'MacWater18';'MacWater19';'MacWater20';'MacWater21';'MacWater22';'MacWater23';'MacWater24';'MacWater25';'MacWater26';'MacWater27';'MacWater28';'MacWater29';'MacWater30';'MacWater31';'MacWater32';'MacWater33';'MacWater34';'MacWater35';'MacWater36';'MacWater37';'MacWater38';'MacWater39';'MacWater40';'MacWater41';'MacWater42';'MacWater43';'MacWater44';'MacWater45';'MacWater46';'MacWater47';'MacWater48';'MacWater49';'MacWater50';'MacWater51';'MacWater52';'MacWater53';'MacWater54';'MacWater55';'MacWater56';'MacWater57';'MacWater58';'MacWater59';'MacWater60';'MacWater61';'MacWater62';'MacWater63';'MacWater64';'AuxHeatingLen';'LHCD';'LHCDTime';'ECRH';'ECRHTime';'ICRH';'ICRHTime';'NBI';'NBITime';'ULH1';'ULH2';'LHReady';'LHBlock';'KLH';'TLHD';'TLHI';'UEC1';'UEC2';'ECReady';'ECBlock';'KEC';'TECD';'TECI';'LHCDTime2';'ECRHTime2';'WidthKlystron1';'WidthKlystron2';'WidthGyrotron1';'WidthGyrotron2';'AuxHeating30';'AuxHeating31';'AuxHeating32';'AuxHeating33';'AuxHeating34';'AuxHeating35';'AuxHeating36';'AuxHeating37';'AuxHeating38';'AuxHeating39';'AuxHeating40';'AuxHeating41';'AuxHeating42';'AuxHeating43';'AuxHeating44';'AuxHeating45';'AuxHeating46';'AuxHeating47';'AuxHeating48';'AuxHeating49';'AuxHeating50';'AuxHeating51';'AuxHeating52';'AuxHeating53';'AuxHeating54';'AuxHeating55';'AuxHeating56';'AuxHeating57';'AuxHeating58';'AuxHeating59';'AuxHeating60';'AuxHeating61';'AuxHeating62';'AuxHeating63';'AuxHeating64';'DiagDASLen';'VAX';'VAXTime';'TSS';'TSSTime';'NPA';'NPATime';'LBO';'LBOTime';'HCN';'HCNTime';'MACEM';'MACEMTime';'DIAG';'RCIp';'RCDh';'RCDv';'RCIe1';'RCIe2';'RCIe3';'RCV3';'RCIt';'RCV1';'RCIV';'RCIR';'DiagDAS26';'DiagDAS27';'DiagDAS28';'DiagDAS29';'DiagDAS30';'DiagDAS31';'DiagDAS32';'DiagDAS33';'DiagDAS34';'DiagDAS35';'DiagDAS36';'DiagDAS37';'DiagDAS38';'DiagDAS39';'DiagDAS40';'DiagDAS41';'DiagDAS42';'DiagDAS43';'DiagDAS44';'DiagDAS45';'DiagDAS46';'DiagDAS47';'DiagDAS48';'DiagDAS49';'DiagDAS50';'DiagDAS51';'DiagDAS52';'DiagDAS53';'DiagDAS54';'DiagDAS55';'DiagDAS56';'DiagDAS57';'DiagDAS58';'DiagDAS59';'DiagDAS60';'DiagDAS61';'DiagDAS62';'DiagDAS63';'DiagDAS64';'OtherParLen';'ShotNum';'IsRecord';'ExpFlag';'iShotNum';'Period';'WinStart';'WinEnd';'DischargeStart';'DischargeEnd';'CyclesPerStep';'KE3byOh';'KE3byE1';'KE3byE2';'KE3byE3';'KE2byE3';'DhvMode';'MaxdUoh';'MaxdUvf';'MaxdUrf';'MaxdUe1';'MaxdUe2';'MaxdUe3';'MaxdUe4';'Ivfmax';'Irfmax';'Ie1max';'Ie2max';'Ie3max';'Ie4max';'Kz';'Kr';'Vmaxinv';'Vmaxcir';'Imaxcir';'KIV';'TIVD';'TIVI';'KIR';'TIRD';'TIRI';'lShotNum';'OtherPar46';'OtherPar47';'OtherPar48';'OtherPar49';'OtherPar50';'OtherPar51';'OtherPar52';'OtherPar53';'OtherPar54';'OtherPar55';'OtherPar56';'OtherPar57';'OtherPar58';'OtherPar59';'OtherPar60';'OtherPar61';'OtherPar62';'OtherPar63';'OtherPar64'};
FNames={FieldNames};
FieldNames={'系统序号';'装置编号';'放电序号';'数据存放路径';'放电开始时间';'放电主题';'实验总结';'工作气体';'等离子体位形';'生效时间';'记录员';'实验负责人';'工程情况';'问题';'环电压';'环电流';'存在时间';'平顶时间';'纵场强度';'欧姆电流';'垂直电流';'水平电流';'多极线圈2';'水平位移';'垂直位移';'气体压强';'小半径';'电子密度';'电子温度';'离子温度';'有效Z';'边缘q';'内感';'约束时间';'多极线圈1';'232';'中性参数1';'中性参数2';'靶丸参数1';'靶丸参数2';'靶丸参数3';'取数时间'};
FNames(2)={FieldNames};
FieldNames={'通道定义编号';'通道名称';'任务编号';'通道说明';'系数因子';'信号偏移量';'物理单位';'处理公式';'选点方式';'图形方式';'外部处理';'限幅下限';'限幅上限';'时区模式';'备用文本字段';'通道级别';'通道类别';'管理者';'通道分组';'临时'};
FNames(3)={FieldNames};

DBNames={'实验数据_中控参数';'实验数据';'通道定义'};
DPFGroups={'CC';'MG'; 'PS'; 'VAC';'Mac';'AuxH';'DAS';'Other'};
GroupNums=[64-2,128-2,192-2,256-2,320-2, 384-2, 448-2,512-5];
GroupNums=GroupNums+2;

handles.FNames=FNames;
handles.DBNames=DBNames;
handles.DPFGroups=DPFGroups;
handles.GroupNums=GroupNums;



scrsz = get(0,'ScreenSize');
scrsz=[10 40 (scrsz(3)-scrsz(1))*0.95 (scrsz(4)-scrsz(2))*0.9-30];
scrsz=scrsz*0.9;
set(hInformation,'Units','pixels','Position',scrsz);
scrsz=scrsz*0.85;
Rows=1;
Cols=5;
wstep=scrsz(3)/Cols;
hstep=scrsz(4)/Rows;
w=wstep/2;
h=0.6*(scrsz(4));
b=scrsz(2)-26;
l=2;






hLShotNumber1 = uicontrol('parent',                   hInformation,...
    'Units',                    'points', ...
    'String',                  'Shot1', ...
    'Position',                 [l,b+1.14*h,0.9*w,0.04*h],...
    'HorizontalAlignment',      'left', ...
    'FontWeight',               'bold', ...
    'FontSize',                 12,...
    'Style',                    'text', ...
    'Enable',                   'on');
handles.hLShotNumber1=hLShotNumber1;
hShotNumber1 = uicontrol('parent',                   hInformation,...
    'Units',                    'points', ...
    'String',                  '11617', ...
    'Position',                 [l,b+1.08*h,0.9*w,0.04*h],...
    'HorizontalAlignment',      'left', ...
    'FontWeight',               'bold', ...
    'FontSize',                 12,...
    'Style',                    'edit', ...
    'Enable',                   'on', ...
    'Tooltipstring',            'input ShotNumber');
handles.hShotNumber1=hShotNumber1;
hFilter = uicontrol('parent',                   hInformation,...
    'Units',                    'points', ...
    'String',                  '*', ...
    'Position',                 [l,b+1.02*h,0.9*w,0.04*h],...
    'HorizontalAlignment',      'left', ...
    'FontWeight',               'bold', ...
    'FontSize',                 12,...
    'Style',                    'edit', ...
    'Enable',                   'on', ...
    'Tooltipstring',            'input ShotNumber');
handles.hFilter=hFilter;
hFields = uicontrol('parent',                   hInformation,...
    'Units',                    'points', ...
    'String',                  FNames{1}, ...
    'Position',                 [l,b,0.9*w,h],...
    'HorizontalAlignment',      'left', ...
    'FontWeight',               'bold', ...
    'FontSize',                 12,...
    'Style',                    'listbox', ...
    'Enable',                   'on', ...
    'Tooltipstring',            'channels OK');
handles.hFields=hFields;
l=l+w;
w=1*w;
hLShotNumber2 = uicontrol('parent',                   hInformation,...
    'Units',                    'points', ...
    'String',                  'Shot2', ...
    'Position',                 [l,b+1.14*h,0.9*w,0.04*h],...
    'HorizontalAlignment',      'left', ...
    'FontWeight',               'bold', ...
    'FontSize',                 12,...
    'Style',                    'text', ...
    'Enable',                   'on');
handles.hLShotNumber2=hLShotNumber2;
hShotNumber2 = uicontrol('parent',                   hInformation,...
    'Units',                    'points', ...
    'String',                  '11618', ...
    'Position',                 [l,b+1.08*h,0.9*w,0.04*h],...
    'HorizontalAlignment',      'left', ...
    'FontWeight',               'bold', ...
    'FontSize',                 12,...
    'Style',                    'edit', ...
    'Enable',                   'on', ...
    'Tooltipstring',            'input ShotNumber');
handles.hShotNumber2=hShotNumber2;
hLSelectedFields = uicontrol('parent',                   hInformation,...
    'Units',                    'points', ...
    'String',                  'Fields', ...
    'Position',                 [l,b+1.02*h,0.9*w,0.04*h],...
    'HorizontalAlignment',      'left', ...
    'FontWeight',               'bold', ...
    'FontSize',                 12,...
    'Style',                    'text', ...
    'Enable',                   'on', ...
    'Tooltipstring',            'Click4Cancel');
handles.hLSelectedFields=hLSelectedFields;
hSelectedFields = uicontrol('parent',                   hInformation,...
    'Units',                    'points', ...
    'String',                  '', ...
    'Position',                 [l,b,0.9*w,h],...
    'HorizontalAlignment',      'left', ...
    'FontWeight',               'bold', ...
    'FontSize',                 12,...
    'Style',                    'listbox', ...
    'Enable',                   'on', ...
    'Tooltipstring',            'channels OK');
handles.hSelectedFields=hSelectedFields;
l=l+w;
w=1*w;
hClear = uicontrol('parent',                   hInformation,...
    'Units',                    'points', ...
    'String',                  'Clear', ...
    'Position',                 [l,b+1.14*h,0.9*w,0.04*h],...
    'HorizontalAlignment',      'left', ...
    'FontWeight',               'bold', ...
    'FontSize',                 12,...
    'Style',                    'pushbutton', ...
    'Enable',                   'on');
handles.hClear=hClear;
hCondition = uicontrol('parent',                   hInformation,...
    'Units',                    'points', ...
    'String',                  '', ...
    'Position',                 [l,b+1.08*h,1.9*w,0.04*h],...
    'HorizontalAlignment',      'left', ...
    'FontWeight',               'bold', ...
    'FontSize',                 12,...
    'Style',                    'edit', ...
    'Enable',                   'on', ...
    'Tooltipstring',            'input ShotNumber');
handles.hCondition=hCondition;
hLResult1 = uicontrol('parent',                   hInformation,...
    'Units',                    'points', ...
    'String',                  '', ...
    'Position',                 [l,b+1.02*h,0.9*w,0.04*h],...
    'HorizontalAlignment',      'left', ...
    'FontWeight',               'bold', ...
    'FontSize',                 12,...
    'Style',                    'text', ...
    'Enable',                   'on', ...
    'Tooltipstring',            'SelectedFields');
handles.hLResult1=hLResult1;
hResult1 = uicontrol('parent',                   hInformation,...
    'Units',                    'points', ...
    'String',                  '', ...
    'Position',                 [l,b,1.9*w,h],...
    'HorizontalAlignment',      'left', ...
    'FontWeight',               'bold', ...
    'FontSize',                 12,...
    'Style',                    'listbox', ...
    'Enable',                   'on', ...
    'Tooltipstring',            'channels OK');
handles.hResult1=hResult1;
l=l+w+w;
w=1*w;
hSort = uicontrol('parent',                   hInformation,...
    'Units',                    'points', ...
    'String',                  'Sort', ...
    'Position',                 [l,b+1.14*h,0.9*w,0.04*h],...
    'HorizontalAlignment',      'left', ...
    'FontWeight',               'bold', ...
    'FontSize',                 12,...
    'Style',                    'pushbutton', ...
    'Enable',                   'on', ...
    'Tooltipstring',            'input ShotNumber');
handles.hSort=hSort;
hUnSort = uicontrol('parent',                   hInformation,...
    'Units',                    'points', ...
    'String',                  'UnSort', ...
    'Position',                 [l,b+1.08*h,0.9*w,0.04*h],...
    'HorizontalAlignment',      'left', ...
    'FontWeight',               'bold', ...
    'FontSize',                 12,...
    'Style',                    'pushbutton', ...
    'Enable',                   'on', ...
    'Tooltipstring',            'input ShotNumber');
handles.hUnSort=hUnSort;
hLResult2 = uicontrol('parent',                   hInformation,...
    'Units',                    'points', ...
    'String',                  '', ...
    'Position',                 [l,b+1.02*h,0.9*w,0.04*h],...
    'HorizontalAlignment',      'left', ...
    'FontWeight',               'bold', ...
    'FontSize',                 12,...
    'Style',                    'text', ...
    'Enable',                   'on', ...
    'Tooltipstring',            'SelectedFields');
handles.hLResult2=hLResult2;
hResult2 = uicontrol('parent',                   hInformation,...
    'Units',                    'points', ...
    'String',                  '', ...
    'Position',                 [l,b,0.9*w,h],...
    'HorizontalAlignment',      'left', ...
    'FontWeight',               'bold', ...
    'FontSize',                 12,...
    'Style',                    'listbox', ...
    'Enable',                   'on', ...
    'Tooltipstring',            'channels OK');
handles.hResult2=hResult2;
l=l+w;
w=1*w;
hSearch = uicontrol('parent',                   hInformation,...
    'Units',                    'points', ...
    'String',                  'Search', ...
    'Position',                 [l,b+1.14*h,0.9*w,0.04*h],...
    'HorizontalAlignment',      'left', ...
    'FontWeight',               'bold', ...
    'FontSize',                 12,...
    'Style',                    'pushbutton', ...
    'Enable',                   'on', ...
    'Tooltipstring',            'input ShotNumber');
handles.hSearch=hSearch;
hCompare = uicontrol('parent',                   hInformation,...
    'Units',                    'points', ...
    'String',                  'Compare', ...
    'Position',                 [l,b+1.08*h,0.9*w,0.04*h],...
    'HorizontalAlignment',      'left', ...
    'FontWeight',               'bold', ...
    'FontSize',                 12,...
    'Style',                    'pushbutton', ...
    'Enable',                   'on', ...
    'Tooltipstring',            'input ShotNumber');
handles.hCompare=hCompare;
hLResult3 = uicontrol('parent',                   hInformation,...
    'Units',                    'points', ...
    'String',                  '', ...
    'Position',                 [l,b+1.02*h,0.9*w,0.04*h],...
    'HorizontalAlignment',      'left', ...
    'FontWeight',               'bold', ...
    'FontSize',                 12,...
    'Style',                    'text', ...
    'Enable',                   'on', ...
    'Tooltipstring',            'SelectedFields');
handles.hLResult3=hLResult3;
hResult3 = uicontrol('parent',                   hInformation,...
    'Units',                    'points', ...
    'String',                  '', ...
    'Position',                 [l,b,0.9*w,h],...
    'HorizontalAlignment',      'left', ...
    'FontWeight',               'bold', ...
    'FontSize',                 12,...
    'Style',                    'listbox', ...
    'Enable',                   'on', ...
    'Tooltipstring',            'channels OK');
handles.hResult3=hResult3;
l=l+w;
w=1*w;
hDataBase = uicontrol('parent',                   hInformation,...
    'Units',                    'points', ...
    'String',                   DBNames, ...
    'Position',                 [l,b+1.14*h,0.9*w,0.04*h],...
    'HorizontalAlignment',      'left', ...
    'FontWeight',               'bold', ...
    'FontSize',                 12,...
    'Style',                    'popupmenu', ...
    'Enable',                   'on');
handles.hDataBase=hDataBase;
hGroup = uicontrol('parent',                   hInformation,...
    'Units',                    'points', ...
    'String',                   DPFGroups, ...
    'Position',                 [l,b+1.08*h,0.9*w,0.04*h],...
    'HorizontalAlignment',      'left', ...
    'FontWeight',               'bold', ...
    'FontSize',                 12,...
    'Style',                    'popupmenu', ...
    'Enable',                   'on', ...
    'Tooltipstring',            'input ShotNumber');
handles.hGroup=hGroup;

hLResult4 = uicontrol('parent',                   hInformation,...
    'Units',                    'points', ...
    'String',                  '', ...
    'Position',                 [l,b+1.02*h,0.9*w,0.04*h],...
    'HorizontalAlignment',      'left', ...
    'FontWeight',               'bold', ...
    'FontSize',                 12,...
    'Style',                    'text', ...
    'Enable',                   'on', ...
    'Tooltipstring',            'SelectedFields');
handles.hLResult4=hLResult4;
hResult4 = uicontrol('parent',                   hInformation,...
    'Units',                    'points', ...
    'String',                  '', ...
    'Position',                 [l,b,0.9*w,h],...
    'HorizontalAlignment',      'left', ...
    'FontWeight',               'bold', ...
    'FontSize',                 12,...
    'Style',                    'listbox', ...
    'Enable',                   'on', ...
    'Tooltipstring',            'channels OK');
handles.hResult4=hResult4;

set(hShotNumber1,'callback',            {@myhShotNumber1,handles})
set(hFilter,'callback',                 {@myhFilter,handles})
set(hFields,'callback',                 {@myhFields,handles})
set(hClear,'callback',                  {@myhClear,handles})
set(hSelectedFields,'callback',         {@myhSelectedFields,handles})
set(hSort,'callback',                   {@myhSort,handles})
set(hUnSort,'callback',                 {@myhUnSort,handles})
set(hSearch,'callback',                 {@myhSearch,handles})
set(hCompare,'callback',                {@myhCompare,handles})
set(hDataBase,'callback',               {@myhDataBase,handles})
set(hGroup,'callback',                  {@myhGroup,handles})

strCondition=['放电序号 = ' get(handles.hShotNumber1,'string')];
set(handles.hCondition,'String',strCondition);%
set(handles.hCompare,'BackgroundColor','g','UserData',1);%
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function myhCompare(hObject, eventdata, handles)
index=get(handles.hDataBase,'value');
if index==3
    return
end


FieldNames=handles.FNames{index};
DBName=handles.DBNames{index};


myFields=[];
for i=1:length(FieldNames)
    myFields=[myFields FieldNames{i} ','];
end
myFields(end)=[];  %cancel the last comma.


conn = myloginconnect('hl');
%shot1
strCondition=['放电序号 = ' get(handles.hShotNumber1,'string')];
querystr=['SELECT ALL ' myFields ' FROM ' DBName ' WHERE ' strCondition];
curs = exec(conn,querystr);
curs = fetch(curs);
ans1 = curs.Data;

%shot2
strCondition=['放电序号 = ' get(handles.hShotNumber2,'string')];
querystr=['SELECT ALL ' myFields ' FROM ' DBName ' WHERE ' strCondition];
curs = exec(conn,querystr);
curs = fetch(curs);
ans2 = curs.Data;

Indexs=cellfun(@isequal,ans1,ans2);
value=get(handles.hCompare,'UserData');

if isempty(value)
    value=1;
end


if value==1
    ChannelIndexs=find(~Indexs);
    set(handles.hCompare,'BackgroundColor','m','UserData',0);%
else
    ChannelIndexs=find(Indexs);
    set(handles.hCompare,'BackgroundColor','g','UserData',1);%
end
myFields=FieldNames(ChannelIndexs);
set(handles.hSelectedFields,'string',myFields);
ans1=ans1(ChannelIndexs);
ans2=ans2(ChannelIndexs);
close(conn)
set(handles.hLResult4,'String',get(handles.hLResult2,'String'));%
set(handles.hLResult3,'String',get(handles.hLResult1,'String'));%
set(handles.hLResult2,'String',get(handles.hShotNumber2,'string'));%
set(handles.hLResult1,'String',get(handles.hShotNumber1,'string'));%
set(handles.hResult4,'String',get(handles.hResult2,'String'));%
set(handles.hResult3,'String',get(handles.hResult1,'String'));%
set(handles.hResult2,'String',ans2);%
set(handles.hResult1,'String',ans1');%

%-------------------------------------------------------------return
function myhSearch(hObject, eventdata, handles)
myChannels=get(handles.hSelectedFields,'String');%
if isempty(myChannels)
    return
end

% myChannels=cellfun(@AddComma,myChannels);

myFields=[];
for i=1:length(myChannels)
    myFields=[myFields myChannels{i} ','];
end
myFields(end)=[];  %cancel the last comma.


index=get(handles.hDataBase,'value');
DBNames=get(handles.hDataBase,'string');
DBName=DBNames{index};

strCondition=get(handles.hCondition,'string');
if isempty(strCondition)
    if index==3
        strCondition=['通道定义编号 = 4101 '];
    else
        strCondition=['放电序号 = ' get(handles.hShotNumber1,'string')];
    end
    set(handles.hCondition,'String',strCondition);%
end

querystr=['SELECT ALL ' myFields ' FROM ' DBName ' WHERE ' strCondition];
conn = myloginconnect('hl');
curs = exec(conn,querystr);
curs = fetch(curs);
ansf = curs.Data;
close(conn)

Columns=size(ansf,2);

if Columns>1
    set(handles.hLResult1,'String',myChannels{1})
    set(handles.hResult1,'String',ansf(:,1))
    set(handles.hLResult2,'String',myChannels{2})
    set(handles.hResult2,'String',ansf(:,2))
    if Columns>2
        set(handles.hLResult3,'String',myChannels{3})
        set(handles.hResult3,'String',ansf(:,3))
    end
    if Columns>3
        set(handles.hLResult4,'String',myChannels{4})
        set(handles.hResult4,'String',ansf(:,4))
    end
else
    set(handles.hLResult4,'String',get(handles.hLResult3,'String'))
    set(handles.hLResult3,'String',get(handles.hLResult2,'String'))
    set(handles.hLResult2,'String',get(handles.hLResult1,'String'))
    set(handles.hLResult1,'String',get(handles.hShotNumber1,'string'))
    set(handles.hResult4,'String',get(handles.hResult3,'String'))
    set(handles.hResult3,'String',get(handles.hResult2,'String'))
    set(handles.hResult2,'String',get(handles.hResult1,'String'))
    set(handles.hResult1,'String',ansf')
end

%-------------------------------------------------------------return
% function newStr=AddComma(oldStr)
% newStr=[oldStr ','];


%-------------------------------------------------------------return
function myhFields(hObject, eventdata, handles)
mySelectionType=get(gcf,'SelectionType');

switch mySelectionType
    case 'extend'
        CurrentCurveNum=get(handles.hFields,'Value');%
        MyList=get(handles.hFields,'String');%
        strCondition=get(handles.hCondition,'string');
        strCondition=[strCondition ' ' MyList{CurrentCurveNum}];
        set(handles.hCondition,'string',strCondition);
    case 'normal'

        MyCurveList=get(handles.hSelectedFields,'String');%
        n=length(MyCurveList);
        CurrentCurveNum=get(hObject,'Value');%
        MyList=get(hObject,'String');%
        if n<1
            MyCurveList=MyList(CurrentCurveNum);%add one
        else
            MyCurveList(n+1)=MyList(CurrentCurveNum);%add one
        end
        set(handles.hSelectedFields,'String',MyCurveList);%
        set(handles.hSelectedFields,'Value',n+1);%
end
%-------------------------------------------------------------return
function myhSelectedFields(hObject, eventdata, handles)
MyCurveList=get(hObject,'String');%
CurrentCurveNum=get(hObject,'Value');%
n=length(MyCurveList);
for i=1 : n
    if i>CurrentCurveNum
        MyCurveList(i-1)=MyCurveList(i);%one step backward
    end
end
MyCurveList(n)=[];%clear one
set(hObject,'String',MyCurveList);%

if CurrentCurveNum==n && n>1
    set(hObject,'Value',CurrentCurveNum-1);% 
else
    set(hObject,'Value',CurrentCurveNum);% 
end

%-------------------------------------------------------------return

function myhUnSort(hObject, eventdata, handles)
index=get(handles.hDataBase,'value');
FieldNames=handles.FNames{index};
set(handles.hFields,'string',FieldNames);
%-------------------------------------------------------------return
function myhSort(hObject, eventdata, handles)
MyChanList=get(handles.hFields,'string');
MyChanList=sort(MyChanList);
set(handles.hFields,'string',MyChanList);
%-------------------------------------------------------------return
function myhDataBase(hObject, eventdata, handles)
index=get(handles.hDataBase,'value');
FieldNames=handles.FNames{index};
set(handles.hFields,'string',FieldNames);
%-------------------------------------------------------------return
function myhGroup(hObject, eventdata, handles)
index=get(handles.hDataBase,'value');
if index==1
    ind=get(handles.hGroup,'value');
    GroupNum=handles.GroupNums(ind);
    set(handles.hFields,'ListboxTop',GroupNum-63);
end

%-------------------------------------------------------------return
function myhClear(hObject, eventdata, handles)
set(handles.hCondition,'String',[]);%
set(handles.hSelectedFields,'String',[]);%
set(handles.hLResult1,'String',[]);%
set(handles.hResult1,'String',[]);%
set(handles.hLResult2,'String',[]);%
set(handles.hResult2,'String',[]);%
set(handles.hLResult3,'String',[]);%
set(handles.hResult3,'String',[]);%
set(handles.hLResult4,'String',[]);%
set(handles.hResult4,'String',[]);%
%-------------------------------------------------------------return
function myhShotNumber1(hObject, eventdata, handles)
strCondition=['放电序号 = ' get(handles.hShotNumber1,'string')];
set(handles.hCondition,'String',strCondition);%
%-------------------------------------------------------------return
function myhFilter(hObject, eventdata, handles)
pattern=get(handles.hFilter,'string');
myFields=get(handles.hFields,'string');

s = regexpi(myFields, pattern, 'start');
Indexs=cellfun('isempty',s);
ChannelIndexs=find(~Indexs);
myFields=myFields(ChannelIndexs);
set(handles.hFields,'string',myFields);
