function  [y,x,Unit,varargout] = exl50Formula(CurrentShot,CurrentChannel,varargin)
global handles

Unit='';
z=[];
    switch lower(CurrentChannel)
        case {'@gaspre','@GASPRE'}
            [y,x]=exl50db(CurrentShot,'gas_pres02',varargin{:});
            %%   U=c+0.6log10(P)    p=10^(5/3*U-d)  d=9.333 c=5.6
            d=9.333;
            y=10.^(5/3*y-d);
            i=1;
        case {'@itf4','@ITF4'}
           chnls={'itf_1','itf_2','itf_3'};
           [z1,x1]=exl50db(CurrentShot,'itf','-3:4:0:001');
           [z,x]=exl50dbN(CurrentShot,chnls,'-3:4:0:001');
           y=z1(:,1)-(z(:,1)+z(:,2)+z(:,3));
           
       case '@ipg'
           [y1,t1]=exl50db(CurrentShot,'@ip',varargin{:});
           [y,x]=getGradient(y1,t1);
       case '@neg'
           [y1,t1]=exl50db(CurrentShot,'@mwi_ne002',varargin{:});
           [y,x]=getGradient(y1,t1);
       case '@ciiig'
           [y1,t1]=exl50db(CurrentShot,'vis003',varargin{:});
           [y,x]=getGradient(y1,t1);
       case '@dv'
           IPMIN=1.2; % kA  when larger than it, we can estimate the plasma positon
           
           chnls={'fdo','fdi','fuo','fui','ip'};
           [z,x]=exl50dbN(CurrentShot,chnls,varargin{:});
           Unit='cm';
           y=((z(:,1)+z(:,2))-(z(:,3)+z(:,4)))/2;
           ip=z(:,5);
           index=find(ip>=IPMIN);
           y(ip<IPMIN)=0;
           y(index)=y(index)./ip(index);
           % y value positive mean outer, minus  mean inner
       case '@dh'
           IPMIN=1.2; % kA  when larger than it, we can estimate the plasma positon
           posRef=0.35; % reference positon
           
           chnls={'fdo','fdi','fuo','fui','ip'};
           [z,x]=exl50dbN(CurrentShot,chnls,varargin{:});
           Unit='cm';
           y=((z(:,1)+z(:,3))-(z(:,2)+z(:,4)))/2;
           ip=z(:,5);
           index=find(ip>=IPMIN);
           y(ip<IPMIN)=0;
           y(index)=posRef-y(index)./ip(index);
           % y value positive mean outer, minus  mean inner
        otherwise
            switch lower(CurrentChannel(1))
                case '@' %smooth
                    [z,x,Unit]=exl50db(CurrentShot,CurrentChannel(2:length(CurrentChannel)),varargin{:});
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
                    [y,x,Unit]=exl50db(CurrentShot,CurrentChannel(2:length(CurrentChannel)));
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
                    
                     if nargout==4
                         x=reshape(tout,[numel(tout),1]);
                         y=reshape(f,[numel(f),1]);
                         varargout{1}=C;
                         Unit='kHz';
%                          Chs=CurrentChannel;
                     else
                         global MyPicStruct
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
            
    end
end

