function [y,x,varargout]=GetCurveByFormula(CurrentShot,CurrentChannel,varargin)
%get the curve data by predefined formula
%   Copyright 1966-2012 Dr.SONG Xianming: songxm@swip.ac.cn
%   $Revision: 5.13.6.13 $  $Date: 2011/03/09 07:01:29 $
%   SWIP.
global handles MyPicStruct

y=[];
x=[];
zMatrix=[];
CurrentSysName=getappdata(0,'SubSystem');


Unit='au';
Chs=[];


if nargin>=3
    if ~isempty(varargin{1}) && ischar(varargin{1}) %
        CurrentSysName=varargin{1};
    end
end


if nargin>=4
    if ~isempty(varargin{2}) && ischar(varargin{2}) %
        CurrentDataFile=varargin{2};
    end
end


if nargin>=5
    if ~isempty(varargin{3}) && isstruct(varargin{3}) %
        CurrentDasInf=varargin{3};
    end
end


%try
    switch lower(CurrentChannel)

       case {'@hf','@HF'}
           tic
           [s,t]=hl2adb(CurrentShot,{'ep01','ep02','ep03','ep04','ep05','ep06','ep07'},'','',1,'EPC');
           [s_4,t]=hl2adb(CurrentShot,{'ep47','ep48','ep49','ep50'},'','',1,'EPC');
           toc
           Is4=s_4(:,2)-s_4(:,1);%
           n=min(size(s));
           z_m=6; % Z numbers ;4
           coef=[10,10,10,10,10,10,10];
           
           for i=1:n
               temp=ag_mm(s(:,i).*coef(i));% varargin{i};%smooth(s(:,i),1);%
               L=length(temp);
               mn(i)=mean(s(:,i));
               er(i)=std(s(:,i));
               C(i,:)=temp;
           end
           %index_c=3:L-2;% Cut the former and latter 2-points
           x=linspace(t(1),t(end),L);%(495,530,L); % x方向的数据点
           x=reshape(x,[length(x) 1]);
           y=linspace(-87,-81,n);%(1,n,n);% y方向的数据点
           y=reshape(y,[length(y) 1]);
           
%            figure
%            errorbar(y,mn,er,'-s')
           
           zMatrix=C;
           CurrentSysName='EPC';
           Unit='Mw/m^2';
           Chs='heatFlux';
       case {'@hfs','@HFS'}
           [s,t]=hl2adb(CurrentShot,{'ep01','ep02','ep03','ep04','ep05','ep06','ep07'},'','',1,'EPC');
           [s_4,t]=hl2adb(CurrentShot,{'ep47','ep48','ep49','ep50'},'','',1,'EPC');
           Is4=s_4(:,2)-s_4(:,1);%
           n=min(size(s));
           z_m=6; % Z numbers ;4
           coef=[10,10,10,10,10,10,10];
           
           for i=1:n
               temp=ag_mm(s(:,i).*coef(i));% varargin{i};%smooth(s(:,i),1);%
               L=length(temp);
               mn(i)=mean(s(:,i));
               er(i)=std(s(:,i));
               C(i,:)=temp;
           end
           %index_c=3:L-2;% Cut the former and latter 2-points
           x=linspace(t(1),t(end),L);%(495,530,L); % x方向的数据点
           x=reshape(x,[length(x) 1]);
           y=smooth(C(z_m,:),50);
           CurrentSysName='EPC';
           Unit='Mw/m^2';
        
        
       case {'@newe','@NeWe','ne_we'}
             [y,x]=hl2adb(CurrentShot,'Density1D',100,1000,'1000hz','NFC');
             if length(x)<2
                 [z,x]=hl2adb(CurrentShot,'fir_sph4a','','','','ne1');
                 y=abs(z)*3.22/3600;
             end
             [z,x]=hl2adb(CurrentShot,'W_E',100,1000,'1000hz','EMD');
              hnewe=figure;
              plot(y,z,'.r')
              xlabel('ne(10^1^9/m^3)')
%               ylabel('storedEnergy(kJ)')
              ylabel('W\_E(kJ)')
              box on 
       case {'@wav','@WAV'}
