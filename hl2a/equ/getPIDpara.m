function k=getPIDpara(b,init,varargin)
persistent  dFluxInit dFlux  kFactor tdFactor tiFactor rcFactor

if init==1 
    dFluxInit=max(b)-min(b);
    kFactor=1;
    tdFactor=1;
    tiFactor=1;
    rcFactor=1;
end
dFlux=max(b)-min(b);

disp(['dFlux=' num2str(dFlux) '/dFluxR=' num2str(dFlux/dFluxInit)])
if dFlux/dFluxInit<0.1
    tiFactor=0.8;
    kFactor=2;
end
if dFlux/dFluxInit<0.05
    tiFactor=0.5;
    kFactor=3;
end

% 
% 
% 
% 
% if init==1
%     dRZ100=(abs(dR(1,3))+abs(dZ(1,3))+dFlux)/100;
% end
% 
% %% adaptive algorithm
% if abs(dZ(1,3))>abs(dR(1,3))/4
%     
%     if abs(dZ(1,2))>dRZ100/20
%         cFactor=(dZ(1,3)-dZ(1,2))/dZ(1,2);
%         if cFactor>0.1 || cFactor<-0.9
%             debug=1;
%         end
%     else
%         cFactor=0;
%     end
%     
%     cRZ=abs(dZ(1,3))/dRZ100/100;
%     if (abs(dZ(1,3)-dZ(1,2))>abs(dZ(1,2)-dZ(1,1))) || abs(dZ(1,3))>dRZ100*100
%         if((dZ(1,3)-dZ(1,2))*(dZ(1,2)-dZ(1,1))>0) && cFactor>0.2 %same direction, more larger, need larger kFactoror
%             kFactor=1.1;
%             tdFactor=1.1;
%         end
%         if ((dZ(1,3)-dZ(1,2))*(dZ(1,2)-dZ(1,1))<0) && cFactor<-1 %change direction, more larger, need less kFactor
%             kFactor=0.92;
%             tdFactor=0.92;
%         end
%     end
%     disp('z dominant')
% else
%     disp('r dominant')
%     if abs(dR(1,2))>dRZ100/20
%         cFactor=(dR(1,3)-dR(1,2))/dR(1,2);
%         if cFactor>0.1 || cFactor<-0.9
%             debug=1;
%         end
%     else
%         cFactor=0;
%     end
%     
%     cRZ=abs(dR(1,3))/dRZ100/100;
%     if (abs(dR(1,3)-dR(1,2))>abs(dR(1,2)-dR(1,1))) || abs(dR(1,3))>dRZ100*100
%         if ((dR(1,3)-dR(1,2))*(dR(1,2)-dR(1,1))>0) && cFactor>0.2 %same direction, more larger, need larger kFactor or less kFactor
%             kFactor=1.1;
%             tdFactor=1.1;
%         end
%         if ((dR(1,3)-dR(1,2))*(dR(1,2)-dR(1,1))<0) && cFactor<-1 %same direction, more larger, need larger kFactor or less kFactor
%             kFactor=0.9;
%             tdFactor=0.9;
%         end
%     end
%     disp('r')
% end
% 
% 
% 
% %%**************************************************
% %  if   cFactor>0.1 || cFactor<-0.9
% if kFactor<0 
%     % return this step
%     
% %     
% %     dR=oldDR; % aging
% %     dZ=oldDZ; % aging
% %     
% %     iPF=[];
% %     dU=[];
% %     j=oldJ;
% %     Iex=oldIex;
% %     dir=interp1(dirFactor,dirY,cFactor,'linear','extrap');
% %     disp(['c=' num2str(cFactor)  '/dZ=' num2str(abs(dZ(1,3))) '/dR=' num2str(abs(dR(1,3))) '/dir=' num2str(dir)])
% 
% else
%     cRZ1=abs(dZ(1,3))/dRZ100/100;
%     cRZ2=abs(dR(1,3))/dRZ100/100;
%     disp(['cc=' num2str(cFactor)  '/dZ=' num2str(abs(dZ(1,3))) '/dR=' num2str(abs(dR(1,3)))])
%     
%     % if (abs(dZ(1,3))/dRZ100/100<0.03) && (abs(dR(1,3))/dRZ100/100<0.03) && ((dZ(1,3)-dZ(1,2))*(dZ(1,2)-dZ(1,1))<0) %oscillation
%     if (abs(dZ(1,3))/dRZ100/100<0.05) && (abs(dR(1,3))/dRZ100/100<0.05) && ((dZ(1,3)-dZ(1,2))*(dZ(1,2)-dZ(1,1))<0) %oscillation
%         if cFactor<-1
%             tiFactor=1.2; %reduce integration contribution
%         elseif cFactor>-0.1
%             tiFactor=0.8; %increase integration contribution
%         end
%     end
%     
%     
%     % avoiding stationary when offset is to large
%     
%     
%     % if cFactor<0 && cFactor>-0.05 && ((dR(1,3)-dR(1,2))*(dR(1,2)-dR(1,1))>0) && ((dR(1,3)-dR(1,2))*(dR(1,2)-dR(1,1))>0)
%     %     tiFactor=tiFactor*0.8;
%     % else
%     %     tiFactor=1;
%     % end
%     %
%     % if tiFactor<0.3
%     %     tiFactor=0.3;
%     % end
%     
%     % kFactor=kFactor*interp1(xFactor,yFactor,cFactor,'linear','extrap');
%     disp(['r=' num2str(interp1(xFactor,mFactor,max(abs(dR(1,3)),abs(dZ(1,3))),'linear','extrap'))  '/ti=' num2str(tiFactor) '/dF=' num2str(dFlux)])
%     
%     if init==2
%         kFactor=varargin{1};
%     end
%     
    
k=outPID(dFlux,init,kFactor,tdFactor,tiFactor,rcFactor);  %pid controller
% if k<0.1
%     k=0.1;
% elseif k>0.5
%     k=0.5;
% end