%           suffixName='sn3MA';
            suffixName='sn1200kA';
            
            load(['D:\2014\feb\' suffixName],'tt','Ip','Icspf')
            t=tt*1000;
            x=reshape(t,[length(t) 1]);
            y=zeros(length(t),18);
            y(:,1)=reshape(Ip,[length(t) 1])/1e6;
            y(:,2:18)=Icspf/1e3;
            
            
            
            CurrentSysName=[];
            Unit={'MA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA'};
            Chs={'IP','CS','1U','1L','2U','2L','3U','3L','4U','4L','5U','5L','6U','6L','7U','7L','8U','8L'};
            
       case {'@ipf','@IPF'}
            suffixName='Ohmic3MA';
            
            load(['c:\2w\equ\' suffixName],'t','iPF')
            x=reshape(t,[length(t) 1]);
            y=iPF;
            CurrentSysName=[];
            Unit={'kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA'};
            Chs={'CSU','CSL','1U','1L','2U','2L','3U','3L','4U','4L','5U','5L','6U','6L','7U','7L','8U','8L'};
               
            
        case {'@i2i','@i2i'}
            suffixName='PFevolution';
            
            load(['c:\2w\equ\' suffixName],'t','iPF')
            x=reshape(t,[length(t) 1]);
            y=iPF;
            CurrentSysName=[];
            Unit={'kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA'};
            Chs={'CSU','CSL','1U','1L','2U','2L','3U','3L','4U','4L','5U','5L','6U','6L','7U','7L','8U','8L'};
        case {'@u68','@U68'}
            suffixName='FP068';
            
            load(['c:\2w\i2v\IU' suffixName],'t','I','U')
            x=t;
            y=[I U];
            CurrentSysName=[];
            Unit={'kA','kA','kA','kA','V','V','V','V'};
            Chs={'P','CS','PF6','PF8','P','CS','PF6','PF8'};
%         case {'@sn','@SN'}
%             suffixName='SN';
%             
%             load(['c:\2w\i2v\IU' suffixName],'t','I','U')
%             x=t;
%             y=[I U];
%             CurrentSysName=[];
%             Unit={'kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','V','V','V','V','V','V','V','V','V','V','V','V','V','V','V','V','V','V'};
%             Chs={'P','CS','1U','1L','2U','2L','3U','3L','4U','4L','5U','5L','6U','6L','7U','7L','8U','8L','P','CS','1U','1L','2U','2L','3U','3L','4U','4L','5U','5L','6U','6L','7U','7L','8U','8L'};
        case {'@sn','@SN'}
            suffixName='SN';
            load(['c:\2w\i2v\IU' suffixName],'t','I','U')
            x=reshape(t,[numel(t) 1]);
            y=[I/1000 U];
            CurrentSysName=[];
            Unit={'kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','V','V','V','V','V','V','V','V','V','V','V','V','V','V','V','V','V','V'};
            Chs={'P','CS','1U','1L','2U','2L','3U','3L','4U','4L','5U','5L','6U','6L','7U','7L','8U','8L','P','CS','1U','1L','2U','2L','3U','3L','4U','4L','5U','5L','6U','6L','7U','7L','8U','8L'};
        case {'@dn','@DN'}
            suffixName='DN';
            load(['c:\2w\i2v\IU' suffixName],'t','I','U')
            x=reshape(t,[numel(t) 1]);
            y=[I/1000 U];
            CurrentSysName=[];
            Unit={'kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','kA','V','V','V','V','V','V','V','V','V','V','V','V','V','V','V','V','V','V'};
            Chs={'P','CS','1U','1L','2U','2L','3U','3L','4U','4L','5U','5L','6U','6L','7U','7L','8U','8L','P','CS','1U','1L','2U','2L','3U','3L','4U','4L','5U','5L','6U','6L','7U','7L','8U','8L'};
        case '@tprof'
            
            myCurrentChannel={'MECE_1' 'MECE_2' 'MECE_3' 'MECE_4' 'MECE_5' 'MECE_6' 'MECE_7' 'MECE_8' 'MECE_9' 'MECE_10' 'MECE_11' 'MECE_12' 'MECE_13' 'MECE_14' 'MECE_15' 'MECE_16'};
            %C=[1.1446   22.6206    5.3439    0.9341    4.8181   13.0070    4.3196    6.2034    5.7958    0.6375    0.6688    6.1906    0.5351    2.5030   0   0];
            C=MECE_coef(CurrentShot);
           %C=[  1.3636   28   7.5   1    4.8   14    5    9    5.5118    0.4    0.6274    15    0.3625    1    0         0];
%   C=0.75/0.35*[1.0000 0.9821 9.5127 0.4560 0.2151 0.4238 0.1715 0.1779 0.2465 0 0 0.1196 0.1076 4.3707 0 0.0703];

           % C=(fliplr(C))';
%             profile on
%             tic
              [z,x,CurrentSysName,Unit,Chs]=hl2adb(CurrentShot,myCurrentChannel,'ECF');
              zd=hl2azd(CurrentShot,myCurrentChannel,'ECF');  %zerodrift
              
              for i=1:length(myCurrentChannel)
                  z(:,i)=smooth(z(:,i),7,'lowess')-zd(i);
              end
%             t=toc
%             profile viewer 
%             profile resume
%             profile off
%             p = profile('info')
            
            y=z*diag(C);
            
            y(:,15:16)=[];
           % y(:,3)=[];
          
            
            figure
            r=getECEpos(hl2azd(CurrentShot,'@bt'));
            r(15:16)=[];
            %r(3)=[];
            surf(r,x,y)
            
            SHADING INTERP
            
            
        case {'@Ted','@ted'}
            myCurrentChannel={'ep47' 'ep49' 'ep50'};
            [z,x]=hl2adb(CurrentShot,myCurrentChannel,'','','','epd');
            y=28.8*abs(z(:,1)-(z(:,2)+z(:,3))/2);
        case {'@Ned','@ned'}
            myCurrentChannel={'ep47' 'ep48' 'ep49' 'ep50'};
            [z,x]=hl2adb(CurrentShot,myCurrentChannel,'','','','epd');
            y=0.59*abs(z(:,1)-z(:,2))./sqrt(0.01+abs(z(:,1)-(z(:,3)+z(:,4))/2))*1e19;            

        case '@ha'
            [y,x,CurrentSysName,Unit,Chs]=hl2adb(CurrentShot,'I_Div_Imp2');
        case {'@gas','@GAS'}
            [y,x,CurrentSysName,Unit,Chs]=hl2adb(CurrentShot,'@gas_2a','TMP');
            zd=hl2azd(CurrentShot,'gas_2a',-900,-800);
            [C,I] = min(y);
            y(I)=zd;
            ymax=max(y);
            ymin=min(y);
            delY=ymax-ymin;
            ydeadline=ymin+0.2*delY;
            y(y<=ydeadline)=zd;
            y=log10(1e-6+y-min(y));
            y=smooth(y,21,'lowess');
%             y=log10(1e-1+y-min(y));
%              y=smooth(y,21,'lowess');
%             y=log10(1e-5+y-min(y));
            
          
            
            
            
        case {'@ipvf','@Ipvf','@IPVF'}
            [y,x,CurrentSysName,Unit,Chs]=hl2adb(CurrentShot,'fex_ip','fbc');
            y=y*0.07;
        case {'@dpf','@DPF'}
            DPF
            y=[0;0];
            x=[0;1];
        case {'@nediv','@NEDIV'}
            %calculate the electron density in divertor chamber
            %originally programmed by Dr. SHI Zhongbin from swip
            %modified by Dr. SONG Xianming from swip
            [a,x,CurrentSysName,Unit,Chs]=hl2adb(CurrentShot,{'ref_1','ref_2'},'ecf');
            %a(:,1)=smooth(a(:,1),100);
            %a(:,2)=smooth(a(:,2),100)-0.844;
            AmpIQ=sqrt(a(:,1).^2+a(:,2).^2);
            
            %plot(t,a(:,1)./AmpIQ,t,a(:,2)./AmpIQ);
            
            phi0=atan2(a(:,2)./AmpIQ,a(:,1)./AmpIQ);
            %phi=unwrap(phi0);
            phi=phi0;
            phi=phi-min(phi(1:5e3));
            y=1.184e6*31e9*phi/0.12/1e19;
            
            
        case {'@DH','@Dh','@dh'}
            myCurrentChannel={'FBIpol_04' 'FBIpol_13' 'FBIpol_08' 'FBIpol_08' 'FBIrad_08' 'FBIrad_18'};
            [z,x,CurrentSysName,Unit,Chs]=hl2adb(CurrentShot,myCurrentChannel,'VX1');
            y(:,1)=9.41*(z(:,2)-z(:,1))./(z(:,2)+z(:,1))+51.91*(z(:,5)+z(:,6))./(z(:,2)+z(:,1))+2.52;
            y(find(y>5))=5;
            y(find(y<-5))=-5;


        case {'@IP','@ip'}
            [y,x,CurrentSysName,Unit]=GetIp(CurrentShot);
            
       case {'@IP1','@ip1'}
    %[IP_001]*0.84102+[IP_002]*0.84929+[IP_003]*0.84299+[IP_004]*0.80954+[IP_005]*0.84108+[IP_006]*0.80954+[IP_007]*0.84592+[IP_008]*0.84975+[IP_009]*0.84793-[Comp_OH]*0.459+0.54*[Comp_Bv]+8*[Imp1_3]-8*[Imp2_Mc]+3.05*[Comp_Bt] 
           
            myCurrentChannel={'IP_001' 'IP_002' 'IP_003' 'IP_004' 'IP_005' 'IP_006' 'IP_007' 'IP_008' 'IP_009' 'Comp_OH' 'Comp_Bv' 'Comp_Bt'};
            [z,x]=hl2adb(CurrentShot,myCurrentChannel,'','','10000hz','VAX');
            myCurrentChannel={'Imp1_3' 'Imp2_Mc'};
            [z1,x]=hl2adb(CurrentShot,myCurrentChannel,x(1),x(end),'10000hz','MMD');
            
            y=z(:,1)*0.84102+z(:,2)*0.84929+z(:,3)*0.84299+z(:,4)*0.80954+z(:,5)*0.84108+z(:,6)*0.80954+z(:,7)*0.84592+z(:,8)*0.84975+z(:,9)*0.84793-z(:,10)*0.459+0.54*z(:,11)+8*z1(:,1)-8*z1(:,2)+3.05*z(:,12);
%             y=8*z1(:,1)-8*z1(:,2);
           
            
            
        case {'@x4','@X4'}
            [y,x,CurrentSysName,Unit]=hl2adb(CurrentShot,'3Axis_g4X','','','','ZDA');
            delT=(x(2)-x(1))*0.001;
            v(1)=0;
            s(1)=0;
            
%             %v = fnval(csapi(x,y),x); 
%               v1 = fnval(fnint(csapi(x,y),0),x); 
%               t1=toc;
% %             
%             z=sum(y);

            for i=2:length(x)
              v(i)=v(i-1)+y(i-1)+y(i);  
              s(i)=s(i-1)+v(i-1)+v(i);  
            end

            y(:,1)=delT/2*v'*1000;
            y(:,2)=delT/2*delT/2*s'*1000000;
            
            
            
            
        case {'@y4','@Y4'}
            [y,x,CurrentSysName,Unit]=hl2adb(CurrentShot,'3Axis_g4Y','','','','ZDA');
            delT=(x(2)-x(1))*0.001;
            v(1)=0;
            s(1)=0;
            
            for i=2:length(x)
              v(i)=v(i-1)+delT*(y(i-1)+y(i))/2;  
              s(i)=s(i-1)+delT*(v(i-1)+v(i))/2;  
            end
            y(:,1)=v'*1000;
            y(:,2)=s'*1000000;
            
            
            
            
            
            
        case {'@ccdh','@ccDh'}
            [y,x,CurrentSysName,Unit]=hl2adb(CurrentShot,'ccPH','','','','ccs');
            y=y/100;
        case {'@ccdv','@ccDv'}
            [y,x,CurrentSysName,Unit]=hl2adb(CurrentShot,'ccPV','','','','ccs');
            y=y/100;
        case {'@BT','@bt'}
            [y,x,CurrentSysName,Unit,Chs]=hl2adb(CurrentShot,'it_em','','','','em8');
            if isempty(y)
                [z1,x,CurrentSysName,Unit,Chs]=hl2adb(CurrentShot,'i1_tf','','','','pob');
                [z2,x,CurrentSysName,Unit,Chs]=hl2adb(CurrentShot,'i2_tf','','','','pob');
                y=z1+z2;
            end
            y=0.0622*y;
        case {'@vlfilter','@VLFILTER','@vl_filter','@VL_FILTER'}
            myCurrentChannel={'Vl_01' 'Vl_02' 'Vl_03' 'Vl_04' 'Vl_05' 'Vl_06' 'Vl_07' 'Vl_08' 'Vl_09'};
            [z,x,CurrentSysName,Unit,Chs]=hl2adb(CurrentShot,myCurrentChannel,'VAX');
            y=sum(z,2)/9;
%             y=smooth(y,201,'lowess');
            y=smooth(y,201,'moving');
            
        case '@fluxdh'
            [Fiu,x,CurrentSysName,Unit]=hl2adb(CurrentShot,'Fay_I_u','','','','fbc');
            [Fid,x]=hl2adb(CurrentShot,'Fay_I_d','','','','fbc');
            [Fou,x]=hl2adb(CurrentShot,'Fay_o_u','','','','fbc');
            [Fod,x]=hl2adb(CurrentShot,'Fay_o_d','','','','fbc');
            [D11,x]=hl2adb(CurrentShot,'Dshift_11','','','','fbc');
            [D21,x]=hl2adb(CurrentShot,'Dshift_21','','','','fbc');
            [D13,x]=hl2adb(CurrentShot,'Dshift_13','','','','fbc');
            [D23,x]=hl2adb(CurrentShot,'Dshift_23','','','','fbc');
            [D15,x]=hl2adb(CurrentShot,'Dshift_15','','','','fbc');
            [D25,x]=hl2adb(CurrentShot,'Dshift_25','','','','fbc');
            [D17,x]=hl2adb(CurrentShot,'Dshift_17','','','','fbc');
            [D27,x]=hl2adb(CurrentShot,'Dshift_27','','','','fbc');
            [Ip,x]=hl2adb(CurrentShot,'FbExIp','','','','fbc');

            Fayiu=Fiu+0.0866*(D21-(D21-D11)*0.537);
            Fayid=Fid+0.0866*(D23-(D23-D13)*0.537);
            Fayou=Fou+0.2054*(D25-(D25-D15)*0.9815);
            Fayod=Fod+0.2054*(D27-(D27-D17)*0.9815);

            Ip(find(abs(Ip)<20))=20;


            y1=(Fayou+Fayod-Fayiu-Fayid)./Ip*1000;
            ind=find(y1>10);
            %y1(ind)=10;
            y2=(Fayou-Fayod+Fayiu-Fayid)./Ip*10000;
            ind=find(y2>10);
            %y2(ind)=10;
            y=[y1,y2];
        case '@dhc'
            [FBIpol_13,x,CurrentSysName,Unit]=hl2adb(CurrentShot,'FBIpol_13','','','','VX1');
            [FBIpol_04,x]=hl2adb(CurrentShot,'FBIpol_04','','','','VX1');
            [FBIrad_08,x]=hl2adb(CurrentShot,'FBIrad_08','','','','VX1');
            [FBIrad_18,x]=hl2adb(CurrentShot,'FBIrad_18','','','','VX1');
            [FBIpol_08,x]=hl2adb(CurrentShot,'FBIpol_08','','','','VX1');
            [FBIpol_18,x]=hl2adb(CurrentShot,'FBIpol_18','','','','VX1');

            FBIpol_13=-FBIpol_13;
            FBIpol_04=-FBIpol_04;
            %[FBIrad_08,x]=hl2adb(CurrentShot,'FBIrad_08','','','','fbc');
            FBIrad_18=-FBIrad_18;
            %[FBIpol_08,x]=hl2adb(CurrentShot,'FBIpol_08','','','','fbc');
            FBIpol_18=-FBIpol_18;
            mySingle=FBIpol_13+FBIpol_04;
            mySingle(find(abs(mySingle)<0.0001))=1000;
            y1= 9.41 *(FBIpol_13-FBIpol_04)./mySingle+51.91*(FBIrad_08+FBIrad_18)./mySingle+2.52;
            y2= 63.92 * (FBIpol_08 + FBIpol_18) ./ mySingle - 3;
            y3=-82.79*(FBIrad_08+FBIrad_18)./mySingle-3;
            y=[y1,y2,y3];
        case {'@FLUX','@flux'}
            [ioh,x,CurrentSysName,Unit,Chs]=hl2adb(CurrentShot,'ioh','','','','mmd');
            y=0.084*ioh;
            Unit='Wb';
            CurrentSysName='mmc';

        case {'@ie1toipfbc','@Ie1toIpFbc'}
            [FEx_Ie1,x]=hl2adb(CurrentShot,'FEx_Ie1','','','','fbc');
            %[FEx_Ie2,x]=hl2adb(CurrentShot,'FEx_Ie2','','','','fbc');
            [fex_Ip,x]=hl2adb(CurrentShot,'FEx_Ip','','','','fbc');
            fex_Ip(abs(fex_Ip)<3)=10000;
            y=FEx_Ie1./fex_Ip;
        case {'@ie2toie1fbc','@Ie2toIe1Fbc'}
            [FEx_Ie1,x]=hl2adb(CurrentShot,'FEx_Ie1','','','','fbc');
            [FEx_Ie2,x]=hl2adb(CurrentShot,'FEx_Ie2','','','','fbc');
            %[FEx_Ip,x]=hl2adb(CurrentShot,'FEx_Ip','','','','fbc');
            FEx_Ie1(abs(FEx_Ie1)<0.2)=10000;
            y=FEx_Ie2./FEx_Ie1;
        case {'@ie2toie1mmc','@Ie2toIe1Mmc'}
            [impe1,x]=hl2adb(CurrentShot,'impe1','','','','mmc');
            [impe2,x]=hl2adb(CurrentShot,'impe2','','','','mmc');
            %[FEx_Ip,x]=hl2adb(CurrentShot,'FEx_Ip','','','','fbc');
            impe1(abs(impe1)<0.2)=10000;
            y=impe2./impe1;
        case {'@G4_FW','@g4_fw'}
            [g4_fw,x]=hl2adb(CurrentShot,'g4_fw','','','','lhd');
            y=smooth(g4_fw,51,'lowess');
        case {'@VL','@vl'}
            [vl,x]=hl2adb(CurrentShot,'vl','','','','vax');
            y=smooth(vl,51,'lowess');
        case {'@VL_01','@vl_01'}
            [vl,x]=hl2adb(CurrentShot,'vl_01','','','','vax');
            y=smooth(vl,51,'lowess');
        case {'@VL_02','@vl_02'}
            [vl,x]=hl2adb(CurrentShot,'vl_02','','','','vax');
            y=smooth(vl,51,'lowess');
        case {'@ECRH3','@ecrh3'}
            [vl,x]=hl2adb(CurrentShot,'ecrh3','','','','lhd');
            y=smooth(vl,51,'lowess');
        case {'@MGdSumU3','@mgdsumu3'}
            [z,x]=hl2adb(CurrentShot,'mgdsumu3','','','','mge');
            y=smooth(z,31,'lowess');
        case '@adu3'
            [z,x]=hl2adb(CurrentShot,'mgdsumu3','','','','mge');
            ya=sum(z)/length(z);
            y(1:length(z),1)=ya;
        case {'@Tedd1','@tedd1'}
            myCurrentChannel={'epd03' 'epd02'};
            [z,x]=hl2adb(CurrentShot,myCurrentChannel,'','','','epc');
            y=28.8*abs(z(:,1)-z(:,2));
        case {'@Tedd3','@tedd3'}
            myCurrentChannel={'epd09' 'epd08'};
            [z,x]=hl2adb(CurrentShot,myCurrentChannel,'','','','epc');
            y=28.8*abs(z(:,1)-z(:,2));
        case {'@Tedd5','@tedd5'}
            myCurrentChannel={'epd15' 'epd14'};
            [z,x]=hl2adb(CurrentShot,myCurrentChannel,'','','','epc');
            y=28.8*abs(z(:,1)-z(:,2));
        case {'@Tedd7','@tedd7'}
            myCurrentChannel={'epd21' 'epd20'};
            [z,x]=hl2adb(CurrentShot,myCurrentChannel,'','','','epc');
            y=28.8*abs(z(:,1)-z(:,2));
        case {'@Tedd8','@tedd8'}
            myCurrentChannel={'epd24' 'epd23'};
            [z,x]=hl2adb(CurrentShot,myCurrentChannel,'','','','epc');
            y=28.8*abs(z(:,1)-z(:,2));
        case {'@Tedd10','@tedd10'}
            myCurrentChannel={'epd30' 'epd29'};
            [z,x]=hl2adb(CurrentShot,myCurrentChannel,'','','','epc');
            y=28.8*abs(z(:,1)-z(:,2));
        case {'@Tedd12','@tedd12'}
            myCurrentChannel={'epd36' 'epd35'};
            [z,x]=hl2adb(CurrentShot,myCurrentChannel,'','','','epd');
            y=28.8*abs(z(:,1)-z(:,2));
        case {'@Tedd14','@tedd14'}
            myCurrentChannel={'epd42' 'epd41'};
            [z,x]=hl2adb(CurrentShot,myCurrentChannel,'','','','epd');
            y=28.8*abs(z(:,1)-z(:,2));
        case {'@FbSumdUoh','@fbsumduoh'}
            [z,x]=hl2adb(CurrentShot,'fbsumduoh','','','','fbc');
            y=smooth(z,31,'lowess');
        case '@aduoh'
            [z,x]=hl2adb(CurrentShot,'fbsumduoh','','','','fbc');
            ya=sum(z)/length(z);
            y(1:length(z),1)=ya;
        case {'@FSumdUvf','@fsumduvf'}
            [z,x]=hl2adb(CurrentShot,'fsumduvf','','','','fbc');
            y=smooth(z,31,'lowess');
        case '@aduvf'
            [z,x]=hl2adb(CurrentShot,'fsumduvf','','','','fbc');
            ya=sum(z)/length(z);
            y(1:length(z),1)=ya;
        case {'@FSumdUrf','@fsumdurf'}
            [z,x]=hl2adb(CurrentShot,'fsumdurf','','','','fbc');
            y=smooth(z,31,'lowess');
        case '@adurf'
            [z,x]=hl2adb(CurrentShot,'fsumdurf','','','','fbc');
            ya=sum(z)/length(z);
            y(1:length(z),1)=ya;
        case {'@ITF','@itf'}
            [z1,x]=hl2adb(CurrentShot,'i1_tf','','','','pob');
            [z2,x]=hl2adb(CurrentShot,'i2_tf','','','','pob');
            y=z1+z2;
        case {'@IVF','@ivf'}
            [z1,x]=hl2adb(CurrentShot,'i2-vf','','','','poe');
            [z2,x]=hl2adb(CurrentShot,'i4-vf','','','','poe');
            y=z1+z2;
        case {'@VUV','@vuv'}
            [z,x]=hl2adb(CurrentShot,'vuv','','','','sx2');
            y=smooth(z,31,'lowess');
        case {'@NEH','@neh'}
            [z,x]=hl2adb(CurrentShot,'pshcn4','','','','hcn');
            y=z*4.2;
        case {'@NE1','@ne1'}
            [z,x]=hl2adb(CurrentShot,'fir_sph1a','','','','ne1');
            y=abs(z)*3.22/3600;
        case {'@NE2','@ne2'}
            [z,x]=hl2adb(CurrentShot,'fir_sph2a','','','','ne1');
            y=abs(z)*3.22/3600;
        case {'@NE3','@ne3'}
            [z,x]=hl2adb(CurrentShot,'fir_sph3a','','','','ne1');
            y=abs(z)*3.22/3600;
        case {'@NE4','@ne4','@ne_fir','@ne_FIR'}
            [z,x]=hl2adb(CurrentShot,'fir_sph4a','','','','ne1');
            y=abs(z)*3.22/3600;
        case {'@PH2P','@ph2p'}
            [Piep,x]=hl2adb(CurrentShot,'Piep','','','','tmm');
            [It,x1]=hl2adb(CurrentShot,'it','','','','mmd');
            %[It,x1]=hl2adb(CurrentShot,'@itf','','','','pob');

            [Piip,x2]=hl2adb(CurrentShot,'Piip','','','','tmm');
            %interpolation algorithm is needed
            %[i1,x2] = jround(x1,x);%function jround from french colleague, i1 is the index of x1 close to the corresponding x
            if  length(x1)<1 || length(x2)<1
            else
                i1=interp1(x1,[1:length(x1)],x,'nearest','extrap');
                It1=abs(It(i1));
                
                i2=interp1(x2,[1:length(x2)],x,'nearest','extrap');
                Piip1=Piip(i2);
                
                y=(0.1288.*((Piip1-0.072)./(Piep-(Piip1-0.072)*10^-3))-3*10^-7)./(0.0898.*It1+1);
            end
        case {'@PH2','@ph2'}
            [Pie,x]=hl2adb(CurrentShot,'Pie','','','','tmm');
            [It,x1]=hl2adb(CurrentShot,'it','','','','mmd');
            %[It,x1]=hl2adb(CurrentShot,'@itf','','','','pob');
            [Pii,x2]=hl2adb(CurrentShot,'Pii','','','','tmm');
            %interpolation algorithm is needed
            %[i1,x2] = jround(x1,x);%function jround from french colleague, i1 is the index of x1 close to the corresponding x
            if  length(x1)<1 || length(x2)<1
                return
            end
            i1=interp1(x1,[1:length(x1)],x,'nearest','extrap');
            It1=abs(It(i1));
            i2=interp1(x2,[1:length(x2)],x,'nearest','extrap');
            Pii1=Pii(i2);
            y=(0.5613.*((Pii1+0.046)./(Pie-(Pii1+0.046)*10^-2))-3*10^-7)./(0.0743*It1+1);

        case {'@PD2P','@pd2p'}
            [Piep,x]=hl2adb(CurrentShot,'Piep','','','','tmp');
            [It,x1]=hl2adb(CurrentShot,'it','','','','mmc');
            %[It,x1]=hl2adb(CurrentShot,'@itf','','','','pob');

            [Piip,x2]=hl2adb(CurrentShot,'Piip','','','','tmp');
            %interpolation algorithm is needed
            %[i1,x2] = jround(x1,x);%function jround from french colleague, i1 is the index of x1 close to the corresponding x
            if  length(x1)<1 || length(x2)<1
                return
            end

            i1=interp1(x1,[1:length(x1)],x,'nearest','extrap');
            It1=abs(It(i1));
            i2=interp1(x2,[1:length(x2)],x,'nearest','extrap');
            Piip1=Piip(i2);
            y1=(0.1288.*((Piip1-0.072)./(Piep-(Piip1-0.072)*10^-3))-3*10^-7)./(0.0898.*It1+1);


            [Pie,x]=hl2adb(CurrentShot,'Pie','','','','tmp');
            [Pii,x2]=hl2adb(CurrentShot,'Pii','','','','tmp');
            i2=interp1(x2,[1:length(x2)],x,'nearest','extrap');
            Pii1=Pii(i2);
            y2=(0.5613.*((Pii1+0.046)./(Pie-(Pii1+0.046)*10^-2))-3*10^-7)./(0.0743*It1+1);
            y=y2./y1;

        case {'@xww','@XWW'}
            [z1,x]=hl2adb(CurrentShot,'mr1','','','','mwr');
            z1=smooth(z1,301,'lowess');
            [z2,x]=hl2adb(CurrentShot,'mr1','','','','mwr');
            z2=smooth(z2,301,'lowess');
            [z3,x]=hl2adb(CurrentShot,'mr1','','','','mwr');
            z3=smooth(z3,301,'lowess');
            [z4,x]=hl2adb(CurrentShot,'mr1','','','','mwr');
            z3=smooth(z3,301,'lowess');
            y=[x,z1,z2,z3,z4];
            %y=smooth(z,31,'lowess');
        case {'@WI2R','@wi2r'}
            [z,x]=hl2adb(CurrentShot,'it','','','','mmc');

            y=sum(z.*z);
            y=0.06*(x(101)-x(1))/100*y*0.001;
        case {'@POH','@poh'}
            ts=500; %?
            te=8000; %?
            [ip,x]=hl2adb(CurrentShot,'fex_ip');
            [vl,x1]=hl2adb(CurrentShot,'@vlfilter');

            %[i1,x2] = jround(xv,xip);%function jround from french colleague, i1 is the index of x1 close to the corresponding x
            i1=interp1(x1,[1:length(x1)],x,'nearest','extrap');
            i1(isnan(i1))=length(x1);
            v=vl(i1);

            P=ip.*v;
            P=smooth(P,201,'moving');
            
            
            load('matlab1.mat');
            Poh=P(ts:te);%kw
            x=data_diam(ts:te,5);

            tau=data_diam(ts:te,4);
            y(:,1)=tau;
            E=data_diam(ts:te,3);


            tau(find(abs(tau)>150))=0;
            E(find(abs(E)>150))=0;
            E=smooth(E,201,'lowess');
            dt=0.0001;
            dE=diff(E);
            dEdt(1,1)=0;
            dEdt(2:length(E),1)=dE(1:end)./dt;%kw
            dEdt(find(abs(dEdt)>300))=0;
            PE=Poh-dEdt;
            PE(find(abs(PE)<1))=1e4;
            tauE=E./PE;
            tauE(find(abs(tauE)>0.15))=0;
            y(:,1)=Poh;
            y(:,2)=E;%kJ
            y(:,3)=tau;
            y(:,4)=tauE*1000;%ms
            y(:,5)=dEdt;

        case {'@P_OH','@p_oh'}
            [ioh,x]=hl2adb(CurrentShot,'ioh');
            [voh,x]=hl2adb(CurrentShot,'voh');
            p=ioh.*voh;
            y=smooth(p,21,'lowess');
            
            

        case {'@POHMMC','@pohmmc'}
            [z1,x]=hl2adb(CurrentShot,'ioh','','','','mmc');
            [z2,x]=hl2adb(CurrentShot,'voh','','','','mmc');
            [ip,x1]=hl2adb(CurrentShot,'@ip','','','','vx1');
            %[i1,x2] = jround(x1,x);%function jround from french colleague, i1 is the index of x1 close to the corresponding x
            i1=interp1(x1,[1:length(x1)],x,'nearest','extrap');
            i1(isnan(i1))=length(x1);
            
            ip1=ip(i1);



            dI=diff(z1);
            dIoh(1)=0;
            dIoh(2:length(z1))=dI(1:end);
            dIoh=dIoh';
            y(:,1)=z1.*z2; %VI kW=kA*V
            y(:,2)=1/2*z1.*z1*0.016*1e3; %kA*kA*1000 %R=0.016 Ohm
            y(:,3)=0.0084.*z1.*dIoh*1e7;%R=0.016 Ohm, L=0.0084 Henry  frequency=10k
            y(:,4)=-0.000084.*ip1.*dIoh*1e7;%M=0.016 Ohm, L=0.000084 Henry  frequency=10k
            y(:,5)=y(:,1)-y(:,2)-y(:,3)-y(:,4);%R=0.016 Ohm, L=0.0084 Henry frequency=10k
            %y=1/2*z1.*z1*0.016*1e3;%R=0.016 Ohm, L=0.0084 Henry frequency=10k
            y(:,1)=smooth(y(:,1),401,'moving');%Poh
            y(:,2)=smooth(y(:,2),401,'moving');%Roh
            y(:,3)=smooth(y(:,3),401,'moving');%Loh
            y(:,4)=smooth(y(:,4),401,'moving');%iPoh
            y(:,5)=smooth(y(:,5),401,'moving');%

        case {'@v2i','@V2I'}
            [v,x]=hl2adb(CurrentShot,'nbhf_i3varc','','','','if1');
            [i,x]=hl2adb(CurrentShot,'nbhf_i3iarc','','','','if1');
            figure
            plot(i,v)
            ind=find(i<10);
            i(ind)=10000000;
            y=v./i;
            title(strcat('v/i for ',' shot:',num2str(CurrentShot)))
            xlabel('arc current/ unit: A')
            ylabel('arc voltage/ unit: V')

        case {'@v2islow','@V2ISLOW'}
            [v,x]=hl2adb(CurrentShot,'nbhe_i4varc','','','','ih2');
            [i,x]=hl2adb(CurrentShot,'nbhe_i4iarc','','','','ih2');
            figure
            plot(i,v)
            ind=find(abs(i)<0.1);
            i(ind)=1000;
            y=v./i;
            title(strcat('v/i for ',' shot:',num2str(CurrentShot),' in slow sampling'))
            xlabel('arc current/ unit: A')
            ylabel('arc voltage/ unit: V')
        case {'@Prad','@prad','@PRAD'}
            myCurrentChannel={'BOLM00' 'BOLM01' 'BOLM02' 'BOLM03' 'BOLM04' 'BOLM05' 'BOLM06' 'BOLM07' 'BOLM08' 'BOLM09' 'BOLM10' 'BOLM11' 'BOLM12' 'BOLM13' 'BOLM14' 'BOLM15'};
            [z,x,CurrentSysName,Unit]=hl2adb(CurrentShot,myCurrentChannel,'','','','BLM');
            %y=12.65842*(BOLM14*16.88916*0.0684+BOLM12*15.80043*0.0397+BOLM10*14.85742*0.0436+BOLM08*14.06012*0.0475+BOLM06*26.81706/2*0.0512+BOLM04*25.80531/2*0.0544+BOLM02*25.08499/2*0.0571+BOLM00*24.6561/2*0.059+BOLM01*24.51863/2*0.0598+BOLM03*24.67259/2*0.0596+BOLM05*25.11798/2*0.0583+BOLM07*25.8548/2*0.0562+BOLM09*13.44152*0.0532+BOLM11*14.10136*0.0497+BOLM13*14.90691*0.0458+BOLM15*31.71634*0.0417);
            %y(:,1)=12.65842*(BOLM14*16.88916*0.0684+BOLM12*15.80043*0.0397+BOLM10*14.85742*0.0436+BOLM08*14.06012*0.0475+BOLM06*26.81706/2*0.0512+BOLM04*25.80531/2*0.0544+BOLM02*25.08499/2*0.0571+BOLM00*24.6561/2*0.059+BOLM01*24.51863/2*0.0598+BOLM03*24.67259/2*0.0596+BOLM05*25.11798/2*0.0583+BOLM07*25.8548/2*0.0562+BOLM09*13.44152*0.0532+BOLM11*14.10136*0.0497+BOLM13*14.90691*0.0458+BOLM15*31.71634*0.0417);
            %y(:,2)=3.36936*(BOLM14*1.31557+BOLM12*2.668+BOLM10*2.73989+BOLM08*2.80085+BOLM06*2.84836+BOLM04*2.88385+BOLM02*2.90066+BOLM00*2.89842+BOLM01*2.89842+BOLM03*2.90066+BOLM05*2.88385+BOLM07*2.84836+BOLM09*2.80085+BOLM11*2.73989+BOLM13*2.668+BOLM15*1.31557);
            y=3.36936*(z(:,15)*1.31557+z(:,13)*2.668+z(:,11)*2.73989+z(:,9)*2.80085+z(:,7)*2.84836+z(:,5)*2.88385+z(:,3)*2.90066+z(:,1)*2.89842+z(:,2)*2.89842+z(:,4)*2.90066+z(:,6)*2.88385+z(:,8)*2.84836+z(:,10)*2.80085+z(:,12)*2.73989+z(:,14)*2.668+z(:,16)*1.31557);
            %y=[y1;y2];

        case {'@pion','@PION'}
            myCurrentChannel={'NBLF_I1VAcc' 'NBLF_I2VAcc' 'NBLF_I3VAcc' 'NBLF_I4VAcc' 'NBLF_I1IDec' 'NBLF_I2IDec' 'NBLF_I3IDec' 'NBLF_I4IDec'};
            [z1,x1,CurrentSysName,Unit]=hl2adb(CurrentShot,myCurrentChannel,'','','','IF3');
            myCurrentChannel={'NBHE_I1IAcc' 'NBHE_I2IAcc'};
            [z2,x2,CurrentSysName,Unit]=hl2adb(CurrentShot,myCurrentChannel,'','','','IH1');
            myCurrentChannel={'NBHE_I3IAcc' 'NBHE_I4IAcc'};
            [z3,x,CurrentSysName,Unit]=hl2adb(CurrentShot,myCurrentChannel,'','','','IH2');
            if isempty(z1)  || isempty(z2) || isempty(z3)
                warnstr=strcat('No NBI heating in /',num2str(CurrentShot));%promt no nbi for this shot
                warndlg(warnstr)
                return
            end
            i1=interp1(x1,[1:length(x1)],x,'nearest','extrap');
            i2=interp1(x2,[1:length(x2)],x,'nearest','extrap');
            y=(z1(i1,1).*(z2(i2,1)-0.5*z1(i1,5))+z1(i1,2).*(z2(i2,2)-0.5*z1(i1,6))+z1(i1,3).*(z3(:,1)-0.5*z1(i1,7))+z1(i1,4).*(z3(:,2)-0.5*z1(i1,8)))*0.4;
            Unit='kW';
        case {'@NBI','@nbi'}
            myCurrentChannel={'NBHE_I1IAcc' 'NBHE_I2IAcc' 'NBLE_I1VAcc' 'NBLE_I2VAcc' 'NBLE_I1IDec' 'NBLE_I2IDec'};
            [z2,x2]=hl2adb(CurrentShot,myCurrentChannel,'','','','IH1');
            myCurrentChannel={'NBHE_I3IAcc' 'NBHE_I4IAcc' 'NBLE_I3VAcc' 'NBLE_I4VAcc' 'NBLE_I3IDec' 'NBLE_I4IDec'};
            [z3,x]=hl2adb(CurrentShot,myCurrentChannel,'','','','IH2');
            if length(x2)<2 || length(x)<2
                y=zeros(size(x));
                warnstr=strcat('No NBI heating in /',num2str(CurrentShot));%promt no nbi for this shot
                warndlg(warnstr)
            else
                i2=interp1(x2,[1:length(x2)],x,'nearest','extrap');
                y=(z2(i2,3).*(z2(i2,1)-0.5*z2(i2,5))+z2(i2,4).*(z2(i2,2)-0.5*z2(i2,6))+z3(:,3).*(z3(:,1)-0.5*z3(:,5))+z3(:,4).*(z3(:,2)-0.5*z3(:,6)))*0.4;
                Unit='kW';
            end
       case {'@NBI2','@nbi2'}
           % ([N2I2HSVIacc]*[N2I2HSIACC]+[N2I3HSVIacc]*[N2I3HSIACC]+[N2I4HSVIacc]*[N2I4HSIACC])/1000*0.35           
            myCurrentChannel={'N2I1HSVIacc' 'N2I2HSVIacc' 'N2I3HSVIacc' 'N2I4HSVIacc'};
            [z2,x2]=hl2adb(CurrentShot,myCurrentChannel,'','','','IH4');
            
%            [w1,x]=hl2adb(CurrentShot,'N2I2HSIACC','','','','IFA');
            [w2,x]=hl2adb(CurrentShot,'N2I2HSIACC','','','','IFB');
            [w3,x]=hl2adb(CurrentShot,'N2I3HSIACC','','','','IFB');
            [w4,x]=hl2adb(CurrentShot,'N2I4HSIACC','','','','IFB');
            
            
            
            
            
            if length(x2)<2 || length(x)<2
                y=zeros(size(x));
                warnstr=strcat('No NBI heating in /',num2str(CurrentShot));%promt no nbi for this shot
                warndlg(warnstr)
            else
                i1=1:length(x);
                i2=interp1(x2,[1:length(x2)],x,'nearest','extrap');
                y=((z2(i2,2).*w2(i1,1)+z2(i2,3).*w3(i1,1)+z2(i2,4).*w4(i1,1)))/1000*0.35;
                Unit='kW';
            end
            
            
        case {'@PECRH','@pecrh','@Pecrh'}
            myCurrentChannel={'G1_Uk' 'G1_Ua' 'G1_Ik' 'G2_Uk' 'G2_Ua' 'G2_Ik'};
            [z1,x,CurrentSysName,Unit]=hl2adb(CurrentShot,myCurrentChannel,'','','','LHD');
            if isempty(z1)
                warnstr=strcat('No ECRH heating in /',num2str(CurrentShot));%promt no ECRH for this shot
                warndlg(warnstr)
                return
            end
            y=((z1(:,1)+z1(:,2)).*z1(:,3)+(z1(:,4)+z1(:,5)).*z1(:,6))*0.5;
        case {'@fitvl','@FITVL'}
            [z,x]=hl2adb(CurrentShot,'vl','','','','vax');
            [Z,X]=hl2adb(CurrentShot,'#OH','','','','vec');

            [X, m, n] = unique(X);
            prompt = {};
            def   = {};
            for i=1:length(X)
                prompt{i}=['point:',num2str(i)];
                def{i}=num2str(X(i));
            end


            if length(X)<=20
                dlg_title = 'Cancel the nodes for fitting ';
                num_lines= 1;
                answer  = inputdlg(prompt,dlg_title,num_lines,def);
                for i=1:length(answer)
                    if isempty(answer{i})% || strcmp(str2double(answer{i}),'NaN')
                        X(i)=[];
                    end
                end
            else
                dlg_title = 'Cancel the nodes for fitting ';
                num_lines= 1;
                answer  = inputdlg(prompt(1:20),dlg_title,num_lines,def(1:20));

                for i=1:20
                    if isempty(answer{i})% || strcmp(str2double(answer{i}),'NaN')
                        X(i)=[];
                    end
                end


                dlg_title = 'Cancel the nodes for fitting ';
                num_lines= 1;
                answer  = inputdlg(prompt(21:end),dlg_title,num_lines,def(21:end));

                for i=21:length(prompt)
                    if isempty(answer{i-20})
                        X(i)=[];
                    end
                end
            end







            dlg_title = 'Add the nodes for fitting ';
            prompt = {'Input the points 1','Input the points 2','Input the points 3','Input the points 4','Input the points 5','Input the points 6'};
            def   = {'6','400','500','','',''};
            num_lines= 1;
            answer  = inputdlg(prompt,dlg_title,num_lines,def);


            for i=1:length(answer)
                X1=str2double(answer{i});
                index=find(X1>X,1, 'last');
                if ~isempty(index)
                    X(index+2:end+1)=X(index+1:end);
                    X(index+1)=X1;
                end
            end


            [Y,X,y,x]=StepWiseCurveFit(z,x,X);
        case {'@fitioh','@FITIoh'}
            [Y,X,y,x]=StepWiseCurveFit(CurrentShot,'#OH','ioh');
        case {'@tene3','@TENE3'}
                    
              ShowWarning(0,'Please load three curves for TENE calculation!',handles)
              hTENE3.curveNum=0;  
              setappdata(0,'hTENE3',hTENE3)
              
              uiwait(handles.DP)
              hTENE3=getappdata(0,'hTENE3');
              
              
                    time1=hTENE3.t1;
                    time2=hTENE3.t2;
                    time3=hTENE3.t3;
                    data1=hTENE3.data1;
                    data2=hTENE3.data2;
                    data3=hTENE3.data3;
                    
                    name1=hTENE3.name1;
                    name2=hTENE3.name2;
                    name3=hTENE3.name3;
                    name1=strrep(name1,'_','\_');%tex
                    name2=strrep(name2,'_','\_');
                    name3=strrep(name3,'_','\_');
              
                    setappdata(0,'hTENE3',[])
                    
                    T=72.1*abs(data2-data1);
                    N=1.3*10^13*abs(data2-data3)./sqrt(0.02+abs(data2-data1));
                    
                    time=time1;
                    x=time1;
                    y(:,1)=T;
                    y(:,2)=N/1.0E13;
                    
                    
                    hTENE3=figure('Color',MyPicStruct.PicBackgroundColor,'Visible','on','name','Te and Ne from three Probes','Tag','threeProbes');
                    scrsz = get(0,'ScreenSize');
                    scrsz =0.98*scrsz;
                    set(hTENE3,'Units','pixels','Position',[1 32 scrsz(3) scrsz(4)-120]);
                    
                    axisNum=5;
                    HeightNumber(1:axisNum)=1;
                    hObject=hTENE3;
%%
                    [BkLeft,BkBottom,BkWidth,BkHeight]=getAxesProperty(hObject);
                    HeightUnit=BkHeight/(sum(HeightNumber)+0.5);
                    if MyPicStruct.GapMode==0  %control the YTick mode song mode or conventional mode
                        GapHeight=0; %control the gap height for conventional YTick mode
                    else
                        oldUnits=get(hObject,'Units');
                        oldPosition=get(hObject,'Position');
                        set(hObject,'Units','points');
                        newPosition=get(hObject,'Position');
                        set(hObject,'Units',oldUnits);
                        GapHeight=oldPosition(4)/newPosition(4)*MyPicStruct.DefaultAxesFontSize; %control the gap height for conventional YTick mode
                    end
                    
                    CurrentAxes=0;
 
                    for i=1:length(HeightNumber) %for location
                        Lnum=sum(HeightNumber(1:i));
                        CurrentAxes=CurrentAxes+1;
                        h(CurrentAxes)=axes('units','pixels','Position',[BkLeft BkBottom+BkHeight-HeightUnit*Lnum BkWidth HeightUnit*HeightNumber(i)-GapHeight]);%set the size
                    end
                     
 %%
                    
                                    plot(h(1),time,data1);set(h(1),'fontsize',14,'linewidth',2,'xminortick','on','yminortick','on'); set(h(1),'XTickLabel','');
                                    plot(h(2),time,data2);set(h(2),'fontsize',14,'linewidth',2,'xminortick','on','yminortick','on'); set(h(2),'XTickLabel','');
                                    plot(h(3),time,data3);set(h(3),'fontsize',14,'linewidth',2,'xminortick','on','yminortick','on');set(h(3),'XTickLabel','');
                                    
                                    plot(h(4),x,y(:,1));set(h(4),'fontsize',14,'linewidth',2,'xminortick','on','yminortick','on');set(h(4),'XTickLabel','');
                                    plot(h(5),x,y(:,2));set(h(5),'fontsize',14,'linewidth',2,'xminortick','on','yminortick','on');

                                    linkaxes(h(1:5),'x');
                                    
                                    
                                    
                                    
                                    set(get(h(1),'ylabel'),'string',[name1],'fontsize',14);
                                    set(get(h(2),'ylabel'),'string',[name2],'fontsize',14);
                                    set(get(h(3),'ylabel'),'string',[name3 ],'fontsize',14);
                                    set(get(h(4),'ylabel'),'string','T_e(eV)','fontsize',14);
                                    set(get(h(5),'ylabel'),'string','n_e(E13cm^{-3})','fontsize',14);
                                    
                                     
                                    for i=1:length(HeightNumber)-1 %for modifying the ytick
                                        myYlim=get(h(i),'ylim');
                                        [yMin,yMax,RightDigit]=ModifyYLimitTick(myYlim(1),myYlim(2),1);
                                        set(h(i),'ylim',[yMin yMax]);
                                        Yy=MyYTick(h(i),3,RightDigit);
                                    end
                    
                                    i=length(HeightNumber); %for modifying the ytick
                                        myYlim=get(h(i),'ylim');
                                        [yMin,yMax,RightDigit]=ModifyYLimitTick(myYlim(1),myYlim(2),1);
                                        set(h(i),'ylim',[yMin yMax]);
                                        Yy=MyYTick(h(i),3,RightDigit);
                                  
                     
                    
                     
              
              
      case {'@tene4','@TENE4'}
                    
            ShowWarning(0,'Please load four curves for TENE calculation!',handles)
              hTENE4.curveNum=0;  
              setappdata(0,'hTENE4',hTENE4)
              
              uiwait(handles.DP)
              hTENE4=getappdata(0,'hTENE4');
              
              
                    time1=hTENE4.t1;
                    time2=hTENE4.t2;
                    time3=hTENE4.t3;
                    time4=hTENE4.t4;
                    data1=hTENE4.data1;
                    data2=hTENE4.data2;
                    data3=hTENE4.data3;
                    data4=hTENE4.data4;
                    
                    name1=hTENE4.name1;
                    name2=hTENE4.name2;
                    name3=hTENE4.name3;
                    name4=hTENE4.name4;
                    name1=strrep(name1,'_','\_');%tex
                    name2=strrep(name2,'_','\_');
                    name3=strrep(name3,'_','\_');
                    name4=strrep(name4,'_','\_');
              
                    setappdata(0,'hTENE4',[])
                    
                    T=72.1*abs(data3-(data2+data1)/2);
                    N=1.3*10^13*abs(data4-data3)./sqrt(0.02+abs(data3-(data2+data1)/2));
                    
                    time=time1;
                    x=time1;
                    y(:,1)=T;
                    y(:,2)=N/1.0E13;
                    
                    
                    hTENE4=figure('Color',MyPicStruct.PicBackgroundColor,'Visible','on','name','Te and Ne from four Probes','Tag','fourProbes');
                    scrsz = get(0,'ScreenSize');
                    scrsz =0.98*scrsz;
                    set(hTENE4,'Units','pixels','Position',[1 32 scrsz(3) scrsz(4)-120]);
                    
                    axisNum=6;
                    HeightNumber(1:axisNum)=1;
                    hObject=hTENE4;
%%
                    [BkLeft,BkBottom,BkWidth,BkHeight]=getAxesProperty(hObject);
                    HeightUnit=BkHeight/(sum(HeightNumber)+0.5);
                    if MyPicStruct.GapMode==0  %control the YTick mode song mode or conventional mode
                        GapHeight=0; %control the gap height for conventional YTick mode
                    else
                        oldUnits=get(hObject,'Units');
                        oldPosition=get(hObject,'Position');
                        set(hObject,'Units','points');
                        newPosition=get(hObject,'Position');
                        set(hObject,'Units',oldUnits);
                        GapHeight=oldPosition(4)/newPosition(4)*MyPicStruct.DefaultAxesFontSize; %control the gap height for conventional YTick mode
                    end
                    
                    CurrentAxes=0;
 
                    for i=1:length(HeightNumber) %for location
                        Lnum=sum(HeightNumber(1:i));
                        CurrentAxes=CurrentAxes+1;
                        h(CurrentAxes)=axes('units','pixels','Position',[BkLeft BkBottom+BkHeight-HeightUnit*Lnum BkWidth HeightUnit*HeightNumber(i)-GapHeight]);%set the size
                    end
                     
 %%
                    
                                    plot(h(1),time,data1);set(h(1),'fontsize',14,'linewidth',2,'xminortick','on','yminortick','on'); set(h(1),'XTickLabel','');
                                    plot(h(2),time,data2);set(h(2),'fontsize',14,'linewidth',2,'xminortick','on','yminortick','on'); set(h(2),'XTickLabel','');
                                    plot(h(3),time,data3);set(h(3),'fontsize',14,'linewidth',2,'xminortick','on','yminortick','on');set(h(3),'XTickLabel','');
                                    
                                    plot(h(4),time,data4);set(h(4),'fontsize',14,'linewidth',2,'xminortick','on','yminortick','on');set(h(4),'XTickLabel','');
                                    plot(h(5),x,y(:,1));set(h(5),'fontsize',14,'linewidth',2,'xminortick','on','yminortick','on');set(h(5),'XTickLabel','');
                                    plot(h(6),x,y(:,2));set(h(6),'fontsize',14,'linewidth',2,'xminortick','on','yminortick','on');

                                    linkaxes(h(1:6),'x');
                                    
                                    
                                    
                                    
                                    set(get(h(1),'ylabel'),'string',[name1],'fontsize',14);
                                    set(get(h(2),'ylabel'),'string',[name2],'fontsize',14);
                                    set(get(h(3),'ylabel'),'string',[name3 ],'fontsize',14);
                                    set(get(h(4),'ylabel'),'string',[name4 ],'fontsize',14);
                                    set(get(h(5),'ylabel'),'string','T_e(eV)','fontsize',14);
                                    set(get(h(6),'ylabel'),'string','n_e(E13cm^{-3})','fontsize',14);
                                    
                                     
                                    for i=1:length(HeightNumber)-1 %for modifying the ytick
                                        myYlim=get(h(i),'ylim');
                                        [yMin,yMax,RightDigit]=ModifyYLimitTick(myYlim(1),myYlim(2),1);
                                        set(h(i),'ylim',[yMin yMax]);
                                        Yy=MyYTick(h(i),3,RightDigit);
                                    end
                    
                                    i=length(HeightNumber); %for modifying the ytick
                                        myYlim=get(h(i),'ylim');
                                        [yMin,yMax,RightDigit]=ModifyYLimitTick(myYlim(1),myYlim(2),1);
                                        set(h(i),'ylim',[yMin yMax]);
                                        Yy=MyYTick(h(i),3,RightDigit);
                                  
                     
                           
              
              
              
        case {'@crossp','@CROSSP'}
                    
                    ShowWarning(0,'Please load two curves for CPSD calculation!',handles)
                
                    hCPSD.curveNum=0;
                    setappdata(0,'hCPSD',hCPSD)
                    
                    uiwait(handles.DP)
                    hCPSD=getappdata(0,'hCPSD');
                    time1=hCPSD.t1;
                    time2=hCPSD.t2;
                    data1=hCPSD.data1;
                    data2=hCPSD.data2;
                    
                    name1=hCPSD.name1;
                    name2=hCPSD.name2;
                    name1=strrep(name1,'_','\_');%tex
                    name2=strrep(name2,'_','\_');

                    
                    if length(time1)==length(time2) && time1(1)==time2(1) && time1(end)==time2(end)
                        time=time1;
                    else
                        %max begin, max step, min end
                        time=max(time1(1),time2(1)):max(time1(2)-time1(1),time2(2)-time2(1)):min(time1(end),time2(end));
                        %sampling
                        index1=interp1(time1,[1:length(time1)],time,'nearest','extrap');
                        %                         index1(isnan(index1))=[];
                        data1=data1(index1);
                        index2=interp1(time2,[1:length(time2)],time,'nearest','extrap');
                        %                         index2(isnan(index2))=[];
                        data2=data2(index2);
                    end
                    
                    
                    
                    
                    
                    
                    
                    if length(time)>1 && (time(2)-time(1))>0
                        fs=1/(time(2)-time(1));% sample frequensy in kHz
                    else
                        error('SXM:time sequence is wrong!')
                    end
                 
                    setappdata(0,'hCPSD',[])
                     nfft=1024;  %系综长度
                     overlap=256;  %系综间重叠
                 %----定义系综
                 
                 M=fix((length(data1)-nfft)/(nfft-overlap))+1;%系综个数
                 for i=1:M
                     s1(:,i)=data1(nfft*(i-1)-overlap*(i-1)+1:nfft*i-overlap*(i-1),1);
                     s2(:,i)=data2(nfft*(i-1)-overlap*(i-1)+1:nfft*i-overlap*(i-1),1);
                     % delta_s1(:,i)=(s1(:,i)-mean(s1(:,i))).*hanning(nfft);% fluctuation
                     % delta_s2(:,i)=(s2(:,i)-mean(s2(:,i))).*hanning(nfft);
                     delta_s1(:,i)=(s1(:,i)).*hamming(nfft);% original
                     delta_s2(:,i)=(s2(:,i)).*hamming(nfft);
                     % test(i)=mean(delta_s(:,i))/sqrt(mean(delta_s(:,i).^2));%检验比值
                     P_s12(:,i)=(conj(fft(delta_s1(:,i)))).*(fft(delta_s2(:,i)));theta12=atan(-imag(P_s12)./real(P_s12)); %正表示从1传播到2
                     P_s21(:,i)=(conj(fft(delta_s2(:,i)))).*(fft(delta_s1(:,i)));theta21=atan(-imag(P_s21)./real(P_s21));%负表示从2传播到1
                 end
                 %----
                 for j=1:nfft
                     P12(j,:)=mean(abs(P_s12(j,:)));
                     P21(j,:)=mean(abs(P_s21(j,:)));
                     theta12(j,:)=mean(theta12(j,:));
                     theta21(j,:)=mean(theta21(j,:));
                     
                 end
                 f=fs*(0:nfft-1)/(nfft);% kHz
                 f=f(2:nfft/2);
                 P12=(P12(2:nfft/2,1));
                 P21=(P21(2:nfft/2,1));
                 theta12=(theta12(2:nfft/2,1));
                 theta21=(theta21(2:nfft/2,1));
                 theta12=(theta12.*180)./pi;
                 theta21=(theta21.*180)./pi;
                 
                 y=P12;
                 x=f;
                 

                   hCPSD=figure('Color',MyPicStruct.PicBackgroundColor,'Visible','on','name','freq_spectrum','Tag','freq_spectrum');
                    scrsz = get(0,'ScreenSize');
                    scrsz =0.98*scrsz;
                    set(hCPSD,'Units','pixels','Position',[1 32 scrsz(3) scrsz(4)-80]);
                    
                    axisNum=3;
                    HeightNumber(1:axisNum-1)=1;
                    HeightNumber(axisNum)=2;
                    hObject=hCPSD;
%%
                    [BkLeft,BkBottom,BkWidth,BkHeight]=getAxesProperty(hObject);
                    HeightUnit=BkHeight/(sum(HeightNumber)+0.5);
                    if MyPicStruct.GapMode==0  %control the YTick mode song mode or conventional mode
                        GapHeight=0; %control the gap height for conventional YTick mode
                    else
                        oldUnits=get(hObject,'Units');
                        oldPosition=get(hObject,'Position');
                        set(hObject,'Units','points');
                        newPosition=get(hObject,'Position');
                        set(hObject,'Units',oldUnits);
                        GapHeight=oldPosition(4)/newPosition(4)*MyPicStruct.DefaultAxesFontSize; %control the gap height for conventional YTick mode
                    end
                    
                    CurrentAxes=0;
 
                    for i=1:length(HeightNumber)-1 %for location
                        Lnum=sum(HeightNumber(1:i));
                        CurrentAxes=CurrentAxes+1;
                        h(CurrentAxes)=axes('units','pixels','Position',[BkLeft BkBottom+BkHeight-HeightUnit*Lnum BkWidth HeightUnit*HeightNumber(i)-GapHeight]);%set the size
                    end
                     
                    i=length(HeightNumber); %for location
                    Lnum=sum(HeightNumber(1:i))+0.5;
                    CurrentAxes=CurrentAxes+1;
                    h(CurrentAxes)=axes('units','pixels','Position',[BkLeft BkBottom+BkHeight-HeightUnit*Lnum BkWidth HeightUnit*HeightNumber(i)-GapHeight]);%set the size
%%
                    
                                    plot(h(1),time,data1);set(h(1),'fontsize',14,'linewidth',2,'xminortick','on','yminortick','on'); set(h(1),'XTickLabel','');
                                    plot(h(2),time,data2);set(h(2),'fontsize',14,'linewidth',2,'xminortick','on','yminortick','on');
                                    plot(h(3),x,y);set(h(3),'fontsize',14,'linewidth',2,'xminortick','on','yminortick','on');
                                    set(h(3), 'xscale', 'log');
                                    set(h(3), 'yscale', 'log');

                                    linkaxes(h(1:2),'x');
                                    
                                    set(get(h(1),'ylabel'),'string',[name1 '(au)'],'fontsize',14);
                                    set(get(h(2),'ylabel'),'string',[name2 '(au)'],'fontsize',14);
                                    set(get(h(2),'xlabel'),'string','time (ms)','fontsize',14);
                                    set(get(h(3),'ylabel'),'string','P12 (au)','fontsize',14);
                                    set(get(h(3),'xlabel'),'string','f (kHz)','fontsize',14);
                                    
                                    for i=1:length(HeightNumber)-1 %for modifying the ytick
                                        myYlim=get(h(i),'ylim');
                                        [yMin,yMax,RightDigit]=ModifyYLimitTick(myYlim(1),myYlim(2),1);
                                        set(h(i),'ylim',[yMin yMax]);
                                        Yy=MyYTick(h(i),3,RightDigit);
                                    end
                                  
%                                     i=length(HeightNumber); %for modifying the ytick
%                                     myYlim=get(h(i),'ylim');
%                                     [yMin,yMax,RightDigit]=ModifyYLimitTick(myYlim(1),myYlim(2),1);
%                                     set(h(i),'ylim',[yMin yMax]);
%                                     Yy=MyYTick(h(i),6,RightDigit);
 
                    
                    
                    
                    
                    
                    
                    
%                     
%                     left=0.15;bottom=0.15;width=0.78;height=0.83;delta_height=0.005;
%                     %                     h(2)=axes('units','normalized','position',[left,bottom ,width,0.45]);
%                     h(1)=axes('units','normalized','position',[left,bottom,width,0.6]);
%                     %                     plot(h(1),x,y); set(gca,'XTickLabel','');set(h(1),'fontsize',14,'linewidth',2,'xminortick','on','yminortick','on');
%                     plot(h(1),x,y);set(h(1),'fontsize',14,'linewidth',2,'xminortick','on','yminortick','on');
%                     set(get(h(1),'ylabel'),'string','P(au)','fontsize',14);
%                     set(get(h(1),'xlabel'),'string','f (kHz)','fontsize',14);
%                     
                    
                    
                    %                     pcolor(h(2),tout,f,(C));shading (h(2),'interp');set(h(2),'fontsize',14,'linewidth',2,'xminortick','on','yminortick','on');
                    %                     myTitle=strrep(CurrentChannel(2:end), '_','\_');  %;
                    %                     set(get(h(1),'title'),'string',['frequency spectrum of ' myTitle]);
                    %                     set(get(h(2),'ylabel'),'string','f (kHz)','fontsize',14);
                    %                     set(get(h(2),'xlabel'),'string','t (ms)','fontsize',14);
                    
                    
                    
                    
%                     allaxes = findall(gcf, 'type','axes');
%                     linkaxes(allaxes,'x');
                    
                 
                 
                 
%                  switch nargout
%                      case 2
%                          varargout{1}=f;
%                          varargout{2}=P12;
%                      case 3
%                          varargout{1}=f;
%                          varargout{2}=P12;
%                          varargout{3}=P21;
%                      case 5
%                          varargout{1}=f;
%                          varargout{2}=P12;
%                          varargout{3}=P21;
%                          varargout{4}=theta12;
%                          varargout{5}=theta21;
%                  end
            
        case {'@lb','@LB'}
            [z,x]=hl2adb(CurrentShot,'G2_ua');
            %calculate the fwhm
                   y=smooth(z,7,'lowess');

                    Half=max(y)/1.3;
                    i=find(y>Half);
                    deltaT=x(i(end))-x(i(1));
                    warndlg(strcat('the half width is ',num2str(deltaT),'ms'))
        case {'@prev','@PREV'}
%             try
                currentFolder='\\image\2ADAS\VacLog';
                
                if exist(currentFolder,'dir')~=7
                    
                    PasswordFile=fullfile(getDProot, '\psw.psw');
                    fid = fopen(PasswordFile,'r');
                    remain = fread(fid, '*char')';
                    status = fclose(fid);
                    [user, psw] = strtok(remain, [char(13) char(10)]);
                    [psw, remain] = strtok(psw, [char(13) char(10)]);
                    
                    
                    %RSA decryption
                    user=decrRSA(user,143,47);
                    psw=decrRSA(psw,143,47);
                    
                    myUserPwd=strcat('net use',char(31),currentFolder,char(31),psw,char(31), '/user:',user);
                    myUserPwd=strrep(myUserPwd,char(31),char(32));
                    dos(myUserPwd);
                end
            [FileName,PathName]=uigetfile('*.txt','Load the data file',[currentFolder '/']);
            dataFile=strcat(PathName,FileName);
            
            fid = fopen(dataFile,'r');
            remain = fread(fid, '*char')';
            status = fclose(fid);
            
%             if 0
%                 [FileName,PathName]=uigetfile('*.txt','Load the data file',[currentFolder '/']);
%                 dataFile=strcat(PathName,FileName);
%                 
%                 fid = fopen(dataFile,'r');
%                 remain1 = fread(fid, '*char')';
%                 status = fclose(fid);
%                 remain=[remain remain1];
%             end

            
            
            YMDpattern='^\d{1,4}-\d{1,2}-\d{1,2}(?=\D)';
            YMD=regexp(FileName,YMDpattern,'match');
            
%             Shotpattern='\d{5}(?=_)';
%             [start,Shot]=regexp(remain,shotPattern,'start','match','once');
%             remain=remain(1:start-1);
%             
            
%             timePattern=char(32);
%             pressurePattern=[char(13) char(10)];
%             shotPattern='(?<=\x{a}\x{d})\d{5}(?=_)';
            shotPattern='(?<=\s{2})\d{5}(?=_)';
            
            
%             tsPattern=['(?<=\D)\d{1,2}:\d{1,2}:\d{1,2}(?=:\o{40})'];
            tsPattern=['\d{1,2}:\d{1,2}:\d{1,2}(?=:\o{40})'];
%             pressurePattern=['(?<=:\o{40})\d{1}\.\d{1}E-d{1}(?=\x{a}\x{d})'];



            pressurePattern=['(?<=:\o{40})[\S]{6}(?=\s{2})'];
            
            
            tsPatternShot=['(?<=\d{5}_)\d{1,2}:\d{1,2}:\d{1,2}(?=:\o{40})'];
            pressurePatternShot=['(?<=\d{5}_\d{1,2}:\d{1,2}:\d{1,2}:\o{40})[\S]{6}(?=\s{2})'];
            
            Shot=regexp(remain,shotPattern,'match');
            ts=regexp(remain,tsPattern,'match');
            vs=regexp(remain,pressurePattern,'match');
            
            tsShot=regexp(remain,tsPatternShot,'match');
            vsShot=regexp(remain,pressurePatternShot,'match');
            
   
             
             
             Dnum=datenum([YMD{1} char(32) ts{1}], 'yyyy-mm-dd HH:MM:SS');
             startTime=ts{1};
             startTime=startTime(1:end-1);

             
             tsYMD=regexprep(ts,'(\d{1,2}:\d{1,2}:\d{1,2})',[YMD{1} char(32) '$1']);
             t =(datenum(tsYMD, 'yyyy-mm-dd HH:MM:SS')-Dnum)*24*60;
             v=cellfun(@str2num,vs);
             
             
             
             
             tsShot=regexprep(tsShot,'(\d{1,2}:\d{1,2}:\d{1,2})',[YMD{1} char(32) '$1']);
             tShot =(datenum(tsShot, 'yyyy-mm-dd HH:MM:SS')-Dnum)*24*60;
             vShot=cellfun(@str2num,vsShot);
             
         tsTop={''};    
         checkLen=20;   
         
        
         tTop=t(1);
         vTop=v(1);
         tsTop=ts(1);
         for i=1:length(Shot)
             tIndex=find(t==tShot(i));
             endIndex=tIndex+checkLen;
             if endIndex>length(v)
                 endIndex=length(v);
             end
             [C,Ind] = max(v(tIndex:endIndex));
             
             tTop(i) =t(tIndex(1)+Ind-1);
             vTop(i)=v(tIndex(1)+Ind-1);
             tsTop(i)=ts(tIndex(1)+Ind-1);
         end
         
         
         hShow.t=tTop;
         hShow.v=vTop;
         hShow.ts=tsTop;
         hShow.shot=Shot;
         
         
             
                hPressure=figure('ResizeFcn',@myResize);
              % hold on
                hBackground=semilogy(t,v,'--.b');
%                 line(tShot,vShot,'Color','r','Marker','*');
                hLine=line(tTop,vTop,'Color','r','Marker','o','LineStyle','none','MarkerSize',12,'LineWidth',4);
                hShow.hBackground=hBackground;
                hShow.hLine=hLine;
                
                setappdata(0,'remain',remain)
                cfgmenu=uimenu(hPressure, 'Label', 'showTime');
                
                cfgitem1= uimenu(cfgmenu, 'Label', 'showTime', 'Callback', {@showTime,hShow});
                cfgitem2 = uimenu(cfgmenu, 'Label', 'showShot', 'Callback', {@showShot,hShow});
                cfgitem3= uimenu(cfgmenu, 'Label', 'delText', 'Callback', {@delText,hShow});
                cfgitem4= uimenu(cfgmenu, 'Label', 'cmpTwoDay', 'Callback', {@cmpTwoDay,hShow});
                
                
                
                 
                
                ylabel('Pa');
                xlabel('Minute');
                myTitle=['Pressure start @' YMD{1} char(32) startTime char(13) char(10) 'Shot from ' Shot{1} ' to ' Shot{end} ' Total shot:' num2str(length(Shot))];
                title(myTitle);
%                text({tTop},{vTop},Shot);
%                 
%                 for i=1:length(Shot)
%                       text(tTop(i),vTop(i),[char(32) char(32) char(32) '\leftarrow' Shot{i}]);
%                 end
%                 
                setappdata(0,'pressureShow',[])
                figure(hPressure);

%             catch
%                 ii=0;
%             end
            y=v';
            x=t;

            
            
        otherwise
            Chs=CurrentChannel(2:length(CurrentChannel));
            switch lower(CurrentChannel(1))
                case '@' %smooth
                    [z,x,CurrentSysName,Unit]=hl2adb(CurrentShot,CurrentChannel(2:length(CurrentChannel)),CurrentSysName);
                    y=smooth(z,21,'lowess');
                    
                case '!' %zero drift
                    [z,x,CurrentSysName,Unit,Chs]=hl2adb(CurrentShot,CurrentChannel(2:length(CurrentChannel)),CurrentSysName);
                    zd=hl2azd(CurrentShot,CurrentChannel(2:length(CurrentChannel)),CurrentSysName);
                    y=z-zd;
                case '-' %base line
%                     hFreq=figure('Color','r','Visible','on','name','freq_spectrum','Tag','freq_spectrum');
%                     
%                     
%                     
%                     
%                     return
                    global  zdTstart zdTend
                    [y,x,CurrentSysName,Unit]=hl2adb(CurrentShot,CurrentChannel(2:length(CurrentChannel)),zdTstart,zdTend,[],CurrentSysName);
                    zd=hl2azd(CurrentShot,CurrentChannel(2:length(CurrentChannel)),CurrentSysName);
                    y(:)=zd;
                    
                    
                    
                case '_'
                    if nargin>=5 &&  exist('CurrentDataFile','var') &&  exist('CurrentDasInf','var') && ~isempty(CurrentDataFile) && ~isempty(CurrentDasInf)
                     [y,x,CurrentSysName,Unit]=hl2adb(CurrentShot,CurrentChannel(2:length(CurrentChannel)),'','','','',CurrentDataFile,CurrentDasInf);
                    else
                        [y,x,CurrentSysName,Unit]=hl2adb(CurrentShot,CurrentChannel(2:end),'','',1);  %should get all data for fft
                    end
                    %get the fft parameter from debug windows
                    myParam=get(handles.Debug1,'String');
                    if isempty(myParam) || length(myParam)<10
                        nfft=2048;
                        shift=128;
                        base=-60;%the base of spectrum,above of which,the spectrum values
                        % are nomalized between 0 and 1,and below of which,they are replaced by
                        % the base value.
                        colortype=1;% colormap label,if colortype is equal to 1,the colormap
                        % is hot,else it is gray.
                        label_signal=0;
                        myParamString=[num2str(nfft) ':' num2str(shift) ':' num2str(base) ':' num2str(colortype) ':' num2str(label_signal)];
                        set(handles.Debug1,'String',myParamString);
                    else
                            [nfft, myParam] = strtok(myParam, ':');
                            [shift, myParam] = strtok(myParam, ':');
                            [base, myParam] = strtok(myParam, ':');
                            [colortype, myParam] = strtok(myParam, ':');
                            label_signal =myParam(2:end);
                            
                            
                            nfft=str2double(nfft);
                            shift =str2double(shift);
                            base= str2double(base);
                            colortype= str2double(colortype);
                            label_signal =str2double(label_signal);
                    end
                     [tout,f,C]=autopower_t_f(y,x,nfft,shift,base,colortype,label_signal);
                    
                     if nargout==6
                         x=reshape(tout,[numel(tout),1]);
                         y=reshape(f,[numel(f),1]);
                         zMatrix=C;
                         Unit='kHz';
                         Chs=CurrentChannel;
                     else
                         hFreq=figure('Color',MyPicStruct.PicBackgroundColor,'Visible','on','name','freq_spectrum','Tag','freq_spectrum');
                         cfgmenu=uimenu(hFreq, 'Label', 'changeYlim');
                         cfgitem1= uimenu(cfgmenu, 'Label', 'changeYlim', 'Callback', {@changeYlim,hFreq});
                         %                     cfgitem2 = uimenu(cfgmenu, 'Label', 'showShot', 'Callback', {@showShot,hShow});
                         %                     cfgitem3= uimenu(cfgmenu, 'Label', 'delText', 'Callback', {@delText,hShow});
                         %
                         
                         
                         scrsz = get(0,'ScreenSize');
                         scrsz =0.98*scrsz;
                         set(hFreq,'Units','pixels','Position',[1 32 scrsz(3) scrsz(4)-80]);
                         
                         left=0.15;bottom=0.15;width=0.78;height=0.80;delta_height=0.005;
                         h(2)=axes('units','normalized','position',[left,bottom ,width,0.45]);
                         h(1)=axes('units','normalized','position',[left,0.66,width,0.2]);
                         plot(h(1),x,y); set(gca,'XTickLabel','');set(h(1),'fontsize',14,'linewidth',2,'xminortick','on','yminortick','on');
                         pcolor(h(2),tout,f,(C));shading (h(2),'interp');set(h(2),'fontsize',14,'linewidth',2,'xminortick','on','yminortick','on');
                         % add to curves
                         eventdata.x=tout;
                         eventdata.y=f;
                         eventdata.z=C;
                         eventdata.n=CurrentChannel;
                         eventdata.s=CurrentSysName;
                         
                         
                         addChnl([], eventdata, handles)
                         Chs=CurrentChannel(2:end);
                         myTitle=strrep(Chs, '_','\_');  %;
                         set(get(h(1),'title'),'string',['frequency spectrum of ' myTitle]);
                         set(get(h(2),'ylabel'),'string','f (kHz)','fontsize',14);
                         set(get(h(2),'xlabel'),'string','t (ms)','fontsize',14);
                         allaxes = findall(gcf, 'type','axes');
                         linkaxes(allaxes,'x');
                         
                         myFrequency=get(handles.Debug2,'String');
                         if isempty(myFrequency)  || length(myFrequency)<3
                             fMin=min(f);
                             fMax=max(f);
                             myFrequencyString=[num2str(fMin) ':' num2str(fMax)];
                             set(handles.Debug2,'String',myFrequencyString);
                         else
                             [fMin, myParam] = strtok(myFrequency, ':');
                             fMax =myParam(2:end);
                             
                             fMin=str2double(fMin);
                             fMax=str2double(fMax);
                             
                             
                         end
                         
                         set(h(2),'ylim',[fMin fMax])
                         set(h(2),'xlim',[x(1) x(end)])
                         setappdata(hFreq,'haxis',h)
                     end
                     
                    
            end %switch lower(CurrentChannel(1)) in otherwise
            
            %calculate the fwhm
            %         Half=max(y)/1.3;
            %         i=find(y>Half);
            %         deltaT=x(i(end))-x(i(1));
            %         warndlg(strcat('the width is ',num2str(deltaT),'ms'))
            % y=smooth(z,7,'lowess');

    end
%catch
    if isempty(x)
%         warnstr=strcat('The involved Channels may  not be found in Shot /',num2str(CurrentShot));%promt the need to update configuration
%         setappdata(0,'MyErr',warnstr);
%         warndlg(warnstr)
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
        varargout{3}=Chs;
    case 6
        varargout{1}=CurrentSysName;
        varargout{2}=Unit;
        varargout{3}=Chs;
        varargout{4}=zMatrix;
end%switch
end
%end

function cmpTwoDay(hObject, eventdata, hShow)
currentFolder='\\image\2ADAS\VacLog';
[FileName,PathName]=uigetfile('*.txt','Load the data file',[currentFolder '/']);
dataFile=strcat(PathName,FileName);

fid = fopen(dataFile,'r');
remain = fread(fid, '*char')';
status = fclose(fid);

% remain=[getappdata(0,'remain')];
% 
% remain=[remain remain1];

YMDpattern='^\d{1,4}-\d{1,2}-\d{1,2}(?=\D)';
YMD=regexp(FileName,YMDpattern,'match');

%             Shotpattern='\d{5}(?=_)';
%             [start,Shot]=regexp(remain,shotPattern,'start','match','once');
%             remain=remain(1:start-1);
%

%             timePattern=char(32);
%             pressurePattern=[char(13) char(10)];
%             shotPattern='(?<=\x{a}\x{d})\d{5}(?=_)';
shotPattern='(?<=\s{2})\d{5}(?=_)';


%             tsPattern=['(?<=\D)\d{1,2}:\d{1,2}:\d{1,2}(?=:\o{40})'];
tsPattern=['\d{1,2}:\d{1,2}:\d{1,2}(?=:\o{40})'];
%             pressurePattern=['(?<=:\o{40})\d{1}\.\d{1}E-d{1}(?=\x{a}\x{d})'];



pressurePattern=['(?<=:\o{40})[\S]{6}(?=\s{2})'];


tsPatternShot=['(?<=\d{5}_)\d{1,2}:\d{1,2}:\d{1,2}(?=:\o{40})'];
pressurePatternShot=['(?<=\d{5}_\d{1,2}:\d{1,2}:\d{1,2}:\o{40})[\S]{6}(?=\s{2})'];

Shot=regexp(remain,shotPattern,'match');
ts=regexp(remain,tsPattern,'match');
vs=regexp(remain,pressurePattern,'match');

tsShot=regexp(remain,tsPatternShot,'match');
vsShot=regexp(remain,pressurePatternShot,'match');




Dnum=datenum([YMD{1} char(32) ts{1}], 'yyyy-mm-dd HH:MM:SS');
startTime=ts{1};
startTime=startTime(1:end-1);


tsYMD=regexprep(ts,'(\d{1,2}:\d{1,2}:\d{1,2})',[YMD{1} char(32) '$1']);
t =(datenum(tsYMD, 'yyyy-mm-dd HH:MM:SS')-Dnum)*24*60;
v=cellfun(@str2num,vs);




tsShot=regexprep(tsShot,'(\d{1,2}:\d{1,2}:\d{1,2})',[YMD{1} char(32) '$1']);
tShot =(datenum(tsShot, 'yyyy-mm-dd HH:MM:SS')-Dnum)*24*60;
vShot=cellfun(@str2num,vsShot);

tsTop={''};
checkLen=20;


tTop=t(1);
vTop=v(1);
tsTop=ts(1);
for i=1:length(Shot)
    tIndex=find(t==tShot(i));
    endIndex=tIndex+checkLen;
    if endIndex>length(v)
        endIndex=length(v);
    end
    [C,Ind] = max(v(tIndex:endIndex));
    
    tTop(i) =t(tIndex(1)+Ind-1);
    vTop(i)=v(tIndex(1)+Ind-1);
    tsTop(i)=ts(tIndex(1)+Ind-1);
end


% hShow.x=t;
% hShow.y=v;
hShow.t=tTop;
hShow.v=vTop;
hShow.ts=tsTop;
hShow.shot=Shot;
setappdata(0,'pressureShow',hShow)

% set(hShow.hLine,'XData',tTop,'YData',vTop)
% set(hShow.hBackground,'XData',t,'YData',v)
hold on
hBackground2=semilogy(t,v,'--.m');
%                 line(tShot,vShot,'Color','r','Marker','*');
hLine2=line(tTop,vTop,'Color','k','Marker','o','LineStyle','none','MarkerSize',12,'LineWidth',4);
setappdata(0,'hT2',[]);


% for i=1:length(Shot)
%     hText(i)=     text(tTop(i),vTop(i),[char(32) char(32) char(32) '\leftarrow' tsTop{i}],'rotation',90);
% end
% setappdata(0,'hT2',hText);
end



function showTime(hObject, eventdata, hShow)
delText(hObject, eventdata, hShow)
tTop=hShow.t;
vTop =hShow.v;
tsTop =hShow.ts;
Shot=hShow.shot;
hText=[];

for i=1:length(Shot)
    hText(i)=     text(tTop(i),vTop(i),[char(32) char(32) char(32) '\leftarrow' tsTop{i}],'rotation',90);
end
setappdata(0,'hT1',hText);


hShow=getappdata(0,'pressureShow');
if ~isempty(hShow)
    tTop=hShow.t;
    vTop =hShow.v;
    tsTop =hShow.ts;
    Shot=hShow.shot;
    hText=[];

    for i=1:length(Shot)
        hText(i)=     text(tTop(i),vTop(i),[char(32) char(32) char(32) '\leftarrow' tsTop{i}],'rotation',90);
    end
    setappdata(0,'hT2',hText);
end
end





function showShot(hObject, eventdata, hShow)
delText(hObject, eventdata, hShow)
tTop=hShow.t;
vTop =hShow.v;
tsTop =hShow.ts;
Shot=hShow.shot;
hText=[];
for i=1:length(Shot)
    hText(i)=       text(tTop(i),vTop(i),[char(32) char(32) char(32) '\leftarrow' Shot{i}],'rotation',90);
end
setappdata(0,'hT1',hText);

hShow=getappdata(0,'pressureShow');
if ~isempty(hShow)
    tTop=hShow.t;
    vTop =hShow.v;
    tsTop =hShow.ts;
    Shot=hShow.shot;
    hText=[];
    for i=1:length(Shot)
        hText(i)=       text(tTop(i),vTop(i),[char(32) char(32) char(32) '\leftarrow' Shot{i}],'rotation',90);
    end
    setappdata(0,'hT2',hText);
end
end
    

function delText(hObject, eventdata, hShow)
hT1=getappdata(0,'hT1');
if ishandle(hT1)
    delete(hT1);
    setappdata(0,'hT1',[]);

end
hT2=getappdata(0,'hT2');
if ishandle(hT2)
    delete(hT2);
    setappdata(0,'hT2',[]);
end
end

function myResize(hObject, eventdata, hShow)
hT1=getappdata(0,'hT1');
if ishandle(hT1)
    delete(hT1);
    setappdata(0,'hT1',[]);

end
hT2=getappdata(0,'hT2');
if ishandle(hT2)
    delete(hT2);
    setappdata(0,'hT2',[]);
end
end

function changeYlim(hObject, eventdata, hFreq)
h=getappdata(hFreq,'haxis');
dlg_title = 'Set the frequency limit';
prompt = {'min','max'};
freq=get(h(2),'ylim');
def   = {num2str(freq(1)),num2str(freq(2))};
num_lines= 1;
answer=inputdlg(prompt,dlg_title,num_lines,def);
fMin=str2num(answer{1});
fMax=str2num(answer{2});
set(h(2),'ylim',[fMin fMax])
end

function s=ag_mm(sig)%Sign)
n=length(sig);
%Sign=Sign(end:-1:1);
Ag_t=5;%0.05 1;%0.165;%165;%0.25; 0.15 for L-I-L; 0.21 for LI-H averaged
N=floor(n/(1000*Ag_t));
k=floor(n/N);
for i=1:N
     index=(1+k*(i-1):k*i);
     s(i)=mean(sig(index)); % +12:imporve(km/s) 
end
end
